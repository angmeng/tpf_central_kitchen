class CustomersController < ApplicationController
  before_filter :authenticated_admin
  before_filter :check_menu_accessible
  before_filter :set_locale
  
  def index
    @search = Customer.order("name").search(params[:search])
    @customers = @search.paginate(:page => params[:page], :per_page => 50)
  end
  
  def show
    @customer = Customer.find(params[:id])
  end
  
  def new
    @customer = Customer.new
  end
  
  def edit_pricing
    @customer = Customer.find(params[:id])
    @pricings = @customer.customer_pricings
  end
  
  def submit_pricing
    customer = Customer.find(params[:id])
    
    params[:customer_pricing] ||= []
    
    params[:customer_pricing].each {|p_id, content|
    pricing = customer.customer_pricings.find(p_id.to_i) rescue nil
    pricing.amount = content[:amount].to_f rescue pricing.amount = 0.00 
    pricing.save!
     
    }
    flash[:notice] = "Update completed"
    redirect_to(edit_pricing_customer_path(customer))
  end
  
  def create
    @customer = Customer.new(params[:customer])
    if @customer.save
      flash[:notice] = (t "flashes.successfully_created")
      redirect_to @customer
    else
      render :action => 'new'
    end
  end
  
  def edit
    @customer = Customer.find(params[:id])
  end
  
  def update
    @customer = Customer.find(params[:id])
    if @customer.update_attributes(params[:customer])
      flash[:notice] = (t "flashes.successfully_updated")
      redirect_to @customer
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @customer = Customer.find(params[:id])
    checked, msg = @customer.verify_for_destroy
    if checked
      flash[:notice] = msg
    else
      flash[:error] = msg
    end
    
    redirect_back_or_default(customers_url)
  end
end
