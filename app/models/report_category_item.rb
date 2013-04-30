class ReportCategoryItem < ActiveRecord::Base
  belongs_to :report_category
  belongs_to :product_category
end
