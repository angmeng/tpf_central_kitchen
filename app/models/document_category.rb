class DocumentCategory < ActiveRecord::Base
    attr_accessible :name, :description, :builtin, :department_ids
    has_many :document_authorizations
    has_many :departments, :through => :document_authorizations
    has_many :document_storages
    
    
    def verify_destroy
      checked = false
      if builtin
        msg = (I18n.t("flashes.cannot_destroy_builtin"))
      else
        if document_authorizations.size.zero?
          checked = true
          msg = (I18n.t("flashes.successfully_destroyed"))
          destroy
        else
          msg = (I18n.t("flashes.cannot_destroy_due_to"))
        end
      end
      
      return checked, msg
    end
end
