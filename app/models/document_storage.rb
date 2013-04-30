class DocumentStorage < ActiveRecord::Base
  attr_accessible :description, :document, :document_category_id
  has_attached_file :document
  belongs_to :document_category
         
  validates_attachment_presence :document, :message => (I18n.t("flashes.pls_select_document"))
  #validates_attachment_content_type :data, :content_type => ['image/jpeg', 'image/pjpeg', 'image/jpg', 'image/png', 'image/gif', 'image/JPG'], :message => "Please select the correct file type of image"

end
