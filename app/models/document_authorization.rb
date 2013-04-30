class DocumentAuthorization < ActiveRecord::Base
    belongs_to :document_category
    belongs_to :department
end
