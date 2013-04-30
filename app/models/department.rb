class Department < ActiveRecord::Base
  attr_accessible :name, :description, :message, :builtin, :accessible_menu_ids
  
  has_many :users
  has_many :document_authorizations
  has_many :document_categories, :through => :document_authorizations
  has_many :authorizations
  has_many :accessible_menus, :through => :authorizations
  
  ADMIN = 1
  CLERK = 2
  DOCUMENT = 3
  STORE = 4
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  after_create :create_document_category
  
  def verify_destroy
    passed = false
  
      if builtin
        msg = (I18n.t("flashes.cannot_destroy_builtin"))
      else
        if users.size.zero?
          destroy
          msg = (I18n.t("flashes.successfully_destroyed"))
          passed = true
        else
          msg = (I18n.t("flashes.cannot_destroy_due_to"))
        end
      end

    return passed, msg
  end
  
  private
  
  def create_document_category
    DocumentAuthorization.create(:department_id => id, :document_category_id => 1)  
  end
  
end
