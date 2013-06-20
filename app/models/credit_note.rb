class CreditNote < ActiveRecord::Base
  attr_accessible :credit_date, :credit_note_number, :posted, :remark, :outlet_id
  belongs_to :outlet
  has_many :credit_note_items

  def add_order_items(items)
    name = items[:product_name]
    unless name.blank?
      combine = name.split("(")
      found_product = Product.find_by_code(combine[0].strip)
      
      unless items[:quantity].blank? or items[:quantity].index(/[abcdefghijklmnopqrstuvwxyz]/) or found_product.nil?
        if item = credit_note_items.find_by_product_id(found_product.id)
          item.quantity += items[:quantity].to_i
          item.save!
        else
          item = credit_note_items.new
          item.product = found_product
          found_uom = found_product.product_uoms.find(found_product.outlet_po_uom_id)
          unless found_uom
            found_uom = found_product.product_uoms.first
            unless found_uom
              found_uom = found_product.create_default_uom
            end
          end
          
          item.product_uom_id = found_uom.id
          item.store_location = StoreLocation.first
          item.quantity              = items[:quantity]
          
          item.save!
        end
      end
    end
  end

  def update_item_status(item)
    item.each do |item_id, content|
      cn_item = credit_note_items.find(item_id.to_i)
      cn_item.quantity = content[:qty]
      cn_item.invoice_number        = content[:invoice_number]
      cn_item.purchase_order_number = content[:po_number]
      cn_item.delivery_order_number = content[:do_number]
      cn_item.save
    end
  end

end
