class InvoiceItem < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :product
  belongs_to :store_location
  belongs_to :product_uom
  #validate :stock_must_be_there
  
  after_save :decrease_product_quantity
  after_destroy :increase_product_quantity
  
  #def stock_must_be_there
  #  errors.add_to_base("Not enough on hand quantity") unless quantity <= product.on_hand_quantity
  #end
  
  
  def total_amount
    quantity * unit_price
  end
  
  def total_cost
    quantity * product.average_cost
  end
  
  def total_profit
    total_amount - total_cost
  end
  
  private
  
  def increase_product_quantity
    product.stock_quantity += quantity
    product.save(false)
    st = Stock.find_by_store_location_id_and_product_id(store_location_id, product_id)
    st.quantity += quantity if st
    st.save! if st
    #invoice.customer.used_credit -= total_amount
    #invoice.customer.save!
    ProductMovement.sold_item_deleted(self, invoice, product.id)
  end
  
  def decrease_product_quantity
    product.stock_quantity -= quantity
    product.save(:validation => false)
    st = Stock.find_by_store_location_id_and_product_id(store_location_id, product_id)
    st = Stock.create(:store_location_id => 1, :product_id => product_id) unless st
    st.quantity -= quantity
    st.save!
    
    #invoice.customer.used_credit += total_amount
    #invoice.customer.save!
    ProductMovement.item_sold(self, invoice, product.id)
  end
  
end
