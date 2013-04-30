class StoreLocation < ActiveRecord::Base
  attr_accessible :name, :description
  has_many :invoice_items
  has_many :purchase_invoice_items
  has_many :stocks, :dependent => :destroy
  has_many :products, :through => :stocks
  has_many :stock_adjustments
  has_many :stock_transfers
  has_many :outlet_delivery_order_items
  has_many :outlet_goods_receive_note_items
  has_many :purchase_order_items
  has_many :products
  has_many :packing_lists
  has_many :packing_order_items
  
  validates_presence_of :name
  validates_uniqueness_of(:name)
  
  after_create :create_default_stock
  
  MAIN_LOCATION = 1
  
  def verify_for_destroy
    checked = false
    if id == MAIN_LOCATION
      msg = (I18n.t("flashes.cannot_destroy_builtin"))
    else
      if invoice_items.size.zero?
        if purchase_invoice_items.size.zero?
          
          num = 0
          stocks.each {|s|
            num += 1 unless s.quantity == 0  
          }
          
          if num > 1
            msg = (I18n.t("flashes.adjust_quantity_first:"))
          else
            destroy
            checked = true
            msg = (I18n.t("flashes.successfully_destroyed"))
          end
          
        else
          msg = "location cannot be delete due to having purchase invoice item"
        end
      else
        msg = "location cannot be delete due to having invoice item"
      end
    end
    
    
    return checked, msg
  end
  
  private
  
  def create_default_stock
    Product.order("id").each do |p|
      stocks.create(:product_id => p.id)
    end
  end
  
end
