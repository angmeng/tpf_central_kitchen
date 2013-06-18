# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130614092710) do

  create_table "accessible_menus", :force => true do |t|
    t.string   "name",        :limit => 45
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authorizations", :force => true do |t|
    t.integer  "department_id"
    t.integer  "accessible_menu_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "banks", :force => true do |t|
    t.string   "name",        :limit => 45
    t.text     "description"
    t.integer  "priority"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "card_categories", :force => true do |t|
    t.string   "name",        :limit => 45
    t.text     "description"
    t.integer  "priority",                  :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cheques", :force => true do |t|
    t.string   "cheque_number",       :limit => 20
    t.integer  "bank_id"
    t.integer  "reference_id"
    t.integer  "cheque_type_id"
    t.string   "owner_name",          :limit => 45
    t.date     "cheque_date"
    t.boolean  "clear"
    t.string   "bank_account_number", :limit => 20
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "amount",                            :precision => 12, :scale => 2, :default => 0.0
  end

  add_index "cheques", ["bank_id"], :name => "index_cheques_on_bank_id"
  add_index "cheques", ["cheque_type_id"], :name => "index_cheques_on_cheque_type_id"
  add_index "cheques", ["reference_id"], :name => "index_cheques_on_reference_id"

  create_table "commissions", :force => true do |t|
    t.integer  "salesman_id"
    t.integer  "product_id"
    t.decimal  "percentage",  :precision => 10, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", :force => true do |t|
    t.string   "name",         :limit => 100
    t.text     "address"
    t.string   "phone_number", :limit => 12
    t.string   "fax_number",   :limit => 12
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credit_cards", :force => true do |t|
    t.string   "card_number",      :limit => 20
    t.integer  "bank_id"
    t.integer  "reference_id"
    t.integer  "card_type_id"
    t.integer  "card_category_id"
    t.string   "owner_name",       :limit => 45
    t.boolean  "clear"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "amount",                         :precision => 12, :scale => 2, :default => 0.0
  end

  add_index "credit_cards", ["bank_id"], :name => "index_credit_cards_on_bank_id"
  add_index "credit_cards", ["card_category_id"], :name => "index_credit_cards_on_card_category_id"
  add_index "credit_cards", ["card_type_id"], :name => "index_credit_cards_on_card_type_id"
  add_index "credit_cards", ["reference_id"], :name => "index_credit_cards_on_reference_id"

  create_table "credit_notes", :force => true do |t|
    t.integer  "outlet_id"
    t.string   "credit_note_number"
    t.date     "credit_date"
    t.text     "remark"
    t.boolean  "posted"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "customer_payments", :force => true do |t|
    t.date     "payment_date"
    t.integer  "customer_id"
    t.string   "reference_number",  :limit => 20
    t.string   "resit_number",      :limit => 20
    t.text     "description"
    t.integer  "payment_method_id"
    t.decimal  "amount",                          :precision => 12, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "customer_payments", ["customer_id"], :name => "index_customer_payments_on_customer_id"
  add_index "customer_payments", ["payment_method_id"], :name => "index_customer_payments_on_payment_method_id"

  create_table "customer_pricings", :force => true do |t|
    t.integer  "customer_id"
    t.integer  "product_id"
    t.decimal  "amount",      :precision => 12, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.text     "home_address"
    t.text     "company_address"
    t.string   "mobile_number"
    t.string   "home_phone_number"
    t.string   "office_phone_number"
    t.string   "fax_number"
    t.decimal  "credit_limit",                       :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "used_credit",                        :precision => 10, :scale => 2, :default => 0.0
    t.boolean  "suspend",                                                           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "additional_phone_one", :limit => 20
    t.string   "additional_phone_two", :limit => 20
    t.decimal  "paid_credit",                        :precision => 12, :scale => 2, :default => 0.0
  end

  create_table "delivery_order_items", :force => true do |t|
    t.integer  "delivery_order_id"
    t.integer  "product_id"
    t.integer  "quantity",          :default => 0
    t.integer  "product_uom_id"
    t.integer  "store_location_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "delivery_orders", :force => true do |t|
    t.date     "delivery_date"
    t.string   "delivery_order_number"
    t.integer  "outlet_id"
    t.text     "remark"
    t.boolean  "void",                  :default => false
    t.integer  "company_id"
    t.integer  "invoice_id"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  create_table "departments", :force => true do |t|
    t.string   "name",        :limit => 45
    t.text     "description"
    t.boolean  "builtin",                   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "message"
  end

  create_table "document_authorizations", :force => true do |t|
    t.integer  "department_id"
    t.integer  "document_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "document_categories", :force => true do |t|
    t.string   "name",        :limit => 45
    t.text     "description"
    t.boolean  "builtin",                   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "document_storages", :force => true do |t|
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.integer  "document_category_id",  :default => 1
  end

  create_table "expenses", :force => true do |t|
    t.date     "expense_date"
    t.string   "title",        :limit => 45
    t.text     "description"
    t.decimal  "amount",                     :precision => 12, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoice_items", :force => true do |t|
    t.integer  "invoice_id"
    t.integer  "product_id"
    t.integer  "quantity",                                         :default => 0
    t.decimal  "unit_price",        :precision => 10, :scale => 2, :default => 0.0
    t.string   "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "store_location_id",                                :default => 1
    t.decimal  "commission",        :precision => 10, :scale => 2, :default => 0.0
    t.integer  "product_uom_id"
  end

  add_index "invoice_items", ["invoice_id"], :name => "index_invoice_items_on_invoice_id"
  add_index "invoice_items", ["product_id"], :name => "index_invoice_items_on_product_id"
  add_index "invoice_items", ["store_location_id"], :name => "index_invoice_items_on_store_location_id"

  create_table "invoices", :force => true do |t|
    t.date     "invoice_date"
    t.string   "invoice_number"
    t.integer  "outlet_id"
    t.string   "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "void",                     :default => false
    t.integer  "company_id",               :default => 1
    t.boolean  "deleted",                  :default => false
    t.boolean  "settled",                  :default => false
    t.integer  "outlet_purchase_order_id"
  end

  add_index "invoices", ["company_id"], :name => "index_invoices_on_company_id"
  add_index "invoices", ["outlet_purchase_order_id"], :name => "index_invoices_on_outlet_purchase_order_id"

  create_table "outlet_delivery_order_items", :force => true do |t|
    t.integer  "outlet_delivery_order_id"
    t.integer  "product_id"
    t.integer  "quantity",                                                :default => 0
    t.decimal  "unit_price",               :precision => 12, :scale => 2, :default => 0.0
    t.string   "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "store_location_id"
    t.integer  "product_uom_id"
  end

  add_index "outlet_delivery_order_items", ["outlet_delivery_order_id"], :name => "index_outlet_delivery_order_items_on_outlet_delivery_order_id"
  add_index "outlet_delivery_order_items", ["product_id"], :name => "index_outlet_delivery_order_items_on_product_id"

  create_table "outlet_delivery_orders", :force => true do |t|
    t.integer  "outlet_id"
    t.date     "delivery_order_date"
    t.string   "delivery_order_number", :limit => 45
    t.text     "remark"
    t.boolean  "void",                                :default => false
    t.boolean  "settled",                             :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "outlet_delivery_orders", ["outlet_id"], :name => "index_outlet_delivery_orders_on_outlet_id"

  create_table "outlet_goods_receive_note_items", :force => true do |t|
    t.integer  "outlet_goods_receive_note_id"
    t.integer  "product_id"
    t.integer  "quantity",                                                    :default => 0
    t.decimal  "unit_price",                   :precision => 10, :scale => 0, :default => 0
    t.string   "remark"
    t.boolean  "rejected",                                                    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "store_location_id"
    t.integer  "product_uom_id"
  end

  add_index "outlet_goods_receive_note_items", ["product_id"], :name => "index_outlet_goods_receive_note_items_on_product_id"

  create_table "outlet_goods_receive_notes", :force => true do |t|
    t.integer  "outlet_id"
    t.string   "grn_number", :limit => 45
    t.date     "grn_date"
    t.text     "remark"
    t.boolean  "void",                     :default => false
    t.boolean  "settled",                  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "outlet_goods_receive_notes", ["outlet_id"], :name => "index_outlet_goods_receive_notes_on_outlet_id"

  create_table "outlet_product_suppliers", :force => true do |t|
    t.integer  "outlet_id",   :default => 0
    t.integer  "product_id",  :default => 0
    t.integer  "supplier_id", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "outlet_product_suppliers", ["outlet_id"], :name => "index_outlet_product_suppliers_on_outlet_id"
  add_index "outlet_product_suppliers", ["product_id"], :name => "index_outlet_product_suppliers_on_product_id"
  add_index "outlet_product_suppliers", ["supplier_id"], :name => "index_outlet_product_suppliers_on_supplier_id"

  create_table "outlet_purchase_order_items", :force => true do |t|
    t.integer  "outlet_purchase_order_id"
    t.integer  "product_id"
    t.integer  "quantity",                                                             :default => 0
    t.decimal  "unit_price",                            :precision => 12, :scale => 2, :default => 0.0
    t.string   "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "store_location_id",                                                    :default => 1
    t.integer  "status_id",                :limit => 1,                                :default => 0
    t.integer  "product_uom_id"
  end

  add_index "outlet_purchase_order_items", ["outlet_purchase_order_id"], :name => "index_outlet_purchase_order_items_on_outlet_purchase_order_id"
  add_index "outlet_purchase_order_items", ["product_id"], :name => "index_outlet_purchase_order_items_on_product_id"

  create_table "outlet_purchase_orders", :force => true do |t|
    t.integer  "outlet_id"
    t.date     "purchase_order_date"
    t.string   "purchase_order_number",        :limit => 12
    t.text     "remark"
    t.boolean  "void",                                       :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "settled",                                    :default => false
    t.integer  "confirmed_by",                               :default => 0
    t.integer  "outlet_staff_id"
    t.string   "import_document_file_name"
    t.string   "import_document_content_type"
    t.integer  "import_document_file_size",                  :default => 0
    t.datetime "import_document_updated_at"
    t.integer  "status_id",                                  :default => 0
    t.boolean  "deleted",                                    :default => false
    t.boolean  "is_grouped",                                 :default => false
    t.integer  "master_purchase_order_id",                   :default => 0
  end

  add_index "outlet_purchase_orders", ["confirmed_by"], :name => "index_outlet_purchase_orders_on_confirmed_by"
  add_index "outlet_purchase_orders", ["master_purchase_order_id"], :name => "index_outlet_purchase_orders_on_master_purchase_order_id"
  add_index "outlet_purchase_orders", ["outlet_id"], :name => "index_outlet_purchase_orders_on_outlet_id"
  add_index "outlet_purchase_orders", ["outlet_staff_id"], :name => "index_outlet_purchase_orders_on_outlet_staff_id"

  create_table "outlet_staffs", :force => true do |t|
    t.string   "fullname",      :limit => 45
    t.string   "login",         :limit => 45
    t.string   "nickname",      :limit => 45
    t.integer  "outlet_id"
    t.boolean  "suspend"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "outlets", :force => true do |t|
    t.string   "company_number",      :limit => 45
    t.string   "name",                :limit => 45
    t.text     "address"
    t.string   "phone_number",        :limit => 12
    t.string   "fax_number",          :limit => 12
    t.string   "domain_name",         :limit => 45
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username",            :limit => 45
    t.string   "password",            :limit => 45
    t.string   "database",            :limit => 45
    t.string   "code",                :limit => 45
    t.string   "contact",             :limit => 45
    t.string   "area",                :limit => 45
    t.string   "term",                :limit => 45
    t.integer  "pricing_category_id",               :default => 1
  end

  create_table "packing_lists", :force => true do |t|
    t.string   "packing_list_number",      :limit => 20
    t.date     "packing_date"
    t.text     "description"
    t.boolean  "void",                                   :default => false
    t.boolean  "settled",                                :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "outlet_id"
    t.integer  "outlet_purchase_order_id"
    t.integer  "store_location_id"
  end

  add_index "packing_lists", ["outlet_purchase_order_id"], :name => "index_packing_lists_on_outlet_purchase_order_id"
  add_index "packing_lists", ["store_location_id"], :name => "index_packing_lists_on_store_location_id"

  create_table "packing_order_items", :force => true do |t|
    t.integer  "packing_list_id"
    t.integer  "product_id"
    t.integer  "quantity",          :default => 0
    t.integer  "picked_quantity",   :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_uom_id"
    t.integer  "store_location_id"
  end

  add_index "packing_order_items", ["store_location_id"], :name => "index_packing_order_items_on_store_location_id"

  create_table "payment_methods", :force => true do |t|
    t.string   "name",        :limit => 45
    t.text     "description"
    t.integer  "priority"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_groups", :force => true do |t|
    t.string   "name",        :limit => 45
    t.text     "description"
    t.boolean  "suspend",                   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_lists", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "import_list_file_name"
    t.string   "import_list_content_type"
    t.integer  "import_list_file_size"
    t.datetime "import_list_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_movements", :force => true do |t|
    t.integer  "product_id"
    t.integer  "movement_category_id"
    t.integer  "reference_id"
    t.integer  "item_id"
    t.integer  "quantity"
    t.decimal  "unit_price",           :precision => 12, :scale => 2
    t.date     "movement_date"
    t.boolean  "deleted",                                             :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "debit"
    t.integer  "store_location_id",                                   :default => 1
  end

  add_index "product_movements", ["item_id"], :name => "index_product_movements_on_item_id"
  add_index "product_movements", ["movement_category_id"], :name => "index_product_movements_on_movement_category_id"
  add_index "product_movements", ["product_id"], :name => "index_product_movements_on_product_id"
  add_index "product_movements", ["reference_id"], :name => "index_product_movements_on_reference_id"
  add_index "product_movements", ["store_location_id"], :name => "index_product_movements_on_store_location_id"

  create_table "product_uoms", :force => true do |t|
    t.integer  "product_id"
    t.string   "name",            :limit => 45
    t.text     "description"
    t.decimal  "rate",                          :precision => 10, :scale => 2,  :default => 1.0
    t.decimal  "selling_price_a",               :precision => 12, :scale => 2,  :default => 0.0
    t.decimal  "cost",                          :precision => 12, :scale => 2,  :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "selling_price_b",               :precision => 12, :scale => 2,  :default => 0.0
    t.decimal  "selling_price_c",               :precision => 12, :scale => 10, :default => 0.0
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.integer  "product_category_id"
    t.text     "description"
    t.integer  "open_balance"
    t.string   "uom"
    t.decimal  "selling_price",                     :precision => 10, :scale => 0
    t.boolean  "active",                                                           :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code",                :limit => 45
    t.integer  "stock_quantity",                                                   :default => 0
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.decimal  "unit_cost",                         :precision => 12, :scale => 2
    t.text     "description2"
    t.integer  "product_group_id"
    t.boolean  "central_product",                                                  :default => true
    t.boolean  "is_public",                                                        :default => true
    t.integer  "store_location_id",                                                :default => 0
    t.integer  "outlet_po_uom_id"
    t.integer  "po_uom_id"
    t.integer  "report_uom_id"
    t.integer  "invoice_uom_id"
    t.integer  "packing_uom_id"
  end

  add_index "products", ["product_group_id"], :name => "index_products_on_product_group_id"

  create_table "purchase_invoice_items", :force => true do |t|
    t.integer  "purchase_invoice_id"
    t.integer  "product_id"
    t.integer  "quantity",                                           :default => 0
    t.decimal  "unit_price",          :precision => 12, :scale => 2, :default => 0.0
    t.text     "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "store_location_id",                                  :default => 1
    t.integer  "product_uom_id"
  end

  add_index "purchase_invoice_items", ["product_id"], :name => "index_purchase_invoice_items_on_product_id"
  add_index "purchase_invoice_items", ["purchase_invoice_id"], :name => "index_purchase_invoice_items_on_purchase_invoice_id"
  add_index "purchase_invoice_items", ["store_location_id"], :name => "index_purchase_invoice_items_on_store_location_id"

  create_table "purchase_invoices", :force => true do |t|
    t.date     "invoice_date"
    t.string   "invoice_number", :limit => 12
    t.integer  "supplier_id"
    t.text     "remark"
    t.boolean  "void",                         :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id",                   :default => 1
    t.boolean  "deleted",                      :default => false
  end

  add_index "purchase_invoices", ["company_id"], :name => "index_purchase_invoices_on_company_id"
  add_index "purchase_invoices", ["supplier_id"], :name => "index_purchase_invoices_on_supplier_id"

  create_table "purchase_order_items", :force => true do |t|
    t.integer  "purchase_order_id"
    t.integer  "product_id"
    t.integer  "quantity",                                         :default => 0
    t.decimal  "unit_price",        :precision => 12, :scale => 2, :default => 0.0
    t.string   "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "store_location_id",                                :default => 1
    t.integer  "product_uom_id"
  end

  add_index "purchase_order_items", ["product_id"], :name => "index_purchase_order_items_on_product_id"
  add_index "purchase_order_items", ["purchase_order_id"], :name => "index_purchase_order_items_on_purchase_order_id"

  create_table "purchase_orders", :force => true do |t|
    t.date     "purchase_order_date"
    t.string   "purchase_order_number",    :limit => 12
    t.integer  "supplier_id"
    t.text     "remark"
    t.boolean  "void",                                   :default => false
    t.boolean  "settled",                                :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "outlet_purchase_order_id",               :default => 0
    t.boolean  "deleted",                                :default => false
  end

  add_index "purchase_orders", ["supplier_id"], :name => "index_purchase_orders_on_supplier_id"

  create_table "report_categories", :force => true do |t|
    t.integer  "user_id"
    t.string   "name",       :limit => 45
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "report_category_items", :force => true do |t|
    t.integer  "report_category_id"
    t.integer  "product_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "salesmen", :force => true do |t|
    t.string   "name",          :limit => 45
    t.text     "address"
    t.string   "mobile_number", :limit => 12
    t.text     "remark"
    t.boolean  "suspend",                     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "settings", :force => true do |t|
    t.string   "ar_code"
    t.integer  "ar_last_number"
    t.string   "ap_code"
    t.integer  "ap_last_number"
    t.string   "invoice_code"
    t.integer  "invoice_last_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "purchase_invoice_code",             :limit => 10, :default => "PO"
    t.integer  "purchase_invoice_last_number",                    :default => 10000
    t.date     "blowfish",                                        :default => '2009-12-15'
    t.string   "purchase_order_code",               :limit => 45, :default => "PO"
    t.integer  "purchase_order_last_number",                      :default => 10000
    t.string   "outlet_purchase_order_code",        :limit => 45, :default => "OPO"
    t.integer  "outlet_purchase_order_last_number",               :default => 10000
    t.string   "outlet_delivery_order_code",        :limit => 45, :default => "ODO"
    t.integer  "outlet_delivery_order_last_number",               :default => 10000
    t.string   "grn_code",                          :limit => 45, :default => "GRN"
    t.integer  "grn_last_number",                                 :default => 10000
    t.integer  "delivery_order_last_number",                      :default => 10000
    t.string   "delivery_order_code",                             :default => "DO"
    t.string   "credit_note_code",                  :limit => 5,  :default => "CN"
    t.integer  "credit_note_last_number",                         :default => 10000
  end

  create_table "stock_adjustments", :force => true do |t|
    t.string   "name",              :limit => 45
    t.text     "description"
    t.integer  "store_location_id",               :default => 0
    t.integer  "product_id",                      :default => 0
    t.integer  "quantity",                        :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "debit",                           :default => true
  end

  create_table "stock_transfers", :force => true do |t|
    t.date     "transfer_date"
    t.integer  "product_id"
    t.integer  "from_store_location_id"
    t.integer  "store_location_id"
    t.integer  "quantity",               :default => 0
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stocks", :force => true do |t|
    t.integer  "store_location_id"
    t.integer  "product_id"
    t.integer  "quantity",          :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "opening_balance",   :default => 0
  end

  add_index "stocks", ["product_id"], :name => "index_stocks_on_product_id"
  add_index "stocks", ["store_location_id"], :name => "index_stocks_on_store_location_id"

  create_table "store_locations", :force => true do |t|
    t.string   "name",        :limit => 45
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "supplier_payments", :force => true do |t|
    t.date     "payment_date"
    t.integer  "supplier_id"
    t.string   "reference_number",  :limit => 20
    t.string   "resit_number",      :limit => 20
    t.text     "description"
    t.integer  "payment_method_id"
    t.decimal  "amount",                          :precision => 12, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "supplier_payments", ["payment_method_id"], :name => "index_supplier_payments_on_payment_method_id"
  add_index "supplier_payments", ["supplier_id"], :name => "index_supplier_payments_on_supplier_id"

  create_table "suppliers", :force => true do |t|
    t.string   "code",                 :limit => 45
    t.string   "name",                 :limit => 100
    t.text     "address"
    t.string   "office_phone",         :limit => 12
    t.string   "fax_number",           :limit => 12
    t.string   "contact_person",       :limit => 45
    t.string   "contact_number",       :limit => 12
    t.boolean  "active",                                                             :default => true
    t.text     "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "additional_phone_one", :limit => 20
    t.string   "additional_phone_two", :limit => 20
    t.decimal  "used_credit",                         :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "paid_credit",                         :precision => 12, :scale => 2, :default => 0.0
    t.string   "area",                 :limit => 45
    t.string   "term",                 :limit => 45
    t.string   "company_number",       :limit => 45
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "department_id"
    t.integer  "language",      :default => 1
  end

  add_index "users", ["department_id"], :name => "index_users_on_department_id"

  create_table "versions", :force => true do |t|
    t.integer  "versioned_id"
    t.string   "versioned_type"
    t.text     "changes"
    t.integer  "number"
    t.datetime "created_at"
  end

  add_index "versions", ["created_at"], :name => "index_versions_on_created_at"
  add_index "versions", ["number"], :name => "index_versions_on_number"
  add_index "versions", ["versioned_type", "versioned_id"], :name => "index_versions_on_versioned_type_and_versioned_id"

end
