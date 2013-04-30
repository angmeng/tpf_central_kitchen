class OutletGoodsReceiveNoteItemsController < ApplicationController
  before_filter :authenticated_admin_and_user
  before_filter :check_menu_accessible
  before_filter :set_locale
  # GET /outlet_goods_receive_note_items
  # GET /outlet_goods_receive_note_items.xml
  def index
    @outlet_goods_receive_note_items = OutletGoodsReceiveNoteItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @outlet_goods_receive_note_items }
    end
  end

  # GET /outlet_goods_receive_note_items/1
  # GET /outlet_goods_receive_note_items/1.xml
  def show
    @outlet_goods_receive_note_item = OutletGoodsReceiveNoteItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @outlet_goods_receive_note_item }
    end
  end

  # GET /outlet_goods_receive_note_items/new
  # GET /outlet_goods_receive_note_items/new.xml
  def new
    @outlet_goods_receive_note_item = OutletGoodsReceiveNoteItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @outlet_goods_receive_note_item }
    end
  end

  # GET /outlet_goods_receive_note_items/1/edit
  def edit
    @outlet_goods_receive_note_item = OutletGoodsReceiveNoteItem.find(params[:id])
  end

  # POST /outlet_goods_receive_note_items
  # POST /outlet_goods_receive_note_items.xml
  def create
    @outlet_goods_receive_note_item = OutletGoodsReceiveNoteItem.new(params[:outlet_goods_receive_note_item])

    respond_to do |format|
      if @outlet_goods_receive_note_item.save
        flash[:notice] = 'OutletGoodsReceiveNoteItem was successfully created.'
        format.html { redirect_to(@outlet_goods_receive_note_item) }
        format.xml  { render :xml => @outlet_goods_receive_note_item, :status => :created, :location => @outlet_goods_receive_note_item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @outlet_goods_receive_note_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /outlet_goods_receive_note_items/1
  # PUT /outlet_goods_receive_note_items/1.xml
  def update
    @outlet_goods_receive_note_item = OutletGoodsReceiveNoteItem.find(params[:id])

    respond_to do |format|
      if @outlet_goods_receive_note_item.update_attributes(params[:outlet_goods_receive_note_item])
        flash[:notice] = 'OutletGoodsReceiveNoteItem was successfully updated.'
        format.html { redirect_to(@outlet_goods_receive_note_item) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @outlet_goods_receive_note_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /outlet_goods_receive_note_items/1
  # DELETE /outlet_goods_receive_note_items/1.xml
  def destroy
    @outlet_goods_receive_note_item = OutletGoodsReceiveNoteItem.find(params[:id])
    @outlet_goods_receive_note_item.destroy

    respond_to do |format|
      format.html { redirect_to(outlet_goods_receive_note_items_url) }
      format.xml  { head :ok }
    end
  end
end
