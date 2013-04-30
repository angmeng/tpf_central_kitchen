class OutletPurchaseOrdersController < ApplicationController
  before_filter :authenticated_admin_and_user
  before_filter :check_menu_accessible
  before_filter :set_locale
 
  # GET /outlet_purchase_orders
  # GET /outlet_purchase_orders.xml
  def index
    if is_outlet_staff?
      @outlet_purchase_orders = OutletPurchaseOrder.settled.where("outlet_id = ?", current_user_outlet_id)
    elsif is_admin?
      @outlet_purchase_orders = OutletPurchaseOrder.settled
    end 
  end

  # GET /outlet_purchase_orders/1
  # GET /outlet_purchase_orders/1.xml
  def show
    @outlet_purchase_order = OutletPurchaseOrder.find(params[:id])
    @current_items = @outlet_purchase_order.outlet_purchase_order_items
    @locations = StoreLocation.order("name").map {|l| [l.name, l.id]}
    @suppliers = Supplier.order("name").map {|s| [s.name, s.id]}
  end
  
  def show_purchase_orders
    @outlet_purchase_order = OutletPurchaseOrder.find(params[:id])
    @orders = @outlet_purchase_order.purchase_orders
  end

  # GET /outlet_purchase_orders/new
  # GET /outlet_purchase_orders/new.xml
  def new
    if is_outlet_staff?
      @outlet_purchase_order = OutletPurchaseOrder.new
    else
      flash[:error] = "You cannot access this area"
      redirect_to(:action => 'index')
    end
  end

  # GET /outlet_purchase_orders/1/edit
  def edit
    
    if is_outlet_staff?
      @outlet_purchase_order = OutletPurchaseOrder.find(params[:id])
    else
      flash[:error] = "You cannot access this area"
      redirect_to(:action => 'index')
    end
  end

  # POST /outlet_purchase_orders
  # POST /outlet_purchase_orders.xml
  def create
    @outlet_purchase_order = OutletPurchaseOrder.new(params[:outlet_purchase_order])
    @outlet_purchase_order.generate_order_number
    respond_to do |format|
      if @outlet_purchase_order.save
        Setting.increment_of_outlet_purchase_order
        @outlet_purchase_order.receive_items(params[:product])
        @outlet_purchase_order.import_items unless @outlet_purchase_order.import_document_file_name.blank?
        flash[:notice] = 'OutletPurchaseOrder was successfully created.'
        format.html { redirect_to(@outlet_purchase_order) }
        format.xml  { render :xml => @outlet_purchase_order, :status => :created, :location => @outlet_purchase_order }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @outlet_purchase_order.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def complete
    outlet_purchase_order = OutletPurchaseOrder.find(params[:id])
    outlet_purchase_order.mark_as_completed
    flash[:notice] = (t "flashes.successfully_updated")
    redirect_to outlet_purchase_order
  end
  
  def show_product
    @products = Product.all(:conditions => ['code LIKE ?', "#{params[:search]}%"])
    @products.each {|c|
       c.code = c.code_name
    }    
  end
  
  def add_items
    if is_outlet_staff?
      @outlet_purchase_order = OutletPurchaseOrder.find(params[:id])
      @outlet_purchase_order.add_order_items(params[:outlet_purchase_order_item])
      flash[:notice] = "Operation Completed"
      redirect_to(@outlet_purchase_order)
    else
      flash[:error] = "You cannot access this area"
      redirect_to(:action => 'index')
    end
  
  end
  
  def remove_item
    if is_outlet_staff?
      @outlet_purchase_order = OutletPurchaseOrder.find(params[:id])
      @outlet_purchase_order.outlet_purchase_order_items.find(params[:purchase_order_item_id]).destroy
      flash[:notice] = (t "flashes.successfully_removed")
      redirect_to(@outlet_purchase_order)
    else
      flash[:error] = "You cannot access this area"
      redirect_to(:action => 'index')
    end
  end
  
  def confirm
    unless is_outlet_staff?
      @outlet_purchase_order = OutletPurchaseOrder.find(params[:id])
      @outlet_purchase_order.confirmed_by = current_user.id
      @outlet_purchase_order.generate_packing_and_invoice
      @outlet_purchase_order.save!
      flash[:notice] = "Outlet Purchase Order Comfirmed"
      redirect_to(@outlet_purchase_order)
    else
      flash[:error] = "You cannot access this area"
      redirect_to(:action => 'index')
    end
  end

  def group_confirm
    unless is_outlet_staff?
      if params[:outlet_purchase_order_ids] && params[:outlet_purchase_order_ids].size > 1
        qty_outlet = params[:outlet_purchase_order_ids].map {|po_id| OutletPurchaseOrder.find(po_id).outlet_id}.uniq
        if qty_outlet.size == 1
          po = OutletPurchaseOrder.grouping_packing_and_invoice(params[:outlet_purchase_order_ids], current_user.id, qty_outlet.first)
          flash[:notice] = "Outlet Purchase Orders combined successfully"
          redirect_to po
        else
          flash[:error] = "PO's outlet is different"
          redirect_to :back
        end
        
      else
        flash[:error] = "You must at least select 2 PO"
        redirect_to :back
      end
    else
      flash[:error] = "You cannot access this area"
      redirect_to :back
    end
  end

  def send_to_central
    @outlet_purchase_order = OutletPurchaseOrder.find(params[:id])
    if @outlet_purchase_order.outlet_purchase_order_items.size.zero?
      flash[:error] = "Your PO has no item"
    else
      @outlet_purchase_order.send_to_central
      flash[:notice] = "Sent to Central for processing"
    end
    redirect_to(@outlet_purchase_order)
  end
  
  def preview
    @outlet_purchase_order = OutletPurchaseOrder.find(params[:id])
    render :layout => false
  end
  
  def update_item_status
    @outlet_purchase_order = OutletPurchaseOrder.find(params[:id])
    if params[:commit] == "Update"
      params[:item] ||= []
      @outlet_purchase_order.update_item_status(params[:item])

    elsif params[:commit] == "Remove Selected"
      params[:item] ||= []

      params[:item].each {|p_id, content|
      item = @outlet_purchase_order.outlet_purchase_order_items.find(p_id.to_i) rescue nil
      item.destroy if item and content[:selected].to_i == 1

      }
    end
    flash[:notice] = "Update completed"
    redirect_to(@outlet_purchase_order)
  end
  
  def import
    outlet_purchase_order = OutletPurchaseOrder.find(params[:id])
    outlet_purchase_order.import_items
    flash[:notice] = "Operation Completed"
    redirect_to(outlet_purchase_order)
  end
  

  # PUT /outlet_purchase_orders/1
  # PUT /outlet_purchase_orders/1.xml
  def update
    @outlet_purchase_order = OutletPurchaseOrder.find(params[:id])

    respond_to do |format|
      if @outlet_purchase_order.update_attributes(params[:outlet_purchase_order])
        flash[:notice] = 'OutletPurchaseOrder was successfully updated.'
        format.html { redirect_to(@outlet_purchase_order) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @outlet_purchase_order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /outlet_purchase_orders/1
  # DELETE /outlet_purchase_orders/1.xml
  def destroy
    if is_outlet_staff?
      @outlet_purchase_order = OutletPurchaseOrder.find(params[:id])
      if @outlet_purchase_order.verify_destroy
        flash[:notice] = (t "flashes.successfully_destroyed")
      else
        flash[:error] = (t "flashes.cannot_destroy_pls_use_void")
      end
      
    redirect_to (home_url)
  
    else
      flash[:error] = "You cannot access this area"
      redirect_to(:action => 'index')
    end
  
  end
end
