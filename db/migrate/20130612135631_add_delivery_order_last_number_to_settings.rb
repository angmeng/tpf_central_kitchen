class AddDeliveryOrderLastNumberToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :delivery_order_last_number, :integer, :default => 10000
    add_column :settings, :delivery_order_code, :string, :default => "DO"
  end
end
