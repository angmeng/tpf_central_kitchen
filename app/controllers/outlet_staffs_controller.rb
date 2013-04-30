class OutletStaffsController < ApplicationController
  before_filter :authenticated_admin_and_user
  before_filter :check_menu_accessible
  before_filter :set_locale
  # GET /outlet_staffs
  # GET /outlet_staffs.xml
  def index
    @outlet_staffs = OutletStaff.all
  end

  # GET /outlet_staffs/1
  # GET /outlet_staffs/1.xml
  def show
    @outlet_staff = OutletStaff.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @outlet_staff }
    end
  end

  # GET /outlet_staffs/new
  # GET /outlet_staffs/new.xml
  def new
    @outlet_staff = OutletStaff.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @outlet_staff }
    end
  end

  # GET /outlet_staffs/1/edit
  def edit
    @outlet_staff = OutletStaff.find(params[:id])
  end

  # POST /outlet_staffs
  # POST /outlet_staffs.xml
  def create
    @outlet_staff = OutletStaff.new(params[:outlet_staff])

    respond_to do |format|
      if @outlet_staff.save
        flash[:notice] = 'OutletStaff was successfully created.'
        format.html { redirect_to(@outlet_staff) }
        format.xml  { render :xml => @outlet_staff, :status => :created, :location => @outlet_staff }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @outlet_staff.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /outlet_staffs/1
  # PUT /outlet_staffs/1.xml
  def update
    @outlet_staff = OutletStaff.find(params[:id])

    respond_to do |format|
      if @outlet_staff.update_attributes(params[:outlet_staff])
        flash[:notice] = 'OutletStaff was successfully updated.'
        format.html { redirect_to(@outlet_staff) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @outlet_staff.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def change_password
    @outlet_staff = OutletStaff.find(params[:id])
  end
  
  def update_password
    @outlet_staff = OutletStaff.find(params[:id])
    
    passed, msg = @outlet_staff.check_password(params[:outlet_staff])
    
    if passed
      flash[:notice] = msg
      redirect_to @outlet_staff
    else
      flash[:error] = msg
      render :action => "change_password"
      
    end
  end

  # DELETE /outlet_staffs/1
  # DELETE /outlet_staffs/1.xml
  def destroy
    @outlet_staff = OutletStaff.find(params[:id])
    @outlet_staff.destroy

    respond_to do |format|
      format.html { redirect_back_or_default(outlet_staffs_url) }
      format.xml  { head :ok }
    end
  end
end
