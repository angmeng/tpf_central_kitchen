class Cheque < ActiveRecord::Base
  attr_accessible :cheque_number, :bank_id, :reference_id, :cheque_type_id, :owner_name, :cheque_date, :clear, :bank_account_number

  belongs_to :bank
  
  def status
    if cheque_type_id == Setting::CUSTOMER_PAYMENT
      "<font style='color:red;'>No</font>"
    elsif cheque_type_id == Setting::SUPPLIER_PAYMENT
      "<font style='color:Green;'>Yes</font>"
    end
  end
  
  
  def self.get_current_date_own_cheque
    where("cheque_type_id = ? and cheque_date = ?", Setting::SUPPLIER_PAYMENT, Date.today).order("cheque_date")
  end
  
  def self.get_current_date_customer_cheque
    where("cheque_type_id = ? and cheque_date = ?", Setting::CUSTOMER_PAYMENT, Date.today).order("cheque_date")
  end
  
  def self.get_future_own_cheque
    where("cheque_type_id = ? and cheque_date >= ?", Setting::SUPPLIER_PAYMENT, Date.today).order("cheque_date")
  end
  
  def self.get_future_customer_cheque
    where("cheque_type_id = ? and cheque_date >= ?", Setting::CUSTOMER_PAYMENT, Date.today).order("cheque_date")
  end
  
end
