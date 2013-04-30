class CustomerPayment < ActiveRecord::Base
  attr_accessible :payment_date, :customer_id, :reference_number, :resit_number, :description, :payment_method_id, :amount

  belongs_to :payment_method
  belongs_to :customer
  validates_presence_of :payment_date, :customer_id, :payment_method_id, :amount
  validates_numericality_of(:amount)
  
  after_create :increase_customer_paid_credit
  after_destroy :decrease_customer_paid_credit
  
  def saving(payment_id, extra)
    checked = false
    case payment_id.to_i
      when PaymentMethod::CASH
        
        if save
          checked = true
        else
          
        end
    
      when PaymentMethod::CHEQUE
        
        cheque = Cheque.new(extra)
        if valid? && cheque.valid?
          save!
          cheque.cheque_type_id = Setting::CUSTOMER_PAYMENT
          cheque.reference_id = id
          cheque.amount = amount
          cheque.save!
          checked = true
        else
        end
        
      when PaymentMethod::CARD
      
        card = CreditCard.new(extra)
        if valid? && card.valid?
          save!
          card.card_type_id = Setting::CUSTOMER_PAYMENT
          card.reference_id = id
          card.amount = amount
          card.save!
          checked = true
        else
        end
    end
    
    return checked
    
  end
  
  
  private
  
  def increase_customer_paid_credit
    customer.paid_credit += amount
    customer.save!
  end
  
  def decrease_customer_paid_credit
    customer.paid_credit -= amount
    customer.save!
    
    if payment_method_id == PaymentMethod::CHEQUE
      Cheque.find_by_reference_id(id).destroy rescue nil
    elsif payment_method_id == PaymentMethod::CARD
      CreditCard.find_by_reference_id(id).destroy rescue nil
    end
  end
  
  
  


end
