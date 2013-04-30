class ProductCategoriesController < ApplicationController
  before_filter :authenticated_admin
  before_filter :set_locale
  
  def index
    @product_categories = ProductCategory.paginate(:page => params[:page], :per_page => 50)
  end
  
  def show
    @product_category = ProductCategory.find(params[:id])
  end
  
  def new
    @product_category = ProductCategory.new
  end
  
  def create
    @product_category = ProductCategory.new(params[:product_category])
    if @product_category.save
      flash[:notice] = (t "flashes.successfully_created")
      redirect_to @product_category
    else
      render :action => 'new'
    end
  end
  
  def edit
    @product_category = ProductCategory.find(params[:id])
  end
  
  def update
    @product_category = ProductCategory.find(params[:id])
    if @product_category.update_attributes(params[:product_category])
      flash[:notice] = (t "flashes.successfully_updated")
      redirect_to @product_category
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @product_category = ProductCategory.find(params[:id])
    check, msg = @product_category.verify_destroy
    
    if check
      flash[:notice] = msg
    else
      flash[:error] = msg
    end
    
    redirect_back_or_default(product_categories_url)
  end
end
