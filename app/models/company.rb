class Company < ActiveRecord::Base
  has_many :purchase_invoices
  has_many :invoices
  
  validates_uniqueness_of :name
  validates_presence_of(:name)
  
  
  def verify_destroy
    checked = false
    if purchase_invoices.size.zero?
      if invoices.size.zero?
        if id == 1
          msg = (I18n.t("flashes.cannot_destroy_builtin"))
        else
          checked = true
          destroy
          msg = (I18n.t("flashes.successfully_destroyed"))
        end
      else
        msg = (I18n.t("flashes.cannot_destroy_due_to"))
      end
    else
      msg = (I18n.t("flashes.cannot_destroy_due_to"))
    end
    
    return checked, msg
  end
end
