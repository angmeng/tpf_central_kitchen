class StoreLocationsController < ApplicationController
  before_filter :authenticated_admin
  before_filter :check_menu_accessible
  before_filter :set_locale
  
  def index
    @store_locations = StoreLocation.all
  end
  
  def show
    @store_location = StoreLocation.find(params[:id])
    @stocks = @store_location.stocks
  end
  
  def update_balance
    store_location = StoreLocation.find(params[:id])
    params[:stock].each do |stock_id, content|
      st = Stock.find(stock_id)
      st.update_attributes(:opening_balance => content[:open_balance].to_i) if st
    end
    flash[:notice] = (t "flashes.successfully_updated")
    redirect_to store_location
  end
  
  def new
    @store_location = StoreLocation.new
  end
  
  def create
    @store_location = StoreLocation.new(params[:store_location])
    if @store_location.save
      flash[:notice] = (t "flashes.successfully_created")
      redirect_to @store_location
    else
      render :action => 'new'
    end
  end
  
  def edit
    @store_location = StoreLocation.find(params[:id])
  end
  
  def update
    @store_location = StoreLocation.find(params[:id])
    if @store_location.update_attributes(params[:store_location])
      flash[:notice] = (t "flashes.successfully_updated")
      redirect_to @store_location
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @store_location = StoreLocation.find(params[:id])
    checked, msg = @store_location.verify_for_destroy
    
    if checked
      flash[:notice] = msg
    else
      flash[:error] = msg
    end
      redirect_back_or_default(store_locations_url)
  end
end
