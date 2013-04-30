class StockAdjustmentsController < ApplicationController
  before_filter :authenticated_admin
  before_filter :check_menu_accessible
  before_filter :set_locale
  
  def index
    @stock_adjustments = StockAdjustment.all
  end
  
  def show
    @stock_adjustment = StockAdjustment.find(params[:id])
  end
  
  def new
    @stock_adjustment = StockAdjustment.new
    @locations = StoreLocation.all(:order => "name")
    @products = Product.all(:order => "name")
  end
  
  def create
    @stock_adjustment = StockAdjustment.new(params[:stock_adjustment])
    if @stock_adjustment.save
      flash[:notice] = (t "flashes.successfully_created")
      redirect_to @stock_adjustment
    else
      @locations = StoreLocation.all(:order => "name")
      @products = Product.all(:order => "name")
      render :action => 'new'
    end
  end
  
#  def edit
#    @stock_adjustment = StockAdjustment.find(params[:id])
#  end
  
#  def update
#    @stock_adjustment = StockAdjustment.find(params[:id])
#    if @stock_adjustment.update_attributes(params[:stock_adjustment])
#      flash[:notice] = "Successfully updated stock adjustment."
#      redirect_to @stock_adjustment
#    else
#      render :action => 'edit'
#    end
#  end
  
  def destroy
    @stock_adjustment = StockAdjustment.find(params[:id])
    @stock_adjustment.destroy
    flash[:notice] = (t "flashes.successfully_destroyed")
    redirect_back_or_default(stock_adjustments_url)
  end
end
