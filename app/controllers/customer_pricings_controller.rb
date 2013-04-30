class CustomerPricingsController < ApplicationController
  before_filter :authenticated_admin_and_user
  before_filter :check_menu_accessible
  before_filter :set_locale
  # GET /customer_pricings
  # GET /customer_pricings.xml
  def index
    @customer_pricings = CustomerPricing.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @customer_pricings }
    end
  end

  # GET /customer_pricings/1
  # GET /customer_pricings/1.xml
  def show
    @customer_pricing = CustomerPricing.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @customer_pricing }
    end
  end

  # GET /customer_pricings/new
  # GET /customer_pricings/new.xml
  def new
    @customer_pricing = CustomerPricing.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @customer_pricing }
    end
  end

  # GET /customer_pricings/1/edit
  def edit
    @customer_pricing = CustomerPricing.find(params[:id])
  end

  # POST /customer_pricings
  # POST /customer_pricings.xml
  def create
    @customer_pricing = CustomerPricing.new(params[:customer_pricing])

    respond_to do |format|
      if @customer_pricing.save
        flash[:notice] = 'CustomerPricing was successfully created.'
        format.html { redirect_to(@customer_pricing) }
        format.xml  { render :xml => @customer_pricing, :status => :created, :location => @customer_pricing }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @customer_pricing.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /customer_pricings/1
  # PUT /customer_pricings/1.xml
  def update
    @customer_pricing = CustomerPricing.find(params[:id])

    respond_to do |format|
      if @customer_pricing.update_attributes(params[:customer_pricing])
        flash[:notice] = 'CustomerPricing was successfully updated.'
        format.html { redirect_to(@customer_pricing) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @customer_pricing.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /customer_pricings/1
  # DELETE /customer_pricings/1.xml
  def destroy
    @customer_pricing = CustomerPricing.find(params[:id])
    @customer_pricing.destroy

    respond_to do |format|
      format.html { redirect_to(customer_pricings_url) }
      format.xml  { head :ok }
    end
  end
end
