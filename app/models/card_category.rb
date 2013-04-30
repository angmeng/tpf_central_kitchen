class CardCategory < ActiveRecord::Base
  attr_accessible :name, :description, :priority
  
  has_many :credit_cards
end
