class BanksController < ApplicationController
  before_filter :authenticated_admin
  before_filter :set_locale
  
  def index
    @banks = Bank.all
  end
  
  def show
    @bank = Bank.find(params[:id])
  end
  
  def new
    @bank = Bank.new
  end
  
  def create
    @bank = Bank.new(params[:bank])
    if @bank.save
      flash[:notice] = "Successfully created bank."
      redirect_to @bank
    else
      render :action => 'new'
    end
  end
  
  def edit
    @bank = Bank.find(params[:id])
  end
  
  def update
    @bank = Bank.find(params[:id])
    if @bank.update_attributes(params[:bank])
      flash[:notice] = "Successfully updated bank."
      redirect_to @bank
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @bank = Bank.find(params[:id])
    @bank.destroy
    flash[:notice] = "Successfully destroyed bank."
    redirect_to banks_url
  end
end
