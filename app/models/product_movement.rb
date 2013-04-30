class ProductMovement < ActiveRecord::Base
  attr_accessible :product_id, :movement_category_id, :reference_id, :item_id,:quantity, :unit_price, :movement_date, :deleted, :debit
  belongs_to :product
  attr_accessor :balance
  
  OPENING = 0
  INVOICE = 1
  PURCHASE_INVOICE = 2
  ADJUSTMENT = 3
  TRANSFER = 4
  
  def self.calculate_balance(movements, product)
    i = self.new
    i.product_id = product.id
    i.movement_category_id = ProductMovement::OPENING
    i.reference_id = 0
    i.item_id = 0
    i.quantity = product.total_open_balance
    i.unit_price = 0.00
    i.movement_date = Date.parse(product.created_at.strftime("%Y-%m-%d"))
    i.deleted = false
    i.debit = true
    
    movements.insert(0, i)
    
    qty = 0
    movements.each do |item|
      
      if item.debit 
        item.quantity > 0 ? qty += item.quantity : qty += item.quantity  
        item.balance = qty 
      else
        item.quantity > 0 ? qty -= item.quantity : qty += item.quantity
        item.balance = qty
      end
    end
    movements
    
  end
  
  def self.sold_item_deleted(item, invoice, product_id)
    i = self.new
    i.product_id = product_id
    i.movement_category_id = ProductMovement::INVOICE
    i.reference_id = invoice.id
    i.item_id = item.id
    i.store_location_id = item.store_location_id
    i.quantity = item.quantity
    i.unit_price = item.unit_price
    i.movement_date = invoice.invoice_date
    i.deleted = true
    i.debit = true
    i.save!
    
  end
  
  def self.item_sold(item, invoice, product_id)
    i = self.new
    i.product_id = product_id
    i.movement_category_id = ProductMovement::INVOICE
    i.reference_id = invoice.id
    i.item_id = item.id
    i.store_location_id = item.store_location_id
    i.quantity = item.quantity
    i.unit_price = item.unit_price
    i.movement_date = invoice.invoice_date
    i.debit = false
    i.save!
  end
  
  def self.item_purchased(item, purchase_invoice, product_id)
    i = self.new
    i.product_id = product_id
    i.movement_category_id = ProductMovement::PURCHASE_INVOICE
    i.reference_id = purchase_invoice.id
    i.item_id = item.id
    i.store_location_id = item.store_location_id
    i.quantity = item.quantity
    i.unit_price = item.unit_price
    i.movement_date = purchase_invoice.invoice_date
    i.debit = true
    i.save!
  end
  
  def self.purchased_item_deleted(item, purchase_invoice, product_id)
    i = self.new
    i.product_id = product_id
    i.movement_category_id = ProductMovement::PURCHASE_INVOICE
    i.reference_id = purchase_invoice.id
    i.item_id = item.id
    i.store_location_id = item.store_location_id
    i.quantity = item.quantity
    i.unit_price = item.unit_price
    i.movement_date = purchase_invoice.invoice_date
    i.deleted = true
    i.debit = false
    i.save!
  end
  
  
  def self.stock_adjustment(new_one, adjustment)
    i = self.new
    i.product_id = adjustment.product_id
    i.movement_category_id = ProductMovement::ADJUSTMENT
    i.reference_id = adjustment.id
    i.item_id = adjustment.id
    i.store_location_id = adjustment.store_location_id
    i.quantity = adjustment.quantity
    i.unit_price = 0.0
    i.movement_date = Date.today
    if new_one
      i.deleted = false
      if adjustment.debit
        i.debit = true
      else
        i.debit = false
      end
    else
      i.deleted = true
      if adjustment.debit
        i.debit = false
      else
        i.debit = true
      end
    end
    
    i.save!
    
  end
  
  
  def self.add_stock_transfer(transfer)
    i = self.new
    i.product_id = transfer.product_id
    i.movement_category_id = ProductMovement::TRANSFER
    i.reference_id = transfer.id
    i.item_id = transfer.id
    i.store_location_id = transfer.from_store_location_id
    i.quantity = transfer.quantity
    i.unit_price = 0.0
    i.movement_date = transfer.transfer_date
    i.deleted = false
    i.debit = false 
    i.save!
    
    j = self.new
    j.product_id = transfer.product_id
    j.movement_category_id = ProductMovement::TRANSFER
    j.reference_id = transfer.id
    j.item_id = transfer.id
    j.store_location_id = transfer.store_location_id
    j.quantity = transfer.quantity
    j.unit_price = 0.0
    j.movement_date = transfer.transfer_date
    j.deleted = false
    j.debit = true 
    j.save!
    
    
  end
  
   def self.destroy_stock_transfer(transfer)
    i = self.new
    i.product_id = transfer.product_id
    i.movement_category_id = ProductMovement::TRANSFER
    i.reference_id = transfer.id
    i.item_id = transfer.id
    i.store_location_id = transfer.from_store_location_id
    i.quantity = transfer.quantity
    i.unit_price = 0.0
    i.movement_date = transfer.transfer_date
    i.deleted = true
    i.debit = true
    i.save!
    
    j = self.new
    j.product_id = transfer.product_id
    j.movement_category_id = ProductMovement::TRANSFER
    j.reference_id = transfer.id
    j.item_id = transfer.id
    j.store_location_id = transfer.store_location_id
    j.quantity = transfer.quantity
    j.unit_price = 0.0
    j.movement_date = transfer.transfer_date
    j.deleted = true
    j.debit = false
    j.save!
    
    
  end

  

end
