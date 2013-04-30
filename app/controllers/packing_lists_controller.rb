class PackingListsController < ApplicationController
  before_filter :authenticated_admin_and_user
  before_filter :check_menu_accessible
  before_filter :set_locale
  # GET /packing_lists
  # GET /packing_lists.xml
  def index
    @packing_lists = PackingList.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @packing_lists }
    end
  end

  # GET /packing_lists/1
  # GET /packing_lists/1.xml
  def show
    @packing_list = PackingList.find(params[:id])
    @prs = OutletPurchaseOrder.unsettled
    @items = @packing_list.packing_order_items
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @packing_list }
    end
  end

  # GET /packing_lists/new
  # GET /packing_lists/new.xml
  def new
    @packing_list = PackingList.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @packing_list }
    end
  end

  # GET /packing_lists/1/edit
  def edit
    @packing_list = PackingList.find(params[:id])
  end

  # POST /packing_lists
  # POST /packing_lists.xml
  def create
    @packing_list = PackingList.new(params[:packing_list])

    respond_to do |format|
      if @packing_list.save
        flash[:notice] = 'PackingList was successfully created.'
        format.html { redirect_to(@packing_list) }
        format.xml  { render :xml => @packing_list, :status => :created, :location => @packing_list }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @packing_list.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def preview
    @packing_list = PackingList.find(params[:id])
    @items = @packing_list.packing_order_items
    render :layout => false
  end
  
  def picked_items
    packing_list = PackingList.find(params[:id])
    
    params[:item] ||= []

    params[:item].each do |id, content|
      r = packing_list.packing_order_items.find(id)
      qty = content[:picked_quantity].to_i
      if qty <= r.quantity
        r.picked_quantity = qty
        r.save!
      end
    end
    
    flash[:notice] = "Status Updated"
    redirect_to(packing_list)
  end
  
  def confirm
    packing_list = PackingList.find(params[:id])
    unless packing_list.settled
      checked, msg, invoice = packing_list.generate_invoice
      checked ? flash[:notice] = msg : flash[:error] = msg
    else
      invoice = packing_list.outlet_purchase_order.invoice
    end

    redirect_to(invoice)
  end

  # PUT /packing_lists/1
  # PUT /packing_lists/1.xml
  def update
    @packing_list = PackingList.find(params[:id])

    respond_to do |format|
      if @packing_list.update_attributes(params[:packing_list])
        flash[:notice] = 'PackingList was successfully updated.'
        format.html { redirect_to(@packing_list) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @packing_list.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /packing_lists/1
  # DELETE /packing_lists/1.xml
#  def destroy
#    @packing_list = PackingList.find(params[:id])
#    @packing_list.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(packing_lists_url) }
#      format.xml  { head :ok }
#    end
#  end
end
