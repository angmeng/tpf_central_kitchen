class OutletProductSupplier < ActiveRecord::Base
  belongs_to :outlet
  belongs_to :product
  belongs_to :supplier
end
