class PackingOrderItemsController < ApplicationController
  before_filter :authenticated_admin_and_user
  before_filter :check_menu_accessible
  before_filter :set_locale
  # GET /packing_order_items
  # GET /packing_order_items.xml
  def index
    @packing_order_items = PackingOrderItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @packing_order_items }
    end
  end

  # GET /packing_order_items/1
  # GET /packing_order_items/1.xml
  def show
    @packing_order_item = PackingOrderItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @packing_order_item }
    end
  end

  # GET /packing_order_items/new
  # GET /packing_order_items/new.xml
  def new
    @packing_order_item = PackingOrderItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @packing_order_item }
    end
  end

  # GET /packing_order_items/1/edit
  def edit
    @packing_order_item = PackingOrderItem.find(params[:id])
  end

  # POST /packing_order_items
  # POST /packing_order_items.xml
  def create
    @packing_order_item = PackingOrderItem.new(params[:packing_order_item])

    respond_to do |format|
      if @packing_order_item.save
        flash[:notice] = 'PackingOrderItem was successfully created.'
        format.html { redirect_to(@packing_order_item) }
        format.xml  { render :xml => @packing_order_item, :status => :created, :location => @packing_order_item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @packing_order_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /packing_order_items/1
  # PUT /packing_order_items/1.xml
  def update
    @packing_order_item = PackingOrderItem.find(params[:id])

    respond_to do |format|
      if @packing_order_item.update_attributes(params[:packing_order_item])
        flash[:notice] = 'PackingOrderItem was successfully updated.'
        format.html { redirect_to(@packing_order_item) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @packing_order_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /packing_order_items/1
  # DELETE /packing_order_items/1.xml
  def destroy
    @packing_order_item = PackingOrderItem.find(params[:id])
    @packing_order_item.destroy

    respond_to do |format|
      format.html { redirect_to(packing_order_items_url) }
      format.xml  { head :ok }
    end
  end
end
