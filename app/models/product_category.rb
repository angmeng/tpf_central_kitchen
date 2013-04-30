class ProductCategory < ActiveRecord::Base
  has_many :products
  has_many :report_category_items
  attr_accessible :name, :description
  
  
  validates_presence_of(:name)
  validates_uniqueness_of(:name)
  
  def verify_destroy
    checked = false
    if products.size.zero?
      if report_category_items.size.zero?
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
  
  
  
end
