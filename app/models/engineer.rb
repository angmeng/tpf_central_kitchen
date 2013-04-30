class Engineer
  #gem install rubyzip, nokogiri, spreadsheet, google-spreadsheet, spreadsheet-excel
  #apt-get install libxslt1-dev
  #require 'roo'
  Spreadsheet.client_encoding = 'UTF-8'
  def self.import_supplier
    
    file = RAILS_ROOT + "/public/supplier.xls"
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
    file = RAILS_ROOT + "/public/outlet.xls"
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
      term        = oo.cell(line,'I')

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
    file = RAILS_ROOT + "/public/product.xlsx"
    oo = Excelx.new(file)
    oo.default_sheet = oo.sheets.first
    2.upto(oo.last_row) do |line|
      code       = oo.cell(line,'A')
      name       = oo.cell(line,'B')
      name2      = oo.cell(line,'C')
      cost       = oo.cell(line,'D')
      selling1   = oo.cell(line,'F')
      selling2   = oo.cell(line,'G')
      selling3   = oo.cell(line,'H')
      is_public  = oo.cell(line,'E')
      category   = oo.cell(line,'L')
      group      = oo.cell(line,'M')
      #is_central = oo.cell(line,'J')
      unit        = oo.cell(line,'I')
      ume_uom     = oo.cell(line,'J')
      outlet_uom  = oo.cell(line,'K')
      supplier     = oo.cell(line,'N')
      location     = oo.cell(line,'O')

      p = Product.find_by_code(code)
      p = Product.new unless p
      p.code = code
      p.name = name
      p.description = name2 if name2 and !name2.blank?
      p.unit_cost = cost

      if group.blank? or group.nil?
        group = "Unknown"
      end
      found_group = ProductGroup.find_or_create_by_name(group)
      p.product_group_id = found_group.id

      if category.blank? or category.nil?
        category = "Unknown"
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
      if selling1.blank? or selling1.nil? or selling1.strip == "-"
        sella = 0.00
      else
        sella = selling1.to_f
      end

      if selling2.blank? or selling2.nil? or selling2.strip == "-"
        sellb = 0.00
      else
        sellb = selling2.to_f
      end
      
      if selling3.blank? or selling3.nil? or selling3.strip == "-"
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

      unless supplier.blank? or supplier.nil? or supplier.strip == "-"
        s = Supplier.find_by_code(supplier)
        unless s
          s = Supplier.create!(:name => supplier, :code => supplier)
        end

        Outlet.all.each do |o|
          p_sup = p.outlet_product_suppliers.find_by_outlet_id(o.id)
          if p_sup.supplier_id == s.id
            
          else
            p_sup.destroy
            unless p.outlet_product_suppliers.find_by_outlet_id_and_supplier_id(o.id, s.id)
              p.outlet_product_suppliers.create!(:supplier_id => s.id, :outlet_id => o.id)
            end
          end if p_sup
        end

      end
      p.save!
    end
  end

  
  
end
