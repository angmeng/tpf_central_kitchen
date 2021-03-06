CentralKitchen::Application.routes.draw do
  resources :credit_notes do
    member do
      post 'update_items'
      delete 'remove_item'
      post 'add_item'
    end
  end


  resources :delivery_orders do
    member do
      get 'preview'
    end
  end

  resources :product_lists do
    member do
      get 'import'
    end
  end
  
  resources :product_groups

  resources :packing_order_items

  resources :packing_purchase_requisitions

  resources :packing_lists do
     member do
      get 'preview'
      get 'confirm'
      get 'release'
      get 'invoicing'
      post 'picked_items'
    end
  end

  resources :outlet_staffs do
    member do
      get 'change_password'
      post 'update_password'
    end
  end

  resources :outlet_goods_receive_note_items

  resources :outlet_goods_receive_notes

  resources :outlet_delivery_order_items

  resources :outlet_delivery_orders

  resources :purchase_order_items

  resources :purchase_orders do
    member do
     post 'submit_pricing'
     get 'complete'
     get 'void'
     get 'remove_item'
     get 'preview'
     post 'add_items'
    end

  end

  resources :outlet_purchase_order_items

  resources :outlet_purchase_orders do
    member do
      post 'update_item_status'
      get 'complete'
      get 'send_to_central'
      get 'show_purchase_orders'
      get 'import'
      get 'confirm'
      get 'void'
      get 'remove_item'
      get 'preview'
      post 'add_items'
      get 'generate_packing_list'
    end
    collection do
      get 'show_product'
      post 'group_confirm'
    end
  end


  resources :outlets

  resources :stock_transfers

  resources :commissions

  resources :salesmen do
    member do
      get 'edit_commission'
      post 'submit_commission'
    end
  end

  resources :customer_pricings

  resources :companies

  resources :document_categories
  
  resources :expenses

  resources :card_categories

  resources :banks

  resources :credit_cards

  resources :cheques do
    collection do
      get 'show_current_date_own'
      get 'show_current_date_customer'
      get 'show_future_own'
      get 'show_future_customer'
    end
  end

  resources :payment_methods

  match '/supplier_payment/show_payment_info' => 'supplier_payments#show_payment_info'
  resources :supplier_payments

  match '/customer_payment/show_payment_info' => 'customer_payments#show_payment_info'
  resources :customer_payments

  resources :stock_adjustments

  resources :stocks

  resources :store_locations, :member => {:update_balance => [:post, :get]}

  match '/product_movements/search' => "product_movements#search"
  resources :product_movements do
    collection do
      post 'search'
    end
  end

  resources :purchase_invoice_items

  resources :purchase_invoices do
    member do
      get 'void'
      get 'remove_item'
      get 'preview'
      post 'add_items'
    end
  end

  resources :suppliers

  resources :departments do
    member do
      post 'assign_accessible'
    end
  end

  resources :invoice_items

  resources :invoices do
    member do
      get 'complete'
      post 'submit_pricing'
      get 'void'
      get 'remove_item'
      get 'preview'
      post 'add_items'
    end
  end

  resources :document_storages do
    collection do
      get 'category_index'
    end
  end

  resources :settings

  resources :customers do
    member do
      get 'edit_pricing'
      post 'submit_pricing'
    end
  end
  
  resources :products do
    member do
      post 'update_uom'
      post 'add_uom'
      get  'remove_uom'
      post 'add_location'
      get 'remove_location'
      post 'add_supplier'
      get  'remove_supplier'
      post  'remove_supplier'
    end
    get :autocomplete_product_name, :on => :collection
  end

  resources :product_categories

  match '/outlet_login' => 'sessions#outlet', :as => :outlet_login
  match '/logout' => 'sessions#destroy', :as => :logout
  match '/admin' => 'sessions#new', :as => :admin
  resources :sessions

  resources :users do
    member do
      get 'change_password'
      post 'update_password'
    end
  end
  
  match '/home' => "home#index", :as => :home
  match 'report/sales' => "report#sales"
  match 'report/stock_report' => "report#stock_report"
  match 'report/profit_and_loss' => "report#profit_and_loss"
  match 'report/add_group' => "report#add_group"
  match 'report/add_item_to_repot_category' => "report#add_item_to_repot_category"
  match 'report/profit_and_loss_report' => "report#profit_and_loss_report"
  
  
  root :to => 'sessions#outlet'

end
