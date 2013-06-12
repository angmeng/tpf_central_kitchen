class CreateDeliveryOrders < ActiveRecord::Migration
  def change
    create_table :delivery_orders do |t|
      t.date :delivery_date
      t.string :delivery_order_number
      t.integer :outlet_id
      t.text :remark
      t.boolean :void, :default => false
      t.integer :company_id
      t.integer :invoice_id

      t.timestamps
    end
  end
end
