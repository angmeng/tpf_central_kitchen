class SupplierPaymentsController < ApplicationController
  before_filter :authenticated_admin_and_user
  before_filter :check_menu_accessible
  before_filter :set_locale
  
  def index
    @supplier_payments = SupplierPayment.all
  end
  
  def show
    @supplier_payment = SupplierPayment.find(params[:id])
    if @supplier_payment.payment_method_id == PaymentMethod::CHEQUE 
       @cheque = Cheque.find_by_reference_id(@supplier_payment.id)
    elsif @supplier_payment.payment_method_id == PaymentMethod::CARD
       @credit_card = CreditCard.find_by_reference_id(@supplier_payment.id)
    end
  end
  
  def new
    @supplier_payment = SupplierPayment.new
  end
  
  def create
    @supplier_payment = SupplierPayment.new(params[:supplier_payment])

    
    if params[:supplier_payment][:payment_method_id].to_i == PaymentMethod::CASH
      checked = @supplier_payment.saving(PaymentMethod::CASH, nil)
    elsif params[:supplier_payment][:payment_method_id].to_i == PaymentMethod::CHEQUE
      checked = @supplier_payment.saving(PaymentMethod::CHEQUE, params[:cheque])
    elsif params[:supplier_payment][:payment_method_id].to_i == PaymentMethod::CARD
      checked = @supplier_payment.saving(PaymentMethod::CARD, params[:credit_card])
    else
      checked = @supplier_payment.saving(PaymentMethod::CASH, nil)
    end
    
    
    if checked
      
      flash[:notice] = (t "flashes.successfully_created")
      redirect_to @supplier_payment
    else
      render :action => 'new'
    end
    
  end
  
  def show_payment_info
    payment = PaymentMethod.find(params[:id]) if params[:id] rescue nil
    
    render :update do |page| 
      if payment.name == "Cheque"
        page.show 'payment_info'
        page.replace_html 'payment_info', :partial => 'cheque_info' #, :object => @person
      elsif payment.name == "Credit Card"
        page.show 'payment_info'
        page.replace_html 'payment_info', :partial => 'card_info' #, :object => @person
      else
        page.hide 'payment_info'
      end if payment
    end
  end
  
#  def edit
#    @supplier_payment = SupplierPayment.find(params[:id])
#  end
#  
#  def update
#    @supplier_payment = SupplierPayment.find(params[:id])
#    if @supplier_payment.update_attributes(params[:supplier_payment])
#      flash[:notice] = "Successfully updated supplier payment."
#      redirect_to @supplier_payment
#    else
#      render :action => 'edit'
#    end
#  end
  
  def destroy
    @supplier_payment = SupplierPayment.find(params[:id])
    @supplier_payment.destroy
    flash[:notice] = (t "flashes.successfully_destroyed")
    redirect_back_or_default(supplier_payments_url)
  end
end
