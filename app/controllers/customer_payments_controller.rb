class CustomerPaymentsController < ApplicationController
  before_filter :authenticated_admin_and_user
  before_filter :check_menu_accessible
  before_filter :set_locale
  
  def index
    @customer_payments = CustomerPayment.all
  end
  
  def show
    @customer_payment = CustomerPayment.find(params[:id])
    if @customer_payment.payment_method_id == PaymentMethod::CHEQUE 
       @cheque = Cheque.find_by_reference_id(@customer_payment.id)
    elsif @customer_payment.payment_method_id == PaymentMethod::CARD
       @credit_card = CreditCard.find_by_reference_id(@customer_payment.id)
    end
  end
  
  def new
    @customer_payment = CustomerPayment.new
  end
  
  def create
    @customer_payment = CustomerPayment.new(params[:customer_payment])
    
    if params[:customer_payment][:payment_method_id].to_i == PaymentMethod::CASH
      checked = @customer_payment.saving(PaymentMethod::CASH, nil)
    elsif params[:customer_payment][:payment_method_id].to_i == PaymentMethod::CHEQUE
      checked = @customer_payment.saving(PaymentMethod::CHEQUE, params[:cheque])
    elsif params[:customer_payment][:payment_method_id].to_i == PaymentMethod::CARD
      checked = @customer_payment.saving(PaymentMethod::CARD, params[:credit_card])
    else
      checked = @customer_payment.saving(PaymentMethod::CASH, nil)
    end
    
    
    if checked
      
      flash[:notice] = (t "flashes.successfully_created")
      redirect_to @customer_payment
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
#    @customer_payment = CustomerPayment.find(params[:id])
#  end
#  
#  def update
#    @customer_payment = CustomerPayment.find(params[:id])
#    if @customer_payment.update_attributes(params[:customer_payment])
#      flash[:notice] = "Successfully updated customer payment."
#      redirect_to @customer_payment
#    else
#      render :action => 'edit'
#    end
#  end
  
  def destroy
    @customer_payment = CustomerPayment.find(params[:id])
    @customer_payment.destroy
    flash[:notice] = (t "flashes.successfully_destroyed")
    redirect_to customer_payments_url
  end
end
