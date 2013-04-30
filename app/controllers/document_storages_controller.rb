class DocumentStoragesController < ApplicationController
  before_filter :authenticated_admin_and_user
  before_filter :check_menu_accessible
  before_filter :set_locale
  
  def category_index
    @document_categories = DocumentCategory.order("name")  
    session[:document_category_id] = nil
  end
  
  def index
    if params[:id]
      document_category = DocumentCategory.find(params[:id])
      session[:document_category_id] = document_category.id
    else
      document_category = DocumentCategory.find(session[:document_category_id])
    end

    if document_category.department_ids.include?(current_user_department_id)
      @document_storages = document_category.document_storages
      
    else
      flash[:error] = (t "flashes.dont_have_access_right")
      redirect_to category_index_document_storages_path
    end
  end
  
  def show
    document_category = DocumentCategory.find(session[:document_category_id])
    if document_category.department_ids.include?(current_user_department_id)
      @document_storage = DocumentStorage.find(params[:id])
    else
      flash[:error] = (t "flashes.dont_have_access_right")
      redirect_to category_index_document_storages_path
    end
    
  end
  
  def new
    @document_storage = DocumentStorage.new
  end
  
  def create
    @document_storage = DocumentStorage.new(params[:document_storage])
    if @document_storage.save
      flash[:notice] = (t "flashes.successfully_created")
      redirect_to @document_storage
    else
      render :action => 'new'
    end
  end
  
  def edit
    document_category = DocumentCategory.find(session[:document_category_id])
    if document_category.department_ids.include?(current_user_department_id)
      @document_storage = DocumentStorage.find(params[:id])
    else
      flash[:error] = (t "flashes.dont_have_access_right")
      redirect_to category_index_document_storages_path
    end
    
  end
  
  def update
    @document_storage = DocumentStorage.find(params[:id])
    if @document_storage.update_attributes(params[:document_storage])
      flash[:notice] = (t "flashes.successfully_updated")
      redirect_to @document_storage
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @document_storage = DocumentStorage.find(params[:id])
    @document_storage.document.destroy
    @document_storage.destroy
    flash[:notice] = (t "flashes.successfully_destroyed")
    redirect_back_or_default(document_storages_url)
  end
end
