class OutletDeliveryOrderItemsController < ApplicationController
  before_filter :authenticated_admin_and_user
  before_filter :check_menu_accessible
  before_filter :set_locale
  # GET /outlet_delivery_order_items
  # GET /outlet_delivery_order_items.xml
  def index
    @outlet_delivery_order_items = OutletDeliveryOrderItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @outlet_delivery_order_items }
    end
  end

  # GET /outlet_delivery_order_items/1
  # GET /outlet_delivery_order_items/1.xml
  def show
    @outlet_delivery_order_item = OutletDeliveryOrderItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @outlet_delivery_order_item }
    end
  end

  # GET /outlet_delivery_order_items/new
  # GET /outlet_delivery_order_items/new.xml
  def new
    @outlet_delivery_order_item = OutletDeliveryOrderItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @outlet_delivery_order_item }
    end
  end

  # GET /outlet_delivery_order_items/1/edit
  def edit
    @outlet_delivery_order_item = OutletDeliveryOrderItem.find(params[:id])
  end

  # POST /outlet_delivery_order_items
  # POST /outlet_delivery_order_items.xml
  def create
    @outlet_delivery_order_item = OutletDeliveryOrderItem.new(params[:outlet_delivery_order_item])

    respond_to do |format|
      if @outlet_delivery_order_item.save
        flash[:notice] = 'OutletDeliveryOrderItem was successfully created.'
        format.html { redirect_to(@outlet_delivery_order_item) }
        format.xml  { render :xml => @outlet_delivery_order_item, :status => :created, :location => @outlet_delivery_order_item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @outlet_delivery_order_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /outlet_delivery_order_items/1
  # PUT /outlet_delivery_order_items/1.xml
  def update
    @outlet_delivery_order_item = OutletDeliveryOrderItem.find(params[:id])

    respond_to do |format|
      if @outlet_delivery_order_item.update_attributes(params[:outlet_delivery_order_item])
        flash[:notice] = 'OutletDeliveryOrderItem was successfully updated.'
        format.html { redirect_to(@outlet_delivery_order_item) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @outlet_delivery_order_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /outlet_delivery_order_items/1
  # DELETE /outlet_delivery_order_items/1.xml
  def destroy
    @outlet_delivery_order_item = OutletDeliveryOrderItem.find(params[:id])
    @outlet_delivery_order_item.destroy

    respond_to do |format|
      format.html { redirect_to(outlet_delivery_order_items_url) }
      format.xml  { head :ok }
    end
  end
end
