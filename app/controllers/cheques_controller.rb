class ChequesController < ApplicationController
  before_filter :authenticated_admin
  before_filter :set_locale
  
  def index
    
    session[:search_date] =  Date.parse(params[:cheque_date]) if params[:cheque_date] and params[:cheque_date] != ""
    if session[:search_date]
      @search = Cheque.where("cheque_date = ?", session[:search_date]).search(params[:search])
    else
      @search = Cheque.search(params[:search])
    end
    @cheques = @search.all
  
  end
  
  def show
    @cheque = Cheque.find(params[:id])
  end
  
  def show_current_date_own
    @cheques = Cheque.get_current_date_own_cheque
    render :template => '/cheques/info'
  end
  
  def show_current_date_customer
    @cheques = Cheque.get_current_date_customer_cheque
    render :template => '/cheques/info'
  end
  
  def show_future_own
    @cheques = Cheque.get_future_own_cheque
    render :template => '/cheques/info'
  end
  
  def show_future_customer
    @cheques = Cheque.get_future_customer_cheque
    render :template => '/cheques/info'
  end
  
  
  
#  def new
#    @cheque = Cheque.new
#  end
  
#  def create
#    @cheque = Cheque.new(params[:cheque])
#    if @cheque.save
#      flash[:notice] = "Successfully created cheque."
#      redirect_to @cheque
#    else
#      render :action => 'new'
#    end
#  end
  
  def edit
    @cheque = Cheque.find(params[:id])
  end
  
  def update
    @cheque = Cheque.find(params[:id])
    if @cheque.update_attributes(params[:cheque])
      flash[:notice] = "Successfully updated cheque."
      redirect_to @cheque
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @cheque = Cheque.find(params[:id])
    @cheque.destroy
    flash[:notice] = "Successfully destroyed cheque."
    redirect_to cheques_url
  end
end
