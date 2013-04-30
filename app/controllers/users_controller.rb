class UsersController < ApplicationController
  before_filter :authenticated_admin_and_user
  before_filter :check_menu_accessible, :only => [:index, :new, :create, :destroy]
  before_filter :set_locale
  
  def index
    if is_super_admin?
      @users = User.order("username").paginate(:page => params[:page], :per_page => 20)
    else
      @users = User.where("id = ? ", session[:user_id]).order("username").paginate(:page => params[:page], :per_page => 20)
    end
  end
  
  def edit
    if is_super_admin?
      @user = User.find(params[:id])
    else
      if is_outlet_staff?
        flash[:error] = "Unauthorized access"
        redirect_to(home_url)
      else
        @user = User.find(session[:user_id])
      end
    end

  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = (t "flashes.successfully_updated")
      redirect_to @user
    else
      flash[:error] = (t "flashes.saving_failed")
      render :action => "edit"
      
    end
  end
  
  def change_password
    if is_super_admin?
      @user = User.find(params[:id])
    else
      if is_outlet_staff?
        flash[:error] = "Unauthorized access"
        redirect_to(home_url)
      else
        @user = User.find(session[:user_id])
      end
    end
  end
  
  def update_password
    @user = User.find(params[:id])
    
    passed, msg = @user.check_password(params[:user])
    
    if passed
      flash[:notice] = msg
      redirect_to @user
    else
      flash[:error] = msg
      render :action => "change_password"
      
    end
  end
  
  def new
    if is_super_admin?
      @user = User.new
    else
      if is_outlet_staff?
        flash[:error] = "Unauthorized access"
        redirect_to(home_url)
      else
        flash[:error] = "Unauthorized access"
        redirect_to(home_url)
      end
    end
  end
  
  def show
    if is_super_admin?
      @user = User.find(params[:id])
    else
      if is_outlet_staff?
        flash[:error] = "Unauthorized access"
        redirect_to(home_url)
      else
        @user = User.find(session[:user_id])
      end
    end
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = (t "flashes.successfully_created")
      redirect_to @user
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    
    passed, msg = @user.verify_destroy
    if passed
      flash[:notice] = msg
    else
      flash[:error] = msg
    end
    redirect_back_or_default(users_url)
  end
  
end
