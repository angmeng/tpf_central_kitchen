class CreateDeliveryOrderItems < ActiveRecord::Migration
  def change
    create_table :delivery_order_items do |t|
      t.integer :delivery_order_id
      t.integer :product_id
      t.integer :quantity, :default => 0
      t.integer :product_uom_id
      t.integer :store_location_id

      t.timestamps
    end
  end
end
