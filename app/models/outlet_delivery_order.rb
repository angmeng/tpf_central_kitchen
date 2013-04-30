class OutletDeliveryOrder < ActiveRecord::Base
  belongs_to :outlet
  #belongs_to :company
  has_many :outlet_delivery_order_items, :dependent => :destroy
  
  attr_accessible :delivery_order_date, :delivery_order_number, :outlet_id, :remark, :outlet_delivery_order_item_attributes
  
  validates_presence_of(:delivery_order_date, :outlet_id)
  
  #delegate :code, :name, :address, :office_phone, :fax_number, :contact_person, :contact_number, :active, :remark, :to => :supplier, :prefix => true
  
  def outlet_delivery_order_item_attributes=(outlet_delivery_order_item_attributes)
    outlet_delivery_order_item_attributes.each do |attributes|
      unless attributes[:quantity].blank? or attributes[:quantity].index(/[abcdefghijklmnopqrstuvwxyz]/) or attributes[:unit_price].blank? 
        outlet_delivery_order_items.build(attributes)
      end
    end
  end
  
  def generate_order_number
    setting = Setting.first
    self.outlet_delivery_order_number = setting.outlet_delivery_order_code + (setting.outlet_delivery_order_last_number + 1).to_s
  end
  
  def total_amount
    total = 0.0
    outlet_purchase_order_items.each do |c|
      total += c.total_amount
    end
    total
  end
  
  def verify_for_destroy
    checked = false
    setting = Setting.first
    if outlet_delivery_order_number.eql?(setting.outlet_delivery_order_code + setting.outlet_delivery_order_last_number.to_s)
      outlet_delivery_order_items.each do |c|
        c.destroy
      end
      destroy
      setting.outlet_delivery_order_last_number -= 1
      setting.save
      checked = true
    end
    
  end
end
