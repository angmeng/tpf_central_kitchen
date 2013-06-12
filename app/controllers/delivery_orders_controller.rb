class DeliveryOrdersController < ApplicationController
  # GET /delivery_orders
  # GET /delivery_orders.json
  def index
    @delivery_orders = DeliveryOrder.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @delivery_orders }
    end
  end

  # GET /delivery_orders/1
  # GET /delivery_orders/1.json
  def show
    @delivery_order = DeliveryOrder.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @delivery_order }
    end
  end

  # GET /delivery_orders/new
  # GET /delivery_orders/new.json
  def new
    @delivery_order = DeliveryOrder.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @delivery_order }
    end
  end

  # GET /delivery_orders/1/edit
  def edit
    @delivery_order = DeliveryOrder.find(params[:id])
  end

  # POST /delivery_orders
  # POST /delivery_orders.json
  def create
    @delivery_order = DeliveryOrder.new(params[:delivery_order])

    respond_to do |format|
      if @delivery_order.save
        format.html { redirect_to @delivery_order, notice: 'Delivery order was successfully created.' }
        format.json { render json: @delivery_order, status: :created, location: @delivery_order }
      else
        format.html { render action: "new" }
        format.json { render json: @delivery_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /delivery_orders/1
  # PUT /delivery_orders/1.json
  def update
    @delivery_order = DeliveryOrder.find(params[:id])

    respond_to do |format|
      if @delivery_order.update_attributes(params[:delivery_order])
        format.html { redirect_to @delivery_order, notice: 'Delivery order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @delivery_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /delivery_orders/1
  # DELETE /delivery_orders/1.json
  def destroy
    @delivery_order = DeliveryOrder.find(params[:id])
    @delivery_order.destroy

    respond_to do |format|
      format.html { redirect_to delivery_orders_url }
      format.json { head :no_content }
    end
  end

  def preview
    @delivery_order = DeliveryOrder.find(params[:id])
    render :layout => false
  end
  
end
