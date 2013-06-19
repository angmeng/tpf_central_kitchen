class OutletPurchaseOrder < ActiveRecord::Base
  belongs_to :outlet
  belongs_to :outlet_staff
  has_attached_file :import_pr_item,
      :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
      :url => "/system/:attachment/:id/:style/:filename"
      #, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  has_many :purchase_orders
  has_one :invoice
  has_many :outlet_purchase_order_items, :dependent => :destroy
  has_one :packing_list
  belongs_to :master_purchase_order, :class_name => "OutletPurchaseOrder"

  # validates_attachment :import_pr_item, :content_type => {:content_type => ['application/excel','application/vnd.ms-excel','application/vnd.msexcel']},
  #                                   :message => ' must be a document of Excel',
  #                                   :if => Proc.new { |imports| !imports.import_pr_item_file_name.blank? }
  validates_presence_of(:purchase_order_date, :outlet_id)
  
  scope :unsettled, lambda { where("settled = false and void = false and deleted = false") }
  scope :settled, lambda {where("settled = true and void = false and deleted = false and status_id = ?", ReferenceData::PO_DONE) }


  def import_items
    Spreadsheet.client_encoding = 'UTF-8'
    file = Rails.root.to_s + "/public" + import_pr_item.url.split("?")[0]
    book = Spreadsheet.open file
    # 
    sheet1 = book.worksheet 0
    count = 0
    sheet1.each do |row|
      count += 1
      # do something interesting with a row
      if count > 1
        code       = row[0]
        quantity   = row[2]
        product = Product.find_by_code(code)
        if product
          found_uom = ProductUom.find(product.outlet_po_uom_id)
          unless quantity.nil? or quantity.blank? or quantity.to_i == 0
            item = outlet_purchase_order_items.find_by_product_id(product.id)
            if item
              item.quantity += quantity
            else
              item = outlet_purchase_order_items.new(:product_uom_id => found_uom.id,:product_id => product.id, :store_location_id => product.store_location_id, :quantity => quantity)
              item.unit_price = found_uom.selling_price(outlet)
            end
            item.save!
          end
        end
      end
    end
  end

  def mark_as_completed
    self.settled = true
    self.status_id = ReferenceData::PO_DONE
    save!
  end
  
  def receive_items(product)
     product.each do |product_id, content|
      unless outlet_purchase_order_items.find_by_product_id(product_id.to_i) or content[:quantity].to_i == 0 or content[:quantity].blank? or content[:quantity].index(/[abcdefghijklmnopqrstuvwxyz]/)
        n = outlet_purchase_order_items.new(:product_id => product_id.to_i, :quantity => content[:quantity].to_i)
        found_product = Product.find(product_id)
        found_uom = found_product.product_uoms.find(content[:product_uom_id].to_i) rescue false
        unless found_uom
          found_uom = found_product.product_uoms.first
          unless found_uom
            found_uom = found_product.create_default_uom
          end
        end
        n.store_location_id = found_product.store_location_id
        n.unit_price = found_uom.selling_price(outlet)
        n.product_uom_id = found_uom.id
        n.save!
      end
    end
  end

  def confirmed?
    confirmed_by > 0
  end
  
  def send_to_central
    if status_id < ReferenceData::PO_SENT
      self.status_id = ReferenceData::PO_SENT
      save!
    end
  end
  
  def sent?
    self.status_id >= ReferenceData::PO_SENT
  end
  
  def not_yet_sent?
    self.status_id == ReferenceData::PO_PREPARING
  end

  def po_sent_to_central_central_stage?
    self.status_id == ReferenceData::PO_SENT
  end
  
  def status
    case status_id
    when ReferenceData::PO_PREPARING
      "<em style='color:red'>Outlet Preparing</em>"
    when ReferenceData::PO_SENT
      "<em style='color:brown'>Sent to Central</em>"
    when ReferenceData::PO_PROCESSING
      "<em style='color:blue'>Central Processing</em>"
    when ReferenceData::PO_DONE
      "<em style='color:green'>Completed</em>"
    end
  end

  def self.grouping_packing_and_invoice(po_ids, user_id, outlet_id)
    master = OutletPurchaseOrder.new
    master.purchase_order_date = Date.today
    master.confirmed_by    = user_id
    #master.outlet_staff_id = user_id
    master.outlet_id = outlet_id
    master.status_id = ReferenceData::PO_SENT
    master.generate_order_number
    if master.save
      Setting.increment_of_outlet_purchase_order
      grouped_po_numbers = []
      po_ids.each do |po_id|
        outlet_purchase_order = OutletPurchaseOrder.find(po_id)
        grouped_po_numbers << outlet_purchase_order.purchase_order_number
        outlet_purchase_order.outlet_purchase_order_items.each do |i|
          item = master.outlet_purchase_order_items.find_by_product_id(i.product_id)
          item = master.outlet_purchase_order_items.new(:product_uom_id => i.product_uom_id, :product_id => i.product_id, :store_location_id => i.store_location_id, :unit_price => i.unit_price) unless item
          item.quantity += i.quantity
          item.save!
        end
        outlet_purchase_order.is_grouped = true
        outlet_purchase_order.master_purchase_order_id = master.id
        outlet_purchase_order.save!
      end
    end
    master.update_attributes(:remark => "Combined from POs : #{grouped_po_numbers.join(', ')}")
    master.generate_packing_and_invoice
    master
  end
  
  def generate_packing_and_invoice
    packing_products = []
    order_products = []
    outlet_purchase_order_items.each do |i|
      if i.product.central_product?
        packing_products << i
      else
        order_products << i
      end
    end
    
    generate_packing_list(packing_products)
    generate_purchase_order(order_products)
    self.status_id = ReferenceData::PO_PROCESSING
    save!
  end
  
  def add_order_items(items)
    name = items[:product_name]
    unless name.blank?
      combine = name.split("(")
      found_product = Product.find_by_code(combine[0].strip)
      
      unless items[:quantity].blank? or items[:quantity].index(/[abcdefghijklmnopqrstuvwxyz]/) or found_product.nil?
        if item = outlet_purchase_order_items.find_by_product_id(found_product.id)
          item.quantity += items[:quantity].to_i
          item.save!
        else
          item = outlet_purchase_order_items.new
          item.product = found_product
          found_uom = found_product.product_uoms.find(found_product.outlet_po_uom_id)
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
  end
  
  def generate_order_number
    setting = Setting.first
    self.purchase_order_number = setting.outlet_purchase_order_code + (setting.outlet_purchase_order_last_number + 1).to_s
  end
  
  def total_amount
    total = 0.0
    outlet_purchase_order_items.each do |c|
      total += c.total_amount
    end
    total
  end
  
  def verify_destroy
    purchase_orders.each do |p|
      p.update_attributes(:void => true, :deleted => true)
    end
    packing_list.update_attribute(:void, true) if packing_list
    invoice.update_attributes(:void => true, :deleted => true) if invoice
    self.deleted = true
    self.void = true
    save!
  end

  def update_item_status(item)
    packing_item_group = []
    po_item_group = []
    item.each do |item_id, content|
      po_item = OutletPurchaseOrderItem.find(item_id.to_i)
      
      case content[:status_id].to_i
      when ReferenceData::PO_ITEM_SENT_TO_CENTRAL
        po_item.product.store_location_id = content[:store_location_id].to_i
        po_item.store_location_id = content[:store_location_id].to_i
        packing_item_group << po_item
      when ReferenceData::PO_ITEM_SENT_TO_SUPPLIER
        po_item.product.outlet_product_suppliers.create!(:supplier_id => content[:supplier_id].to_i, :outlet_id => outlet_id)
        po_item_group << po_item
      end
    end
    generate_packing_list(packing_item_group)
    generate_purchase_order(po_item_group)
  end
  
  private

  def generate_packing_list(prepared_products)
     prepared_products.each do |i|
       list = packing_list
       unless list
         list = create_packing_list
         list.outlet_id = outlet_id
         list.packing_date = Date.today.to_s
         list.store_location_id = 0
         list.save!
       end
       
       item = list.packing_order_items.find_by_product_id(i.product_id)
       item = list.packing_order_items.new unless item
       item.store_location_id = i.product.store_location_id
       item.product_id = i.product_id
       found_uom = check_product_uom(i.product, i.product.packing_uom_id)
       item.product_uom_id = found_uom.id
       item.quantity += found_uom.calculate_quantity(i)
       item.picked_quantity += found_uom.calculate_quantity(i)
       item.save!
       i.status_id = ReferenceData::PO_ITEM_SENT_TO_CENTRAL
       i.save!
     end
  end
 
  def generate_purchase_order(prepared_order_items)
     group_supplier = []
     prepared_order_items.each do |p|
       @found = nil
       selected = p.outlet_purchase_order.outlet.outlet_product_suppliers.find_by_product_id(p.product_id)
       if selected
         group_supplier.each do |g|
           if g.id == selected.supplier_id
             @found = g
           end
         end
         if @found
           @found.prepared_products << p
         else
           @found = selected.supplier
           @found.prepared_products = []
           @found.prepared_products << p
           group_supplier << @found
         end
         p.status_id = ReferenceData::PO_ITEM_SENT_TO_SUPPLIER
       else
         p.status_id = ReferenceData::PO_ITEM_UNCATEGORIZED
       end
       p.save!
       
     end
     create_po(group_supplier)
  end
 
 
  def create_po(suppliers)
    suppliers.each do |p|
      a = purchase_orders.find_by_supplier_id(p.id)
      unless a
        a = purchase_orders.new
        a.purchase_order_date = Date.today
        a.supplier = p
        a.generate_order_number
        a.save!
        Setting.increment_of_purchase_order
      end
      
      p.prepared_products.each do |i|
        b = a.purchase_order_items.find_by_product_id(i.product_id)
        b = a.purchase_order_items.new unless b
        b.product = i.product
        found_uom = check_product_uom(i.product, i.product.po_uom_id)
        b.product_uom_id = found_uom.id
        b.store_location_id = i.product.store_location_id
        b.quantity += found_uom.calculate_quantity(i)
        b.unit_price = found_uom.cost
        b.save!
      end
    end
  end

  def check_product_uom(checked_product, checked_uom_id)
    found_uom = checked_product.product_uoms.find(checked_uom_id) rescue false
    unless found_uom
      found_uom = checked_product.product_uoms.first
      unless found_uom
        found_uom = checked_product.create_default_uom
      end
    end
    found_uom
  end
  
end
