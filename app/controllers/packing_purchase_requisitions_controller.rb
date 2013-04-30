class PackingPurchaseRequisitionsController < ApplicationController
  before_filter :authenticated_admin_and_user
  before_filter :check_menu_accessible
  before_filter :set_locale
  # GET /packing_purchase_requisitions
  # GET /packing_purchase_requisitions.xml
  def index
    @packing_purchase_requisitions = PackingPurchaseRequisition.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @packing_purchase_requisitions }
    end
  end

  # GET /packing_purchase_requisitions/1
  # GET /packing_purchase_requisitions/1.xml
  def show
    @packing_purchase_requisition = PackingPurchaseRequisition.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @packing_purchase_requisition }
    end
  end

  # GET /packing_purchase_requisitions/new
  # GET /packing_purchase_requisitions/new.xml
  def new
    @packing_purchase_requisition = PackingPurchaseRequisition.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @packing_purchase_requisition }
    end
  end

  # GET /packing_purchase_requisitions/1/edit
  def edit
    @packing_purchase_requisition = PackingPurchaseRequisition.find(params[:id])
  end

  # POST /packing_purchase_requisitions
  # POST /packing_purchase_requisitions.xml
  def create
    @packing_purchase_requisition = PackingPurchaseRequisition.new(params[:packing_purchase_requisition])

    respond_to do |format|
      if @packing_purchase_requisition.save
        flash[:notice] = 'PackingPurchaseRequisition was successfully created.'
        format.html { redirect_to(@packing_purchase_requisition) }
        format.xml  { render :xml => @packing_purchase_requisition, :status => :created, :location => @packing_purchase_requisition }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @packing_purchase_requisition.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /packing_purchase_requisitions/1
  # PUT /packing_purchase_requisitions/1.xml
  def update
    @packing_purchase_requisition = PackingPurchaseRequisition.find(params[:id])

    respond_to do |format|
      if @packing_purchase_requisition.update_attributes(params[:packing_purchase_requisition])
        flash[:notice] = 'PackingPurchaseRequisition was successfully updated.'
        format.html { redirect_to(@packing_purchase_requisition) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @packing_purchase_requisition.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /packing_purchase_requisitions/1
  # DELETE /packing_purchase_requisitions/1.xml
  def destroy
    @packing_purchase_requisition = PackingPurchaseRequisition.find(params[:id])
    @packing_purchase_requisition.destroy

    respond_to do |format|
      format.html { redirect_to(packing_purchase_requisitions_url) }
      format.xml  { head :ok }
    end
  end
end
