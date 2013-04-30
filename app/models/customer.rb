class Customer < ActiveRecord::Base
  has_many :invoices
  has_many :customer_payments
  has_many :customer_pricings, :dependent => :destroy
  has_many :products, :through => :customer_pricings
  attr_accessible :code, :name, :ic_number, :gender, :address, :mobile_number, :home_phone_number, :office_phone_number, :fax_number, :credit_limit, :used_credit, :suspend, :additional_phone_one, :additional_phone_two
  validates_presence_of(:name)
  validates_uniqueness_of(:name, :code)
  validates_numericality_of(:credit_limit)
  after_create :generate_code
  after_create :generate_pricing
  
  MALE = "Male"
  FEMALE = "Female"
  
  GENDER_LIST = [
  ["Male", MALE],
  ["Female", FEMALE]
  ].freeze
  
  
  def verify_for_destroy
    checked = false
    if customer_payments.size.zero?
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
  
  def current_credit
    used_credit - paid_credit
  end
  
  private
  
  def generate_code
    setting = Setting.first
    self.code = setting.ar_code + (setting.ar_last_number + 1).to_s
    save
    setting.ar_last_number += 1
    setting.save
  end
  
  def generate_pricing
    Product.all.each do |c|
      cp = CustomerPricing.new
      cp.customer_id = id
      cp.product_id = c.id
      cp.save!
    end
  end
  
  
end
