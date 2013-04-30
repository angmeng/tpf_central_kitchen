class OutletGoodsReceiveNotesController < ApplicationController
  before_filter :authenticated_admin_and_user
  before_filter :check_menu_accessible
  before_filter :set_locale
  # GET /outlet_goods_receive_notes
  # GET /outlet_goods_receive_notes.xml
  def index
    @outlet_goods_receive_notes = OutletGoodsReceiveNote.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @outlet_goods_receive_notes }
    end
  end

  # GET /outlet_goods_receive_notes/1
  # GET /outlet_goods_receive_notes/1.xml
  def show
    @outlet_goods_receive_note = OutletGoodsReceiveNote.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @outlet_goods_receive_note }
    end
  end

  # GET /outlet_goods_receive_notes/new
  # GET /outlet_goods_receive_notes/new.xml
  def new
    @outlet_goods_receive_note = OutletGoodsReceiveNote.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @outlet_goods_receive_note }
    end
  end

  # GET /outlet_goods_receive_notes/1/edit
  def edit
    @outlet_goods_receive_note = OutletGoodsReceiveNote.find(params[:id])
  end

  # POST /outlet_goods_receive_notes
  # POST /outlet_goods_receive_notes.xml
  def create
    @outlet_goods_receive_note = OutletGoodsReceiveNote.new(params[:outlet_goods_receive_note])

    respond_to do |format|
      if @outlet_goods_receive_note.save
        flash[:notice] = 'OutletGoodsReceiveNote was successfully created.'
        format.html { redirect_to(@outlet_goods_receive_note) }
        format.xml  { render :xml => @outlet_goods_receive_note, :status => :created, :location => @outlet_goods_receive_note }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @outlet_goods_receive_note.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /outlet_goods_receive_notes/1
  # PUT /outlet_goods_receive_notes/1.xml
  def update
    @outlet_goods_receive_note = OutletGoodsReceiveNote.find(params[:id])

    respond_to do |format|
      if @outlet_goods_receive_note.update_attributes(params[:outlet_goods_receive_note])
        flash[:notice] = 'OutletGoodsReceiveNote was successfully updated.'
        format.html { redirect_to(@outlet_goods_receive_note) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @outlet_goods_receive_note.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /outlet_goods_receive_notes/1
  # DELETE /outlet_goods_receive_notes/1.xml
  def destroy
    @outlet_goods_receive_note = OutletGoodsReceiveNote.find(params[:id])
    @outlet_goods_receive_note.destroy

    respond_to do |format|
      format.html { redirect_to(outlet_goods_receive_notes_url) }
      format.xml  { head :ok }
    end
  end
end
