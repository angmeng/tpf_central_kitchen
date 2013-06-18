class Outlet < ActiveRecord::Base
  has_many :outlet_purchase_orders
  has_many :outlet_goods_receive_notes
  has_many :outlet_delivery_orders
  has_many :outlet_staffs
  has_many :packing_order_items
  has_many :invoices
  has_many :packing_lists
  has_many :outlet_product_suppliers
  has_many :suppliers, :through => :outlet_product_suppliers
  has_many :products, :through => :outlet_product_suppliers
  has_many :credit_notes
  
  validates_presence_of  :name, :code
  validates_uniqueness_of(:name, :code)

  def self.for_options
    result = order("name").all
    result.insert(0, Outlet.new(:name => "All Outlet"))
    result
  end
  
  def pricing_category
    if pricing_category_id == ReferenceData::OUTLET_PRICING_A
      "Pricing A"
    elsif pricing_category_id == ReferenceData::OUTLET_PRICING_B
      "Pricing B"
    else  
      "Not Set"
    end
  end
  
  def get_results
    output = []
    passed = true
    begin
      db = Mysql.new(domain_name, username, password, database)
    rescue Mysql::Error
      passed = false
      
    end

    begin
      results = db.query "SELECT * FROM results"
      output << "Number of records #{results.num_rows}" + "<br/>"
      results.each do |row|
        output << "record #{row[0]}: #{row[2]}" + "<br />"
      end
      results.free
    ensure
      db.close
    end if db
    return passed, output
  end
  
  def verify_destroy
    checked = false
    if outlet_purchase_orders.size.zero?
      if outlet_goods_receive_notes.size.zero?
        if outlet_delivery_orders.size.zero?
          if outlet_staffs.size.zero?
            checked = true
            destroy
          else
            msg = "Cannot destroy the record"
          end
        else
          msg = "Cannot destroy the record"
        end
      else
        msg = "Cannot destroy the record"
      end
    else
      msg = "Cannot destroy the record"
    end
    
    return checked, msg
  end
  
end
