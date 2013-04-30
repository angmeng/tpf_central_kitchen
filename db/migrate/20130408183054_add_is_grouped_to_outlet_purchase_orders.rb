class AddIsGroupedToOutletPurchaseOrders < ActiveRecord::Migration
  def change
    add_column :outlet_purchase_orders, :is_grouped, :boolean, :default => false
  end
end
