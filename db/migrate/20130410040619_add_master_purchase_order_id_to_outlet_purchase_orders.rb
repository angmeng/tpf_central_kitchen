class AddMasterPurchaseOrderIdToOutletPurchaseOrders < ActiveRecord::Migration
  def change
    add_column :outlet_purchase_orders, :master_purchase_order_id, :integer, :default => 0
    add_index :outlet_purchase_orders, :master_purchase_order_id
  end
end
