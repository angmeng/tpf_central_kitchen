class StocksController < ApplicationController
  before_filter :authenticated_admin
  before_filter :check_menu_accessible
  before_filter :set_locale
  
  def index
    @search = Stock.search(params[:search])
    @stocks = @search.all
  end
  
  def show
    @stock = Stock.find(params[:id])
  end
  
  def new
    @stock = Stock.new
  end
  
  def create
    @stock = Stock.new(params[:stock])
    if @stock.save
      flash[:notice] = (t "flashes.successfully_created")
      redirect_to @stock
    else
      render :action => 'new'
    end
  end
  
  def edit
    @stock = Stock.find(params[:id])
  end
  
  def update
    @stock = Stock.find(params[:id])
    if @stock.update_attributes(params[:stock])
      flash[:notice] = (t "flashes.successfully_updated")
      redirect_to @stock
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @stock = Stock.find(params[:id])
    @stock.destroy
    flash[:notice] = (t "flashes.successfully_destroyed")
    redirect_back_or_default(stocks_url)
  end
end
