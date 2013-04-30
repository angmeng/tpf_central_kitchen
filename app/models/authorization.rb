class Authorization < ActiveRecord::Base
  belongs_to :accessible_menu
  belongs_to :department
end
