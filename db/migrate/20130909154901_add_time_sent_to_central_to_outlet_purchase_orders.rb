class AddTimeSentToCentralToOutletPurchaseOrders < ActiveRecord::Migration
  def change
    add_column :outlet_purchase_orders, :time_sent_to_central, :datetime
  end
end
