class OutletGoodsReceiveNote < ActiveRecord::Base
  has_many :outlet_goods_receive_note_items
  belongs_to :outlet
  
  #validates_presence_of(:delivery_order_date, :outlet_id)
  
  #delegate :code, :name, :address, :office_phone, :fax_number, :contact_person, :contact_number, :active, :remark, :to => :supplier, :prefix => true
  
  def outlet_goods_receive_note_item_attributes=(outlet_goods_receive_note_item_attributes)
    outlet_goods_receive_note_item_attributes.each do |attributes|
      unless attributes[:quantity].blank? or attributes[:quantity].index(/[abcdefghijklmnopqrstuvwxyz]/) or attributes[:unit_price].blank? 
        outlet_goods_receive_note_items.build(attributes)
      end
    end
  end
  
  def generate_order_number
    setting = Setting.first
    self.grn_number = setting.grn_code + (setting.grn_last_number + 1).to_s
  end
  
  def total_amount
    total = 0.0
    outlet_goods_receive_note_items.each do |c|
      total += c.total_amount
    end
    total
  end
  
  def verify_for_destroy
    checked = false
    setting = Setting.first
    if grn_number.eql?(setting.grn_code + setting.grn_last_number.to_s)
      outlet_goods_receive_note_items.each do |c|
        c.destroy
      end
      destroy
      setting.grn_last_number -= 1
      setting.save
      checked = true
    end
    
  end
end
