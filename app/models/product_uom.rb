class ProductUom < ActiveRecord::Base
  belongs_to :product
  has_many :invoice_uom_products, :class_name => 'Product', :foreign_key => 'invoice_uom_id'
  has_many :report_uom_products, :class_name => 'Product', :foreign_key => 'report_uom_id'
  has_many :po_uom_products, :class_name => 'Product', :foreign_key => 'po_uom_id'
  has_many :outlet_po_uom_products, :class_name => 'Product', :foreign_key => 'outlet_po_uom_id'
  has_many :outlet_purchase_order_items
  has_many :purchase_order_items
  has_many :invoice_items
  has_many :packing_order_items
  
  validates_presence_of(:name, :rate, :cost, :selling_price_a, :selling_price_b)
  validates_numericality_of(:cost, :selling_price_a, :selling_price_b, :rate)
  
  def selling_price(outlet)
    check = outlet.selling_category_id rescue -1 
    case check
    when ReferenceData::OUTLET_PRICING_A
      return selling_price_a
    when ReferenceData::OUTLET_PRICING_B
      return selling_price_b
    else
      return 0.0
    end
  
  end
  
  def calculate_quantity(item)
     (item.quantity * item.product_uom.rate / rate).round rescue 0
  end
  
end
