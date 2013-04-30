class SuppliersController < ApplicationController
  before_filter :authenticated_admin
  before_filter :check_menu_accessible
  before_filter :set_locale
  
  def index
    @search = Supplier.search(params[:search])
    @suppliers = @search.order("name").paginate(:page => params[:page], :per_page => 50)
  end
  
  def show
    @supplier = Supplier.find(params[:id])
  end
  
  def new
    @supplier = Supplier.new
  end
  
  def create
    @supplier = Supplier.new(params[:supplier])
    if @supplier.save
      flash[:notice] = (t "flashes.successfully_created")
      redirect_to @supplier
    else
      render :action => 'new'
    end
  end
  
  def edit
    @supplier = Supplier.find(params[:id])
  end
  
  def update
    @supplier = Supplier.find(params[:id])
    if @supplier.update_attributes(params[:supplier])
      flash[:notice] = (t "flashes.successfully_updated")
      redirect_to @supplier
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @supplier = Supplier.find(params[:id])
    checked, msg = @supplier.verify_for_destroy
    if checked
      flash[:notice] = msg
    else
      flash[:error] = msg
    end
    
    redirect_back_or_default(suppliers_url)
  end
end
