class DeliveryOrderItem < ActiveRecord::Base
  attr_accessible :delivery_order_id, :product_id, :product_uom_id, :quantity, :store_location_id
  belongs_to :delivery_order
  belongs_to :product
  belongs_to :product_uom
  belongs_to :store_location
end
