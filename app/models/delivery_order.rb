class DeliveryOrder < ActiveRecord::Base
  attr_accessible :company_id, :delivery_date, :delivery_order_number, :invoice_id, :outlet_id, :remark, :void
  belongs_to :invoice
  belongs_to :outlet
  has_many   :delivery_order_items

  
end
