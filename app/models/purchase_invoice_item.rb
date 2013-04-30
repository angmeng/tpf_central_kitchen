class PurchaseInvoiceItem < ActiveRecord::Base
  belongs_to :purchase_invoice
  belongs_to :product
  belongs_to :store_location
  attr_accessible :purchase_invoice_id, :product_id, :quantity, :unit_price, :remark, :store_location_id
  
  after_save :increase_product_quantity
  after_destroy :decrease_product_quantity
  
  def total_amount
    quantity * unit_price
  end
  
  def increase_product_quantity
    product.stock_quantity += quantity
    product.save(false)
    st = Stock.find_by_store_location_id_and_product_id(store_location_id, product_id)
    st = Stock.create(:store_location_id => store_location_id, :product_id => product_id) unless st
    st.quantity += quantity
    st.save!
    purchase_invoice.supplier.used_credit += total_amount
    purchase_invoice.supplier.save!
    ProductMovement.item_purchased(self, purchase_invoice, product.id)
  end
  
  def decrease_product_quantity
    product.stock_quantity -= quantity
    product.save(false)
    st = Stock.find_by_store_location_id_and_product_id(store_location_id, product_id)
    st.quantity -= quantity
    st.save!
    purchase_invoice.supplier.used_credit -= total_amount
    purchase_invoice.supplier.save!
    ProductMovement.purchased_item_deleted(self, purchase_invoice, product.id)
  end
  
end
