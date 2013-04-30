class AccessibleMenu < ActiveRecord::Base
  has_many :authorizations
  has_many :departments, :through => :authorizations
end
