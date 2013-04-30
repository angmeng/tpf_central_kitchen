class StockTransfersController < ApplicationController
  before_filter :authenticated_admin_and_user
  before_filter :check_menu_accessible
  before_filter :set_locale
  # GET /stock_transfers
  # GET /stock_transfers.xml
  def index
    @stock_transfers = StockTransfer.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stock_transfers }
    end
  end

  # GET /stock_transfers/1
  # GET /stock_transfers/1.xml
  def show
    @stock_transfer = StockTransfer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @stock_transfer }
    end
  end

  # GET /stock_transfers/new
  # GET /stock_transfers/new.xml
  def new
    @stock_transfer = StockTransfer.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @stock_transfer }
    end
  end

  # GET /stock_transfers/1/edit
  def edit
    @stock_transfer = StockTransfer.find(params[:id])
  end

  # POST /stock_transfers
  # POST /stock_transfers.xml
  def create
   
    @stock_transfer = StockTransfer.new(params[:stock_transfer])
    @stock_transfer.user_id = session[:user_id]

      checked, msg = @stock_transfer.check_quantity
      if checked
        if @stock_transfer.save
          flash[:notice] = msg
          redirect_to(@stock_transfer)
        else
          render :action => "new"
        end
      
      else
        flash[:error] = msg
        render :action => "new"
      end
   
  end

  # PUT /stock_transfers/1
  # PUT /stock_transfers/1.xml
  def update
    @stock_transfer = StockTransfer.find(params[:id])

    respond_to do |format|
      if @stock_transfer.update_attributes(params[:stock_transfer])
        flash[:notice] = 'StockTransfer was successfully updated.'
        format.html { redirect_to(@stock_transfer) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @stock_transfer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /stock_transfers/1
  # DELETE /stock_transfers/1.xml
  def destroy
    @stock_transfer = StockTransfer.find(params[:id])
    @stock_transfer.destroy
    
    flash[:notice] = "Stock Transfer successfully destroyed"

    respond_to do |format|
      format.html { redirect_back_or_default(stock_transfers_url) }
      format.xml  { head :ok }
    end
  end
end
