class ApplicationController < ActionController::Base
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  include Authentication
  helper :all # include all helpers, all the time
  
  before_filter :store_location

  helper_method :is_admin?
  helper_method :is_super_admin?
  helper_method :is_user?
  helper_method :is_dc?
  helper_method :is_store?
  helper_method :current_user_department_id
  helper_method :current_user
  helper_method :is_outlet_staff?
  
  
 
  protected
  
  def check_menu_accessible
    if is_admin? and current_user_department_id > 1
      found = AccessibleMenu.find_by_name(controller_name)
      unless current_user.department.accessible_menus.include?(found)
        flash[:error] = "Unauthorized access"
        redirect_to home_url
      end
    end
  end
    
  def set_locale
    I18n.locale = :en
  end
  
  def authenticated_admin
    unless is_admin?
      flash[:error] = "Unauthorized access"
      redirect_to logout_url
    end
  end
  
  def authenticated_admin_and_user
    unless is_admin? or is_outlet_staff?
      flash[:error] = "Unauthorized access"
      redirect_to logout_url
    end
  end
  
  def warning_message
    @setting ||= Setting.first
    flash[:warning] = "Your Lisence is expired, please contact your administrator to prevent data lost." if @setting.blowfish <= Date.today 
  
  end

  def current_user_department_id
    current_user.department_id
  end
  
  
  def is_admin?
    current_user.department_id > 0
  end
  
  def is_super_admin?
    current_user.department_id == Department::ADMIN
  end
  
  
  def is_outlet_staff?
    current_user.class.to_s == "OutletStaff"
  end
  
  def current_user_outlet_id
    if is_outlet_staff?
      current_user.outlet_id
    else
      return 0
    end
  end
  
  def store_location
    session[:back] = request.referer
  end

  def redirect_back_or_default(default)
    redirect_to(session[:back] || default)
    session[:back] = nil
  end
end
