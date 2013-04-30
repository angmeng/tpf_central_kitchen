class StockTransfer < ActiveRecord::Base
  belongs_to :user
  belongs_to :store_location
  belongs_to :product
  
  attr_protected(:id)
  
  validates_numericality_of :quantity
  validates_presence_of :quantity, :from_store_location_id, :store_location_id, :product_id
  
  after_create :increase_stock
  after_destroy :decrease_stock
  
  def check_quantity
    checked = false
    quantity_condition = quantity.to_i rescue quantity_condition = 0
    
    if quantity_condition <= 0  
      msg = "Quantity must greater than 0"
    else
      stock = Stock.find_by_product_id_and_store_location_id(product_id, from_store_location_id)
      if stock 
        if stock.quantity < quantity.to_i
          msg = "Stock has not enough quantity to transfer"
        else
          checked = true
          msg = "Stock Transfered"
        end
      else
        msg = "There is no such product in this store location"
      end
    end
    
    return checked, msg
    
  end
  
  def from_store_location_name
    StoreLocation.find(from_store_location_id).name rescue "Unknown"
  end
  
  
  private
  
  def increase_stock
    st = store_location.stocks.find_by_product_id(product_id)
    if st
      st.quantity += quantity
      st.save!
    end
  
    from_store = StoreLocation.find(from_store_location_id)
    st2 = from_store.stocks.find_by_product_id(product_id)
    
    if st2
      st2.quantity -= quantity
      st2.save!
    end
    
    generate_movement
  end
  
  def decrease_stock
    st = store_location.stocks.find_by_product_id(product_id)
    if st
      st.quantity -= quantity
      st.save!
    end
  
    from_store = StoreLocation.find(from_store_location_id)
    st2 = from_store.stocks.find_by_product_id(product_id)
    
    if st2
      st2.quantity += quantity
      st2.save!
    end
    
    destroy_movement
  end
  
  def generate_movement
    ProductMovement.add_stock_transfer(self)
  end
  
  def destroy_movement
    ProductMovement.destroy_stock_transfer(self)
  end
  
  
end
