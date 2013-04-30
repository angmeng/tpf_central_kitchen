class ExpensesController < ApplicationController
  before_filter :authenticated_admin_and_user
  before_filter :check_menu_accessible
  before_filter :set_locale
  
  def index
    @expenses = Expense.all
  end
  
  def show
    @expense = Expense.find(params[:id])
  end
  
  def new
    @expense = Expense.new
  end
  
  def create
    @expense = Expense.new(params[:expense])
    if @expense.save
      flash[:notice] = (t "flashes.successfully_created")
      redirect_to @expense
    else
      render :action => 'new'
    end
  end
  
  def edit
    @expense = Expense.find(params[:id])
  end
  
  def update
    @expense = Expense.find(params[:id])
    if @expense.update_attributes(params[:expense])
      flash[:notice] = (t "flashes.successfully_updated")
      redirect_to @expense
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @expense = Expense.find(params[:id])
    @expense.destroy
    flash[:notice] = (t "flashes.successfully_destroyed")
    redirect_back_or_default(expenses_url)
  end
end
