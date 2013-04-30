class CreditCard < ActiveRecord::Base
  attr_accessible :card_number, :bank_id, :reference_id, :card_type_id, :card_category_id, :owner_name, :clear

  belongs_to :card_category
  belongs_to :bank

end
