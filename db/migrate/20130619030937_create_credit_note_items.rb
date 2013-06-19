class CreateCreditNoteItems < ActiveRecord::Migration
  def change
    create_table :credit_note_items do |t|
      t.integer :credit_note_id, :null => false
      t.string :invoice_number, :limit => 20
      t.string :delivery_order_number, :limit => 20
      t.string :purchase_order_number, :limit => 20
      t.integer :product_id
      t.integer :quantity, :default => 0
      t.integer :product_uom_id
      t.integer :store_location_id

      t.timestamps
    end
    add_index :credit_note_items, :credit_note_id
    add_index :credit_note_items, :product_id
  end
end
