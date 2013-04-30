# coding: utf-8
class HomeController < ApplicationController
  before_filter :authenticated_admin_and_user
  before_filter :set_locale
  
  def index
 
    if is_outlet_staff?
      @orders = OutletPurchaseOrder.unsettled.where("outlet_id = ?", current_user_outlet_id)
    elsif is_admin?
      @orders = OutletPurchaseOrder.unsettled
    end
  end

  def change_language
    session[:locale] == :cn ? session[:locale] = :en : session[:locale] = :cn
    redirect_to :action => "index"
  end


end
