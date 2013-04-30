class Expense < ActiveRecord::Base
  attr_accessible :expense_date, :title, :description, :amount
  
  validates_presence_of :title, :amount
  validates_numericality_of(:amount)
  
  def self.calculate_expenses(from, to)
    
    ex = where("expense_date IN (?)", from..to)
    total = ex.inject(0) {|sum, item| sum + item.amount}
    total
  end
  
end
