class Engineer
  #gem install rubyzip, nokogiri, spreadsheet, google-spreadsheet, spreadsheet-excel
  #apt-get install libxslt1-dev
  #require 'roo'
  Spreadsheet.client_encoding = 'UTF-8'
  def self.import_supplier
    
    file = "#{Rails.root.to_s}/public/supplier.xls"
    oo = Excel.new(file)
    oo.default_sheet = oo.sheets.first
     2.upto(oo.last_row) do |line|
      code       = oo.cell(line,'A')
      name       = oo.cell(line,'B')
      company_no = oo.cell(line,'C')
      contact    = oo.cell(line,'D')
      phone      = oo.cell(line,'E')
      fax        = oo.cell(line,'F')
      area       = oo.cell(line,'G')

      sup = Supplier.new
      sup.code = code
      sup.name = name
      sup.company_number = company_no
      sup.contact_person = contact
      sup.office_phone = phone
      sup.fax_number = fax
      sup.area = area
      sup.save!
    end

  end

  def self.import_outlet
    file = "#{Rails.root.to_s}/public/outlet.xls"
    oo = Excel.new(file)
    oo.default_sheet = oo.sheets.first
    2.upto(oo.last_row) do |line|
      code       = row[0]
      name       = row[1]
      company_no = row[2]
      contact    = row[3]
      phone      = row[4]
      fax        = row[5]
      area       = row[6]
      term       = row[7]

      out = Outlet.new
      out.code = code
      out.name = name
      out.company_number = company_no
      out.contact = contact
      out.phone_number = phone
      out.fax_number = fax
      out.area = area
      out.term = term
      out.save!
    end

  end

  def self.import_product
    file =  "#{Rails.root.to_s}/public/product.xls"
    book = Spreadsheet.open file
    sheet1 = book.worksheet 0
    count = 0 #header
    sheet1.each do |row|
      count += 1
      if count > 1
        code       = row[0]
        name       = row[1]
        name2      = row[2]
        cost       = row[3]
        is_public  = row[4]
        selling1   = row[5]
        selling2   = row[6]
        selling3   = row[7]
        unit        = row[8]
        ume_uom     = row[9]
        outlet_uom  = row[10]
        category   = row[11]
        group      = row[12]
        supplier     = row[13]
        location     = row[14]

        p = Product.find_by_code(code)
        p = Product.new unless p
        p.code = code
        p.name = name
        p.description = name2 if name2 and !name2.blank?
        p.unit_cost = cost

        if group.blank? or group.nil?
          group = "Default"
        end
        found_group = ProductGroup.find_or_create_by_name(group)
        p.product_group_id = found_group.id

        if category.blank? or category.nil?
          category = "Default"
        end
        found_cat = ProductCategory.find_or_create_by_name(category)
        p.product_category_id = found_cat.id

        found_loc = StoreLocation.find_or_create_by_name(location)
        p.store_location_id = found_loc.id

        #if is_central.downcase == "central"
        #  p.central_product = true
        #elsif is_central.downcase == "supplier"
        #  p.central_product = false
        #end

        if is_public == "YES"
          p.is_public = true
        else
          p.is_public = false
        end

        if unit.blank? or unit.nil?
          p.uom = "-"
        else
          p.uom = unit
        end
        
        p.save!

        if ume_uom.blank? or ume_uom.nil? or ume_uom.strip == "-"
          ume_uom = "-"
        end
        default_uom = p.product_uoms.find_or_create_by_name(ume_uom)

        if outlet_uom.blank? or outlet_uom.nil? or outlet_uom.strip == "-"
          outlet_uom = "-"
        end
        found_outlet_uom = p.product_uoms.find_or_create_by_name(outlet_uom)
        p.outlet_po_uom_id = found_outlet_uom.id
        p.invoice_uom_id = default_uom.id
        p.po_uom_id = default_uom.id
        p.report_uom_id = default_uom.id
        p.packing_uom_id = default_uom.id

        default_uom.cost = cost
        default_uom.rate = 1.00
        if selling1.blank? or selling1.nil? or selling1.to_s.strip == "-"
          sella = 0.00
        else
          sella = selling1.to_f
        end

        if selling2.blank? or selling2.nil? or selling2.to_s.strip == "-"
          sellb = 0.00
        else
          sellb = selling2.to_f
        end
        
        if selling3.blank? or selling3.nil? or selling3.to_s.strip == "-"
          sellc = 0.00
        else
          sellc = selling3.to_f
        end

        default_uom.selling_price_a = sella
        default_uom.selling_price_b = sellb
        default_uom.selling_price_c = sellc
        default_uom.save!

        unless found_outlet_uom.id == default_uom.id
          found_outlet_uom.rate = 1.00
          found_outlet_uom.cost = cost
          found_outlet_uom.selling_price_a = sella
          found_outlet_uom.selling_price_b = sellb
          found_outlet_uom.selling_price_c = sellc
          found_outlet_uom.save!
        end if found_outlet_uom

        if supplier.blank? or supplier.nil? #or supplier.strip == "-"
          s = Supplier.first || Supplier.create!(:name => "Default supplier", :code => "default_supplier")
        else
          s = Supplier.find_by_code(supplier)
          s = Supplier.create!(:name => supplier, :code => supplier) unless s
        end

        Outlet.all.each do |o|
          p_sup = p.outlet_product_suppliers.find_by_outlet_id(o.id)
          if p_sup
            unless p_sup.supplier_id == s.id
              p_sup.destroy
              unless p.outlet_product_suppliers.find_by_outlet_id_and_supplier_id(o.id, s.id)
                p.outlet_product_suppliers.create!(:supplier_id => s.id, :outlet_id => o.id)
              end
            end
          else
            p.outlet_product_suppliers.create!(:supplier_id => s.id, :outlet_id => o.id)
          end
        end

        p.save!
      end
    end
  end

  
  
end
