class PurchaseInvoice < ActiveRecord::Base
  
  belongs_to :supplier
  belongs_to :company
  has_many :purchase_invoice_items
  
  attr_accessible :company_id, :invoice_date, :invoice_number, :supplier_id, :remark, :void, :purchase_invoice_item_attributes
  
  validates_presence_of(:invoice_date, :supplier_id)
  
  delegate :code, :name, :address, :office_phone, :fax_number, :contact_person, :contact_number, :active, :remark, :to => :supplier, :prefix => true
  scope :active, lambda { where("deleted = false") }
  scope :hidden,  lambda { where("deleted = true") }
  
  def purchase_invoice_item_attributes=(purchase_invoice_item_attributes)
    purchase_invoice_item_attributes.each do |attributes|
      unless attributes[:quantity].blank? or attributes[:quantity].index(/[abcdefghijklmnopqrstuvwxyz]/) or attributes[:unit_price].blank? 
        purchase_invoice_items.build(attributes)
      end
    end
  end
  
  def generate_invoice_number
    setting = Setting.first
    self.invoice_number = setting.purchase_invoice_code + (setting.purchase_invoice_last_number + 1).to_s
  end
  
  def total_amount
    total = 0.0
    purchase_invoice_items.each do |c|
      total += c.total_amount
    end
    total
  end
  
  def verify_for_destroy
    checked = false
    setting = Setting.first
    if invoice_number.eql?(setting.purchase_invoice_code + setting.purchase_invoice_last_number.to_s)
      purchase_invoice_items.each do |c|
        c.destroy
      end
      destroy
      setting.purchase_invoice_last_number -= 1
      setting.save
      checked = true
    end
    
  end
  
end
