class ProductList < ActiveRecord::Base
  has_attached_file :import_list

  validates_presence_of :title
  validates_uniqueness_of :title
  validates_attachment_presence :import_list, :message => (I18n.t("flashes.pls_select_document"))

  def import_csv
    require 'roo'
     begin
     import_file = RAILS_ROOT + "/public/system/import_lists/" + id.to_s + "/original/" + import_list_file_name
      
       
      oo = Openoffice.new(import_file)
      oo.default_sheet = oo.sheets.first
      2.upto(oo.last_row) do |line|
    
         in_code = oo.cell(line,'A') rescue nil
         in_name = oo.cell(line,'B') rescue nil
         in_description = oo.cell(line,'C') rescue ""
         in_cost = oo.cell(line,'D') rescue 0.00
         in_selling_price = oo.cell(line,'E') rescue 0.00
         in_uom = oo.cell(line,'F') rescue ""
         in_category = oo.cell(line,'G') rescue nil
         in_group = oo.cell(line,'H') rescue nil
         
         product = Product.first(:conditions => ["code = ?", in_code])
         
         unless product
            p = Product.new
            p.code = in_code
            p.name = in_name
            p.description = in_description
            p.unit_cost = in_cost
            p.selling_price = in_selling_price
            p.uom = in_uom
            product_category = ProductCategory.find_or_create_by_name(:name => in_category)
            p.product_category = product_category
            product_group = ProductGroup.find_or_create_by_name(:name => in_group)
            p.product_group = product_group
            p.save!
             
          end
        end

       self.description =  "Operation Completed"
       save!
     rescue
       self.description = "Parse CSV error"
       save!
     end
 end
 
 def  self.import_outlet_csv
       require 'faster_csv' 
       n=0
       begin
         import_file = File.new(RAILS_ROOT + "/public/outlets.csv", "r")
         #FasterCSV.parse("C:/Users/sony/Desktop/MFO1_Part_List.csv",:headers=>true) do |row|  
         
         FasterCSV.parse(import_file.read,:headers=>true).each do |row|
         
         in_code = row[0] rescue nil
         in_name = row[1] rescue nil
         in_company_number = row[2] rescue ""
         in_contact = row[3] rescue ""
         in_add1 = row[4] rescue ""
         in_add2 = row[5] rescue ""
         in_add3 = row[6] rescue ""
         in_add4 = row[7] rescue ""
         in_phone = row[8] rescue ""
         in_fax = row[9] rescue ""
         in_area = row[10] rescue ""
         in_term = row[11] rescue ""
         
         outlet = Outlet.find_by_code(in_code)
         
         unless outlet
           p = Outlet.new
            p.code = in_code
            p.name = in_name
            p.address = [in_add1, in_add2, in_add3, in_add4].join(", ")
            p.company_number = in_company_number
            p.contact = in_contact
            p.phone_number = in_phone.delete(" ").strip if in_phone
            p.fax_number = in_fax.delete(" ").strip if in_fax
            p.area = in_area
            p.term = in_term 
           
           if p.save  
             n+=1  
             GC.start if n%50==0  
           end  
          
         end
       end
       import_file.close
       
     end
  
 end

 def  self.import_supplier_csv
       require 'faster_csv' 
       n=0
       begin
         import_file = File.new(RAILS_ROOT + "/public/supplier.csv", "r")
         #FasterCSV.parse("C:/Users/sony/Desktop/MFO1_Part_List.csv",:headers=>true) do |row|  
         
         FasterCSV.parse(import_file.read,:headers=>true).each do |row|
         
         in_code = row[0] rescue nil
         in_name = row[1] rescue nil
         in_company_no = row[2] rescue ""
         in_contact = row[3] rescue ""
         in_add1 = row[4] rescue ""
         in_add2 = row[5] rescue ""
         in_add3 = row[6] rescue ""
         in_add4 = row[7] rescue ""
         in_phone = row[8] rescue ""
         in_fax = row[9] rescue ""
         in_area = row[10] rescue ""
         in_term = row[11] rescue ""
         in_person = row[12] rescue ""
         
         sup = Supplier.find_by_code(in_code)
         
         
         unless sup
            p = Supplier.new
            p.code = in_code
            p.name = in_name
            p.address = [in_add1, in_add2, in_add3, in_add4].join(", ")
            p.company_number = in_company_no
            p.contact_person = in_person
            p.contact_number = in_contact.delete(" ").strip if in_contact
            p.office_phone = in_phone.delete(" ").strip if in_phone
            p.fax_number = in_fax.delete(" ").strip if in_fax
            p.area = in_area
            p.term = in_term
           
           if p.save  
             n+=1  
             GC.start if n%50==0  
           end  
          
         end
       end
       import_file.close
       puts "Completed"
     end
  
 end
 
 def self.import_outlet
    require 'roo'
     #begin
     import_file = RAILS_ROOT + "/public/station_1_customer.ods"
      
       
      oo = Openoffice.new(import_file)
      oo.default_sheet = oo.sheets.first
      2.upto(oo.last_row) do |line|
    
         in_code = oo.cell(line,'A') rescue nil
         in_name = oo.cell(line,'B') rescue nil
         in_company_number = oo.cell(line,'C') rescue ""
         in_contact = oo.cell(line,'D') rescue ""
         in_add1 = oo.cell(line,'E') rescue ""
         in_add2 = oo.cell(line,'F') rescue ""
         in_add3 = oo.cell(line,'G') rescue ""
         in_add4 = oo.cell(line,'H') rescue ""
         in_phone = oo.cell(line,'I') rescue ""
         in_fax = oo.cell(line,'J') rescue ""
         in_area = oo.cell(line,'K') rescue ""
         in_term = oo.cell(line,'M') rescue ""
         
         outlet = Outlet.find_by_code(in_code)
         
         unless outlet
            p = Outlet.new
            p.code = in_code
            p.name = in_name
            p.address = in_add1
            p.company_number = in_company_number
            p.contact = in_contact
            p.phone_number = in_phone
            p.fax_number = in_fax
            p.area = in_area
            p.term = in_term
         
            p.save!
             
          end
        end

       
     #rescue
     #  puts "Parse error !!!"
     #end
 end
 
 def self.import_supplier
    require 'roo'
     #begin
     import_file = RAILS_ROOT + "/public/station_1_supplier.ods"
      
       
      oo = Openoffice.new(import_file)
      oo.default_sheet = oo.sheets.first
      2.upto(oo.last_row) do |line|
    
         in_code = oo.cell(line,'A') rescue nil
         in_name = oo.cell(line,'B') rescue nil
         in_company_no = oo.cell(line,'C') rescue ""
         in_contact = oo.cell(line,'D') rescue ""
         in_add1 = oo.cell(line,'E') rescue ""
         in_add2 = oo.cell(line,'F') rescue ""
         in_add3 = oo.cell(line,'G') rescue ""
         in_add4 = oo.cell(line,'H') rescue ""
         in_phone = oo.cell(line,'I') rescue ""
         in_fax = oo.cell(line,'J') rescue ""
         in_area = oo.cell(line,'K') rescue ""
         in_term = oo.cell(line,'M') rescue ""
         
         supplier = Supplier.find_by_code(in_code)
         
         unless supplier
            p = Supplier.new
            p.code = in_code
            p.name = in_name
            p.address = [in_add1, in_add2, in_add3, in_add4].join(", ")
            p.company_number = in_company_no
            p.contact_person = in_contact
            p.office_phone = in_phone
            p.fax_number = in_fax
            p.area = in_area
            p.term = in_term
         
            p.save!
             
          end
        end

       
     #rescue
     #  puts "Parse error !!!"
     #end
  end



end
