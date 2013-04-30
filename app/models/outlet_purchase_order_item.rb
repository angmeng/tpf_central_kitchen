class OutletPurchaseOrderItem < ActiveRecord::Base
  belongs_to :outlet_purchase_order
  belongs_to :product
  belongs_to :product_uom
  

  #attr_accessible :purchase_invoice_id, :product_id, :quantity, :unit_price, :remark, :store_location_id
  
  #after_save :increase_product_quantity
  #after_destroy :decrease_product_quantity
  
  def status
    case status_id
    when ReferenceData::PO_ITEM_PREPARING
      "<em style='color:red'>Ordering</em>"
    when ReferenceData::PO_ITEM_SENT_TO_CENTRAL
      "<em style='color:brown'>Sent to Central</em>"
    when ReferenceData::PO_ITEM_SENT_TO_SUPPLIER
      "<em style='color:green'>Sent to PO</em>"
    when ReferenceData::PO_ITEM_UNCATEGORIZED
      "<em style='color:red'>Uncategorized</em>"
    end
      
  end
  
  def total_amount
    quantity * unit_price
  end
  
  def product_name
    product.code_name if product
  end
  
  def product_name=(name)
    if name.blank?
      self.product_id = 0
    else
      combine = name.split("-")
      found_product = Product.find_by_code(combine[0])
      if found_product
        self.product = found_product
      else
        self.product_id = 0
      end
    end
  end
#  def increase_product_quantity
#    product.stock_quantity += quantity
#    product.save(false)
#    st = Stock.first(:conditions => ["store_location_id = ? and product_id = ?", store_location_id, product_id])
#    st = Stock.create(:store_location_id => store_location_id, :product_id => product_id) unless st
#    st.quantity += quantity
#    st.save!
#    purchase_invoice.supplier.used_credit += total_amount
#    purchase_invoice.supplier.save!
#    ProductMovement.item_purchased(self, purchase_invoice, product.id)
#  end
  
#  def decrease_product_quantity
#    product.stock_quantity -= quantity
#    product.save(false)
#    st = Stock.first(:conditions => ["store_location_id = ? and product_id = ?", store_location_id, product_id])
#    st.quantity -= quantity
#    st.save!
#    purchase_invoice.supplier.used_credit -= total_amount
#    purchase_invoice.supplier.save!
#    ProductMovement.purchased_item_deleted(self, purchase_invoice, product.id)
#  end
end
