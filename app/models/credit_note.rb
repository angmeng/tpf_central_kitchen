class CreditNote < ActiveRecord::Base
  attr_accessible :credit_date, :credit_note_number, :posted, :remark, :outlet_id
  belongs_to :outlet
end
