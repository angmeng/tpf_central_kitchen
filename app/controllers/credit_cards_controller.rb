class CreditCardsController < ApplicationController
  before_filter :authenticated_admin
  before_filter :set_locale
  
  def index
    @credit_cards = CreditCard.all
  end
  
  def show
    @credit_card = CreditCard.find(params[:id])
  end
  
  def new
    @credit_card = CreditCard.new
  end
  
  def create
    @credit_card = CreditCard.new(params[:credit_card])
    if @credit_card.save
      flash[:notice] = "Successfully created credit card."
      redirect_to @credit_card
    else
      render :action => 'new'
    end
  end
  
  def edit
    @credit_card = CreditCard.find(params[:id])
  end
  
  def update
    @credit_card = CreditCard.find(params[:id])
    if @credit_card.update_attributes(params[:credit_card])
      flash[:notice] = "Successfully updated credit card."
      redirect_to @credit_card
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @credit_card = CreditCard.find(params[:id])
    @credit_card.destroy
    flash[:notice] = "Successfully destroyed credit card."
    redirect_to credit_cards_url
  end
end
