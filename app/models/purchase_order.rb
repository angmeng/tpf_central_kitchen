class PurchaseOrder < ActiveRecord::Base
  belongs_to :supplier
  #belongs_to :company
  has_many :purchase_order_items
  belongs_to :outlet_purchase_order
  
  
  validates_presence_of(:purchase_order_date, :supplier_id)
  
  delegate :code, :name, :address, :office_phone, :fax_number, :contact_person, :contact_number, :active, :remark, :to => :supplier, :prefix => true
  scope :active, lambda { where("deleted = false") }
  scope :hidden, lambda { where("deleted = true") }
  
  def mark_as_completed
    self.settled = true
    save!
  end

  def current_status
    settled ? "<em style='color:green'>Settled</em>" : "<em style='color:red'>Pending</em>"
  end
  
  def purchase_order_item_attributes=(purchase_order_item_attributes)
    purchase_order_item_attributes.each do |attributes|
      unless attributes[:quantity].blank? or attributes[:quantity].index(/[abcdefghijklmnopqrstuvwxyz]/) or attributes[:unit_price].blank? 
        purchase_order_items.build(attributes)
      end
    end
  end
  
  def add_order_items(items)
    name = items[:product_name]
    unless name.blank?
      combine = name.split("-")
      found_product = Product.find_by_code(combine[0])
      
      unless items[:quantity].blank? or items[:quantity].index(/[abcdefghijklmnopqrstuvwxyz]/) or found_product.nil?
       item = purchase_order_items.new
       item.product = found_product
       found_uom = found_product.product_uoms.find(found_product.po_uom_id)
       unless found_uom
         found_uom = found_product.product_uoms.first
         unless found_uom
           found_uom = found_product.create_default_uom
         end
       end
       item.unit_price = found_uom.cost
       item.product_uom_id = found_uom.id
       item.quantity = items[:quantity]
       item.save!
      end
     end
  end
  
  def generate_order_number
    setting = Setting.first
    self.purchase_order_number = setting.purchase_order_code + (setting.purchase_order_last_number + 1).to_s
  end
  
  def total_amount
    total = 0.0
    purchase_order_items.each do |c|
      total += c.total_amount
    end
    total
  end
  
  def verify_for_destroy
    checked = false
    setting = Setting.first
    if purchase_order_number.eql?(setting.purchase_order_code + setting.purchase_order_last_number.to_s)
      #purchase_order_items.each do |c|
      #  c.destroy
      #end
      #destroy
      self.deleted = true
      save
      setting.purchase_order_last_number -= 1
      setting.save
      checked = true
    end
    checked
  end
end
