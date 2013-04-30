class DocumentCategoriesController < ApplicationController
  before_filter :authenticated_admin
  before_filter :check_menu_accessible
  before_filter :set_locale
  
  def index
    @document_categories = DocumentCategory.all
  end
  
  def show
    @document_category = DocumentCategory.find(params[:id])
  end
  
  def new
    @document_category = DocumentCategory.new
  end
  
  def create
    @document_category = DocumentCategory.new(params[:document_category])
    if @document_category.save
      flash[:notice] = (t "flashes.successfully_created")
      redirect_to @document_category
    else
      render :action => 'new'
    end
  end
  
  def edit
    @document_category = DocumentCategory.find(params[:id])
  end
  
  def update
    params[:document_category][:department_ids] ||= []
    @document_category = DocumentCategory.find(params[:id])
    if @document_category.update_attributes(params[:document_category])
      flash[:notice] = (t "flashes.successfully_updated")
      redirect_to @document_category
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @document_category = DocumentCategory.find(params[:id])
    checked, msg = @document_category.verify_destroy
    
    if checked
      flash[:notice] = msg  
    else
      flash[:error] = msg
    end
    
    redirect_back_or_default(document_categories_url)
  end
end
