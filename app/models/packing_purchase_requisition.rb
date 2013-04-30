class PackingPurchaseRequisition < ActiveRecord::Base
  belongs_to :packing_list
  belongs_to :outlet_purchase_order
end
