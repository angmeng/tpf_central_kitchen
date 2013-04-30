class OutletDeliveryOrdersController < ApplicationController
  before_filter :authenticated_admin_and_user
  before_filter :check_menu_accessible
  before_filter :set_locale
  # GET /outlet_delivery_orders
  # GET /outlet_delivery_orders.xml
  def index
    @outlet_delivery_orders = OutletDeliveryOrder.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @outlet_delivery_orders }
    end
  end

  # GET /outlet_delivery_orders/1
  # GET /outlet_delivery_orders/1.xml
  def show
    @outlet_delivery_order = OutletDeliveryOrder.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @outlet_delivery_order }
    end
  end

  # GET /outlet_delivery_orders/new
  # GET /outlet_delivery_orders/new.xml
  def new
    @outlet_delivery_order = OutletDeliveryOrder.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @outlet_delivery_order }
    end
  end

  # GET /outlet_delivery_orders/1/edit
  def edit
    @outlet_delivery_order = OutletDeliveryOrder.find(params[:id])
  end

  # POST /outlet_delivery_orders
  # POST /outlet_delivery_orders.xml
  def create
    @outlet_delivery_order = OutletDeliveryOrder.new(params[:outlet_delivery_order])

    respond_to do |format|
      if @outlet_delivery_order.save
        flash[:notice] = 'OutletDeliveryOrder was successfully created.'
        format.html { redirect_to(@outlet_delivery_order) }
        format.xml  { render :xml => @outlet_delivery_order, :status => :created, :location => @outlet_delivery_order }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @outlet_delivery_order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /outlet_delivery_orders/1
  # PUT /outlet_delivery_orders/1.xml
  def update
    @outlet_delivery_order = OutletDeliveryOrder.find(params[:id])

    respond_to do |format|
      if @outlet_delivery_order.update_attributes(params[:outlet_delivery_order])
        flash[:notice] = 'OutletDeliveryOrder was successfully updated.'
        format.html { redirect_to(@outlet_delivery_order) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @outlet_delivery_order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /outlet_delivery_orders/1
  # DELETE /outlet_delivery_orders/1.xml
  def destroy
    @outlet_delivery_order = OutletDeliveryOrder.find(params[:id])
    @outlet_delivery_order.destroy

    respond_to do |format|
      format.html { redirect_to(outlet_delivery_orders_url) }
      format.xml  { head :ok }
    end
  end
end
