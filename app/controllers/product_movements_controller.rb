class ProductMovementsController < ApplicationController
  before_filter :authenticated_admin
  before_filter :check_menu_accessible
  before_filter :set_locale
  
  def index
    @products = Product.order("name")
    #ProductMovement.all
    
  end
  
  def search
    if params[:search]
      @product = Product.find(params[:search][:product_id].to_i)
      session[:product_id] = @product.id
      @movements = ProductMovement.where("product_id = ?", params[:search][:product_id].to_i).order("movement_date, id")
      @filters = ProductMovement.calculate_balance(@movements, @product)
      @product_movements = @filters.paginate(:page => params[:page], :per_page => 50)
    else
      @product ||= Product.find(session[:product_id].to_i)
      @movements ||= ProductMovement.where("product_id = ?", session[:product_id].to_i).order("movement_date, id")
      @filters ||= ProductMovement.calculate_balance(@movements, @product)
      @product_movements ||= @filters.paginate(:page => params[:page], :per_page => 50)
    end
  end
  
  def show
    @product_movement = ProductMovement.find(params[:id])
  end
  
#  def new
#    @product_movement = ProductMovement.new
#  end
#  
#  def create
#    @product_movement = ProductMovement.new(params[:product_movement])
#    if @product_movement.save
#      flash[:notice] = "Successfully created product movement."
#      redirect_to @product_movement
#    else
#      render :action => 'new'
#    end
#  end
#  
#  def edit
#    @product_movement = ProductMovement.find(params[:id])
#  end
#  
#  def update
#    @product_movement = ProductMovement.find(params[:id])
#    if @product_movement.update_attributes(params[:product_movement])
#      flash[:notice] = "Successfully updated product movement."
#      redirect_to @product_movement
#    else
#      render :action => 'edit'
#    end
#  end
#  
#  def destroy
#    @product_movement = ProductMovement.find(params[:id])
#    @product_movement.destroy
#    flash[:notice] = "Successfully destroyed product movement."
#    redirect_to product_movements_url
#  end
end
