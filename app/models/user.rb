# coding: utf-8
class User < ActiveRecord::Base
  # new columns need to be added here to be writable through mass assignment
  attr_accessible :username, :email, :password, :password_confirmation, :department_id, :language
  
  belongs_to :department
  has_many :report_categories, :order => "name"
  has_many :stock_transfers
  attr_accessor :password
  before_save :prepare_password
  
  validates_presence_of :username, :department_id
  validates_uniqueness_of :username, :email, :allow_blank => true
  validates_format_of :username, :with => /^[-\w\._@]+$/i, :allow_blank => true, :message => "should only contain letters, numbers, or .-_@"
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates_length_of :password, :minimum => 4, :allow_blank => true
  
  SUPERADMIN = 1
  
  # login can be either username or email address
 
   def  language_option
     if language == Setting::ENGLISH
       "English"
     elsif language == Setting::CHINESE
       "华文"
     end
   end
  
  def self.authenticate(login, pass)
    user = find_by_username(login) || find_by_email(login)
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
