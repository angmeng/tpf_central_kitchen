class ReferenceData
  PO_PREPARING = 0
  PO_SENT = 1
  PO_PROCESSING = 2
  PO_DONE = 3
  
  PO_ITEM_PREPARING = 0
  PO_ITEM_SENT_TO_CENTRAL = 1
  PO_ITEM_SENT_TO_SUPPLIER = 2
  PO_ITEM_UNCATEGORIZED = 3
  
  OUTLET_PRICING_A = 1
  OUTLET_PRICING_B = 2
  
  def self.list_controllers
    controllers = Dir.new("#{RAILS_ROOT}/app/controllers").entries
    controllers.each do |controller|
      if controller =~ /_controller/ 
        cont = controller.camelize.gsub(".rb","")
        puts cont
        puts cont.controller_name
       (eval("#{cont}.new.methods") - 
        ApplicationController.methods - 
        Object.methods -  
        ApplicationController.new.methods).sort.each {|met| 
        puts "\t#{met}"
       }
      end
    end
  end
  
  
end