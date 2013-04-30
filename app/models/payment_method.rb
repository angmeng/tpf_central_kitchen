class PaymentMethod < ActiveRecord::Base
  attr_accessible :name, :description, :priority
  
  has_many :customer_payments
  has_many :supplier_payments
  
  CASH = 1
  CHEQUE = 2
  CARD = 3
  
end
