class CreditNoteItem < ActiveRecord::Base
  attr_accessible :credit_note_id, :delivery_order_number, :invoice_number, :product_id, :product_uom_id, :purchase_order_number, :quantity, :store_location_id
  belongs_to :product
  belongs_to :product_uom
  belongs_to :store_location
  belongs_to :credit_note
end
