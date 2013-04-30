class PurchaseInvoicesController < ApplicationController
  before_filter :authenticated_admin_and_user
  before_filter :check_menu_accessible
  before_filter :set_locale
  
  def index
    @purchase_invoices = PurchaseInvoice.active.order("invoice_number DESC").paginate(:page => params[:page], :per_page => 30)
  end
  
  def show
    @purchase_invoice = PurchaseInvoice.find(params[:id])
    @products = Product.order("name")
    @locations = StoreLocation.order("name")
    @current_items = @purchase_invoice.purchase_invoice_items
  end
  
  def new
    @purchase_invoice = PurchaseInvoice.new
    @products = Product.order("name")
    @locations = StoreLocation.order("name")
    1.upto(3) { @purchase_invoice.purchase_invoice_items.build }
  end
  
  def create
    @purchase_invoice = PurchaseInvoice.new(params[:purchase_invoice])
    @products = Product.order("name")
    @purchase_invoice.generate_invoice_number
    if @purchase_invoice.save
      Setting.increment_of_purchase_invoice
      flash[:notice] = (t "flashes.successfully_created")
      redirect_to @purchase_invoice
    else
      render :action => 'new'
    end
  end
  
  def add_items
    @purchase_invoice = PurchaseInvoice.find(params[:id])
    if @purchase_invoice.update_attributes(params[:purchase_invoice])
      flash[:notice] = (t "flashes.successfully_updated")
      redirect_to @purchase_invoice
    else
      flash[:error] = "Error"
      redirect_to @purchase_invoice
    end
  end
  
  
  def edit
    @purchase_invoice = PurchaseInvoice.find(params[:id])
    @suppliers = Supplier.order("name")
  end
  
  def update
    @purchase_invoice = PurchaseInvoice.find(params[:id])
    if @purchase_invoice.update_attributes(params[:purchase_invoice])
      flash[:notice] = (t "flashes.successfully_updated")
      redirect_to @purchase_invoice
    else
      render :action => 'edit'
    end
  end
  
  def void
    @purchase_invoice = PurchaseInvoice.find(params[:id])
    @purchase_invoice.void = true
    @purchase_invoice.save
    flash[:notice] = (t "flashes.successfully_voided")
    redirect_to purchase_invoices_url
  end
  
  def destroy
    @purchase_invoice = PurchaseInvoice.find(params[:id])
    if @purchase_invoice.verify_for_destroy
      flash[:notice] = (t "flashes.successfully_destroyed")
    else
      flash[:error] = (t "flashes.cannot_destroy_pls_use_void")
    end

    redirect_back_or_default(purchase_invoices_url)
  end
  
  def remove_item
    @purchase_invoice = PurchaseInvoice.find(params[:id])
    @purchase_invoice.purchase_invoice_items.find(params[:purchase_invoice_item_id]).destroy
    flash[:notice] = (t "flashes.successfully_removed")
    redirect_to(@purchase_invoice)
    
  end
  
  def preview
    @purchase_invoice = PurchaseInvoice.find(params[:id])
    render :layout => false
  end
  
end
