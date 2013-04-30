class CardCategoriesController < ApplicationController
  before_filter :authenticated_admin
  before_filter :set_locale
  
  def index
    @card_categories = CardCategory.all
  end
  
  def show
    @card_category = CardCategory.find(params[:id])
  end
  
  def new
    @card_category = CardCategory.new
  end
  
  def create
    @card_category = CardCategory.new(params[:card_category])
    if @card_category.save
      flash[:notice] = "Successfully created card category."
      redirect_to @card_category
    else
      render :action => 'new'
    end
  end
  
  def edit
    @card_category = CardCategory.find(params[:id])
  end
  
  def update
    @card_category = CardCategory.find(params[:id])
    if @card_category.update_attributes(params[:card_category])
      flash[:notice] = "Successfully updated card category."
      redirect_to @card_category
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @card_category = CardCategory.find(params[:id])
    @card_category.destroy
    flash[:notice] = "Successfully destroyed card category."
    redirect_to card_categories_url
  end
end
