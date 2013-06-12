class PackingList < ActiveRecord::Base
  has_many :packing_order_items, :order => "store_location_id"
  belongs_to :outlet
  belongs_to :store_location
  belongs_to :outlet_purchase_order
  #has_many :outlet_purchase_orders
  before_create :generate_packing_number
  
  def generate_invoice
    unless settled?
      found = outlet_purchase_order.invoice
      unless found
        found = Invoice.new
        found.outlet_purchase_order_id = outlet_purchase_order_id
        found.invoice_date = Date.today.to_s
        found.outlet_id = outlet_id
        found.generate_invoice_number
        found.save!
        Setting.increment_of_invoice
      end

      d_order = found.build_delivery_order(delivery_date: found.invoice_date, outlet_id: found.outlet_id)
      d_order.delivery_order_number = Setting.generate_delivery_order_number
      d_order.save!
      Setting.increment_of_delivery_order

      packing_order_items.each do |p|
        if p.picked_quantity > 0
          j        = found.invoice_items.new
          d_o_item = d_order.delivery_order_item.new
          
          j.product_id               = p.product_id
          d_o_item.product_id        = p.product_id
          j.store_location_id        = p.store_location_id
          d_o_item.store_location_id = p.store_location_id
          
          found_uom = p.product.product_uoms.find(p.product.packing_uom_id) rescue nil
          unless found_uom
            found_uom = p.product.product_uoms.first
            unless found_uom
              found_uom = p.product.create_default_uom
            end
          end

          j.quantity               = p.picked_quantity #found_uom.calculate_quantity(p)
          d_o_item.quantity        = p.picked_quantity
          j.product_uom_id         = found_uom.id
          d_o_item.product_uom_id  = found_uom.id
          if outlet.pricing_category_id == ReferenceData::OUTLET_PRICING_A
            j.unit_price = found_uom.selling_price_a
          elsif outlet.pricing_category_id == ReferenceData::OUTLET_PRICING_B
            j.unit_price = found_uom.selling_price_b
          end
          j.save!
          d_o_item.save!
        end
      end
      self.settled = true
      result = self.save
      result ? msg = "Invoice generated" : msg = "Invoice cannot generated"

    else
      result = false
      msg = "Packing is already settled"
    end
    return result, msg, found
  end

  def current_status
    settled ? "<em style='color:green'>Settled</em>" : "<em style='color:red'>Pending</em>"
  end
  
  
  private
  
  def generate_packing_number
    self.packing_list_number = Time.now.strftime("%d%m%Y%H%M%S")
  end
  
  
end
