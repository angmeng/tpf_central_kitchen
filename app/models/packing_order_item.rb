class PackingOrderItem < ActiveRecord::Base
  belongs_to :packing_list
  belongs_to :store_location
  belongs_to :product
  belongs_to :product_uom
end
