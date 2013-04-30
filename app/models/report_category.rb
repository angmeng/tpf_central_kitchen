class ReportCategory < ActiveRecord::Base
  belongs_to :user
  has_many :report_category_items, :dependent => :destroy
  attr_accessor :total_sales, :total_profit
end
