class OutletStaff < ActiveRecord::Base
  belongs_to :outlet
  has_many :outlet_purchase_orders
  
  attr_accessor :password
  before_save :prepare_password
  
  validates_presence_of :login, :fullname, :nickname, :outlet_id
  validates_uniqueness_of :login, :allow_blank => true
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates_length_of :password, :minimum => 6, :allow_blank => true

  def department_id
    0
  end
  
  def self.authenticate(login_name, pass)
    user = find_by_login(login_name)
    return user if user && user.matching_password?(pass)
  end
  
  def matching_password?(pass)
    self.password_hash == encrypt_password(pass)
  end
  
  def check_password(user)
    passed = false
    if user[:password].blank?
      msg = (I18n.t("flashes.pass_cant_be_blank"))
    else
      if user[:password].length < 5
        msg = (I18n.t("flashes.pass_must_over_six"))
      else
        if user[:password] != user[:password_confirmation]
          msg = (I18n.t("flashes.pass_confirm_failed"))
        else
          msg = (I18n.t("flashes.pass_changed"))
          self.update_attributes(user)
          passed = true
        end
      end
    end
    
    return passed, msg
  end
  
  def verify_destroy
    passed = false
    if id == User::SUPERADMIN
      msg = (I18n.t("flashes.cannot_destroy_builtin"))
    else
      destroy
      msg = (I18n.t("flashes.successfully_destroyed"))
      passed = true
    end
    
    return passed, msg
  end
  
  private
  
  def prepare_password
    unless password.blank?
      self.password_salt = Digest::SHA1.hexdigest([Time.now, rand].join)
      self.password_hash = encrypt_password(password)
    end
  end
  
  def encrypt_password(pass)
    Digest::SHA1.hexdigest([pass, password_salt].join)
  end
end
