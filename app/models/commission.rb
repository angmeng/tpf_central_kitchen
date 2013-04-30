class Commission < ActiveRecord::Base
  belongs_to :salesman
  belongs_to :product
end
