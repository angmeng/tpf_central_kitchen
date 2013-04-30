class PurchaseInvoiceItemsController < ApplicationController
  before_filter :authenticated_admin_and_user
  before_filter :check_menu_accessible
  before_filter :set_locale
  
  def index
    @purchase_invoice_items = PurchaseInvoiceItem.all
  end
  
  def show
    @purchase_invoice_item = PurchaseInvoiceItem.find(params[:id])
  end
  
  def new
    @purchase_invoice_item = PurchaseInvoiceItem.new
  end
  
  def create
    @purchase_invoice_item = PurchaseInvoiceItem.new(params[:purchase_invoice_item])
    if @purchase_invoice_item.save
      flash[:notice] = "Successfully created purchase invoice item."
      redirect_to @purchase_invoice_item
    else
      render :action => 'new'
    end
  end
  
  def edit
    @purchase_invoice_item = PurchaseInvoiceItem.find(params[:id])
  end
  
  def update
    @purchase_invoice_item = PurchaseInvoiceItem.find(params[:id])
    if @purchase_invoice_item.update_attributes(params[:purchase_invoice_item])
      flash[:notice] = "Successfully updated purchase invoice item."
      redirect_to @purchase_invoice_item
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @purchase_invoice_item = PurchaseInvoiceItem.find(params[:id])
    @purchase_invoice_item.destroy
    flash[:notice] = "Successfully destroyed purchase invoice item."
    redirect_to purchase_invoice_items_url
  end
end
