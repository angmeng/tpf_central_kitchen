class InvoicesController < ApplicationController
  before_filter :authenticated_admin_and_user
  before_filter :check_menu_accessible
  before_filter :set_locale
  
  
  def index
    @invoices = Invoice.active.order("invoice_number DESC").paginate(:page => params[:page], :per_page => 30)
  end
  
  def show
    @invoice = Invoice.find(params[:id])
    @products = Product.order("name")
    @locations = StoreLocation.order("name")
    @current_items = @invoice.invoice_items.joins(:product)
 
  end
  
  def new
    @invoice = Invoice.new
    @products = Product.order("name")
    @locations = StoreLocation.order("name")
    1.upto(3) { @invoice.invoice_items.build }
  end
  
  def create
    @invoice = Invoice.new(params[:invoice])
    @products = Product.order("name")
    @invoice.generate_invoice_number
    if @invoice.save
      @invoice.receive_items(params[:product])
      Setting.increment_of_invoice
      flash[:notice] = (t "flashes.successfully_created")
      redirect_to @invoice
    else
      render :action => 'new'
    end
  end
  
  def complete
    invoice = Invoice.find(params[:id])
    invoice.mark_as_completed
    flash[:notice] = (t "flashes.successfully_updated")
    redirect_to invoice
  end
  
  def submit_pricing
    invoice = Invoice.find(params[:id])

    if params[:commit] == "Update"
      params[:pricing] ||= []

      params[:pricing].each {|p_id, content|
      pricing = invoice.invoice_items.find(p_id.to_i) rescue nil
      pricing.unit_price = content[:amount].to_f rescue 0.00
      pricing.save!

      }
    elsif params[:commit] == "Remove Selected"
      params[:item] ||= []

      params[:item].each {|p_id, content|
      pricing = invoice.invoice_items.find(p_id.to_i) rescue nil
      pricing.destroy if pricing and content[:selected].to_i == 1

      }

    end

    # params[:commission] ||= []
    # 
    # params[:commission].each {|p_id, content|
    # comm = invoice.invoice_items.find(p_id.to_i) rescue nil
    # comm.commission = content[:percentage].to_f rescue 0.00 
    # comm.save!
    #  
    # }
    flash[:notice] = "Update completed"
    redirect_to(invoice)
  end
  
  def add_items
    
    if is_admin?
      @invoice = Invoice.find(params[:id])
      @invoice.add_invoice_items(params[:invoice_item])
    
      flash[:notice] = "Operation Completed"
      redirect_to @invoice
    else
      flash[:error] = "You cannot access this area"
      redirect_to :action => "index"
    end
  end
  
  def edit
    @invoice = Invoice.find(params[:id])
    @customers = Customer.order("name")
  end
  
  def update
    @invoice = Invoice.find(params[:id])
    if @invoice.update_attributes(params[:invoice])
      flash[:notice] = (t "flashes.successfully_updated")
      redirect_to @invoice
    else
      render :action => 'edit'
    end
  end
  
  def void
    @invoice = Invoice.find(params[:id])
    @invoice.void = true
    @invoice.save
    flash[:notice] = (t "flashes.successfully_voided")
    redirect_to invoices_url
  end
  
  def destroy
    @invoice = Invoice.find(params[:id])
    if @invoice.verify_for_destroy
      flash[:notice] = (t "flashes.successfully_destroyed")
    else
      flash[:error] = (t "flashes.cannot_destroy_pls_use_void")
    end
    
    redirect_back_or_default(invoices_url)
  end
  
  def remove_item
    @invoice = Invoice.find(params[:id])
    @invoice.invoice_items.find(params[:invoice_item_id]).destroy
    flash[:notice] = (t "flashes.successfully_removed")
    redirect_to(@invoice)
    
  end
  
  def preview
    @invoice = Invoice.find(params[:id])
    render :layout => false
  end
  
  
end
