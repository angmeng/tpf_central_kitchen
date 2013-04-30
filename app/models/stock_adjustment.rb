class StockAdjustment < ActiveRecord::Base
  attr_accessible :name, :description, :store_location_id, :product_id, :quantity
  belongs_to :store_location
  belongs_to :product
  
  validates_presence_of :name, :quantity
  validates_numericality_of(:quantity)
  
  after_create :increase_stock
  after_destroy :decrease_stock
  


  protected
  
  def validate
    errors.add(:quantity, "cannot contain the minus sign") if quantity < 0
  end
  
  
  private
  
  def increase_stock
    st = store_location.stocks.find_by_product_id(product_id)
    if debit
      st.quantity += quantity
    else
      st.quantity -= quantity
    end
  
    st.save!
    ProductMovement.stock_adjustment(true, self)
    
  end
  
  def decrease_stock
    st = store_location.stocks.find_by_product_id(product_id)
    if debit
      st.quantity -= quantity
    else
      st.quantity += quantity
    end
  
    st.save!
    ProductMovement.stock_adjustment(false, self)
  end
  
  
  
end
