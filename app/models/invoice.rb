class Invoice < ActiveRecord::Base
  belongs_to :outlet
  belongs_to :company
  has_many :invoice_items
  has_one  :delivery_order
  belongs_to :outlet_purchase_order
  
  validates_presence_of(:invoice_number, :invoice_date, :outlet_id)
  #after_create :generate_commission
  
  scope :active, lambda { where("deleted = false") }
  scope :hidden, lambda { where("deleted = true") }
  scope :get_sales_from, lambda {|from, to| where("invoice_date IN (?)", from..to) }
  
  def mark_as_completed
    self.settled = true
    save!
  end

  def current_status
    settled ? "<em style='color:green'>Settled</em>" : "<em style='color:red'>Pending</em>"
  end
  
  
  def self.check_quantity(invoice_item_attributes)
    msg = []
    found = false
    invoice_item_attributes.each do |attributes|
      unless attributes[:quantity].blank? or attributes[:quantity].index(/[abcdefghijklmnopqrstuvwxyz]/) or attributes[:unit_price].blank? 

        st = Stock.find_by_product_id_and_store_location_id(attributes[:product_id].to_i, attributes[:store_location_id].to_i)
        unless attributes[:quantity].to_i <= st.total_quantity
          found = true
          msg << st.product.name + (I18n.t("flashes.not_enough_stock")) + st.store_location.name
        end
      end
    end
    if found
      msg_error = ""
      msg.each {|m| msg_error += m + "<br />"}
    end
    return found, msg_error
  end
  
  def add_invoice_items(items)
    name = items[:product_name]
    unless name.blank?
      combine = name.split("-")
      found_product = Product.find_by_code(combine[0])
      unless items[:quantity].blank? or items[:quantity].index(/[abcdefghijklmnopqrstuvwxyz]/) or found_product.nil?
       item = invoice_items.new
       item.product = found_product
       item.store_location_id = items[:store_location_id]
       found_uom = found_product.product_uoms.find(found_product.invoice_uom_id)
       unless found_uom
         found_uom = found_product.product_uoms.first
         unless found_uom
           found_uom = found_product.create_default_uom
         end
       end
       item.unit_price = found_uom.selling_price(outlet)
       item.product_uom_id = found_uom.id
       item.quantity = items[:quantity]
       item.save!
      end
     end
  end

  def receive_items(product)
     product.each do |product_id, content|
      unless invoice_items.find_by_product_id(product_id.to_i) or content[:quantity].blank? or content[:quantity].index(/[abcdefghijklmnopqrstuvwxyz]/) 
        n = invoice_items.new(:product_id => product_id.to_i, :quantity => content[:quantity].to_i)
        found_product = Product.find(product_id)
        found_uom = found_product.product_uoms.find(content[:product_uom_id].to_i) rescue false
        unless found_uom
          found_uom = found_product.product_uoms.first
          unless found_uom
            found_uom = found_product.create_default_uom
          end
        end
        n.unit_price = found_uom.selling_price(outlet)
        n.product_uom_id = found_uom.id
        n.save!
      end
    end
  end
  
  def invoice_item_attributes=(invoice_item_attributes)
    invoice_item_attributes.each do |attributes|
      unless attributes[:quantity].blank? or attributes[:quantity].index(/[abcdefghijklmnopqrstuvwxyz]/) 
        cp = CustomerPricing.find_by_customer_id_and_product_id(customer_id, attributes[:product_id].to_i)
        attributes[:unit_price] = cp.amount 
        #product = Product.find(attributes[:product_id].to_i)
        st = Stock.find_by_product_id_and_store_location_id(attributes[:product_id].to_i, attributes[:store_location_id].to_i)
        if attributes[:quantity].to_i <= st.total_quantity
          invoice_items.build(attributes)
        end
      end
    end

  end
  
  def generate_invoice_number
    setting = Setting.first
    self.invoice_number = setting.invoice_code + (setting.invoice_last_number + 1).to_s
  end
  
  def total_amount
    total = 0.0
    invoice_items.each do |c|
      total += c.total_amount
    end
    total
  end
  
  def verify_for_destroy
    checked = false
    setting = Setting.first
    if invoice_number.eql?(setting.invoice_code + setting.invoice_last_number.to_s)
      invoice_items.each do |c|
        c.destroy
      end
      destroy
      setting.invoice_last_number -= 1
      setting.save
      checked = true
    end
    
    checked
    
  end
  
  def total_cost
    total = 0.0
    invoice_items.each do |c|
      product = c.product
      total += c.quantity * product.average_cost
    end
    total
  end
  
  
  def total_profit
    total_amount - total_cost
  end
  
  def self.calculate_each_report_category(user, invoices)
    result = []
    
    user.report_categories.each do |r|
      r.total_sales = 0.0
      r.total_profit = 0.0
      result << r
    end
    
    invoices.each do |i|
      i.invoice_items.each do |it|
        result.each do |rs|
          rs.report_category_items.each do |rci|
            if rci.product_category_id == it.product.product_category_id
              rs.total_sales += it.total_amount
              rs.total_profit += it.total_profit
            end
          end
        end
      end
    end
    result
  end
  
  private
  
  def generate_commission
    invoice_items.each do |i|
      comm = Commission.find_by_salesman_id_and_product_id(salesman_id, i.product_id)   
      i.commission = comm.percentage
      i.save!
    end
    
  end
  
end
