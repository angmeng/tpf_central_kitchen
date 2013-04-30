class PurchaseOrderItem < ActiveRecord::Base
  belongs_to :purchase_order
  belongs_to :store_location
  belongs_to :product
  belongs_to :product_uom
  #belongs_to :store_location
  #attr_accessible :purchase_invoice_id, :product_id, :quantity, :unit_price, :remark, :store_location_id
  
  #after_save :increase_product_quantity
  #after_destroy :decrease_product_quantity
  
  def total_amount
    quantity * unit_price
  end
  
  
end
