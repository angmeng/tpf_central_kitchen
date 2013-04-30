class Bank < ActiveRecord::Base
  attr_accessible :name, :description, :priority
  
  has_many :cheques
  has_many :credit_card
  
 
  
end
