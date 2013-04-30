class Stock < ActiveRecord::Base
  attr_accessible :store_location_id, :product_id, :quantity, :opening_balance
  belongs_to :store_location
  belongs_to :product
  
  
  def total_quantity
    quantity + opening_balance
  end
  

  
end
