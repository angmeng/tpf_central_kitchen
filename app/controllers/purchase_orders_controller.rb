class PurchaseOrdersController < ApplicationController
  before_filter :authenticated_admin_and_user
  before_filter :check_menu_accessible
  before_filter :set_locale
  # GET /purchase_orders
  # GET /purchase_orders.xml
  def index
    @purchase_orders = PurchaseOrder.active.order("purchase_order_number DESC").paginate(:page => params[:page], :per_page => 30)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @purchase_orders }
    end
  end

  # GET /purchase_orders/1
  # GET /purchase_orders/1.xml
  def show
    @purchase_order = PurchaseOrder.find(params[:id])
    @products = Product.publicity.order("code, name")
    #@locations = StoreLocation.all(:order => "name")
    @current_items = @purchase_order.purchase_order_items

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @purchase_order }
    end
  end

  # GET /purchase_orders/new
  # GET /purchase_orders/new.xml
  def new
    @purchase_order = PurchaseOrder.new
    @products = Product.publicity.order("code, name")
    #@locations = StoreLocation.all(:order => "name")
    1.upto(3) { @purchase_order.purchase_order_items.build }

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @purchase_order }
    end
  end

  # GET /purchase_orders/1/edit
  def edit
    @purchase_order = PurchaseOrder.find(params[:id])
    @suppliers = Supplier.order("name")
  end

  # POST /purchase_orders
  # POST /purchase_orders.xml
  def create
    @purchase_order = PurchaseOrder.new(params[:purchase_order])

    @products = Product.order("name")
    @purchase_order.generate_order_number
    if @purchase_order.save
      Setting.increment_of_purchase_order
      flash[:notice] = (t "flashes.successfully_created")
      redirect_to @purchase_order
    else
      render :action => 'new'
    end
  end
  
  def complete
    purchase_order = PurchaseOrder.find(params[:id])
    purchase_order.mark_as_completed
    flash[:notice] = (t "flashes.successfully_updated")
    redirect_to purchase_order
  end
  
  def submit_pricing
    purchase_order = PurchaseOrder.find(params[:id])
    if params[:commit] == "Update"
      params[:pricing] ||= []

      params[:pricing].each {|p_id, content|
      pricing = purchase_order.purchase_order_items.find(p_id.to_i) rescue nil
      pricing.unit_price = content[:amount].to_f rescue 0.00
      pricing.save!
      }
    elsif params[:commit] == "Remove Selected"
      params[:item] ||= []

      params[:item].each {|p_id, content|
      item = purchase_order.purchase_order_items.find(p_id.to_i) rescue nil
      item.destroy if content[:selected].to_i == 1
      }
    end

    flash[:notice] = "Update completed"
    redirect_to(purchase_order)
  end
  
  def add_items
    if is_admin?
      @purchase_order = PurchaseOrder.find(params[:id])
      @purchase_order.add_order_items(params[:purchase_order_item])
    
      flash[:notice] = "Operation Completed"
      redirect_to @purchase_order
    else
      flash[:error] = "You cannot access this area"
      redirect_to :action => "index"
    end
  end
  

  # PUT /purchase_orders/1
  # PUT /purchase_orders/1.xml
  def update
    @purchase_order = PurchaseOrder.find(params[:id])

    respond_to do |format|
      if @purchase_order.update_attributes(params[:purchase_order])
        flash[:notice] = (t "flashes.successfully_updated")
        format.html { redirect_to(@purchase_order) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @purchase_order.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def void
    @purchase_order = PurchaseOrder.find(params[:id])
    @purchase_order.void = true
    @purchase_order.save
    flash[:notice] = (t "flashes.successfully_voided")
    redirect_to purchase_invoices_url
  end

  # DELETE /purchase_orders/1
  # DELETE /purchase_orders/1.xml
  def destroy
    @purchase_order = PurchaseOrder.find(params[:id])
    if @purchase_order.verify_for_destroy
      flash[:notice] = (t "flashes.successfully_destroyed")
    else
      flash[:error] = (t "flashes.cannot_destroy_pls_use_void")
    end

    respond_to do |format|
      format.html { redirect_back_or_default(purchase_orders_url) }
      format.xml  { head :ok }
    end
  end
  
  def remove_item
    @purchase_order = PurchaseOrder.find(params[:id])
    @purchase_order.purchase_order_items.find(params[:purchase_order_item_id]).destroy
    flash[:notice] = (t "flashes.successfully_removed")
    redirect_to(@purchase_order)
    
  end
  
  def preview
    @purchase_order = PurchaseOrder.find(params[:id])
    render :layout => false
  end
  
end
