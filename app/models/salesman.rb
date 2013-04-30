class Salesman < ActiveRecord::Base
  has_many :commissions, :dependent => :destroy
  has_many :products, :through => :commissions
  has_many :invoices
  
  after_create :generate_commission
  validates_presence_of(:name)
  validates_uniqueness_of :name
  
  
  def verify_destroy
    checked = false
    if commissions.size.zero?
      if invoices.size.zero?
        msg = (I18n.t("flashes.successfully_destroyed"))
        checked = true
        destroy
      else
        msg = (I18n.t("flashes.cannot_destroy_due_to"))
      end
    else
      msg = (I18n.t("flashes.cannot_destroy_due_to"))
    end
    
    return checked, msg
  end
  
  
  private
  
  def generate_commission
    Product.order("id").each do |c|
      cp = Commission.new
      cp.salesman_id = id
      cp.product_id = c.id
      cp.save!
    end
  end
  
end
