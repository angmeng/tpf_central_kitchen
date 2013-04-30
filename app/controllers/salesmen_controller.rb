class SalesmenController < ApplicationController
  before_filter :authenticated_admin_and_user
  before_filter :check_menu_accessible
  before_filter :set_locale
  # GET /salesmen
  # GET /salesmen.xml
  def index
    @salesmen = Salesman.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @salesmen }
    end
  end

  # GET /salesmen/1
  # GET /salesmen/1.xml
  def show
    @salesman = Salesman.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @salesman }
    end
  end

  # GET /salesmen/new
  # GET /salesmen/new.xml
  def new
    @salesman = Salesman.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @salesman }
    end
  end

  # GET /salesmen/1/edit
  def edit
    @salesman = Salesman.find(params[:id])
  end

  # POST /salesmen
  # POST /salesmen.xml
  def create
    @salesman = Salesman.new(params[:salesman])

    respond_to do |format|
      if @salesman.save
        flash[:notice] = 'Salesman was successfully created.'
        format.html { redirect_to(@salesman) }
        format.xml  { render :xml => @salesman, :status => :created, :location => @salesman }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @salesman.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit_commission
    @salesman = Salesman.find(params[:id])
    @commissions = @salesman.commissions
  end
  
  def submit_commission
    salesman = Salesman.find(params[:id])
    
    params[:commission] ||= []
    
    params[:commission].each {|p_id, content|
    comm = salesman.commissions.find(p_id.to_i) rescue nil
    comm.percentage = content[:percentage].to_f rescue comm.percentage = 0.00 
    comm.save!
     
    }
    flash[:notice] = "Update completed"
    redirect_to(edit_commission_salesman_path(salesman))
  end

  # PUT /salesmen/1
  # PUT /salesmen/1.xml
  def update
    @salesman = Salesman.find(params[:id])

    respond_to do |format|
      if @salesman.update_attributes(params[:salesman])
        flash[:notice] = 'Salesman was successfully updated.'
        format.html { redirect_to(@salesman) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @salesman.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /salesmen/1
  # DELETE /salesmen/1.xml
  def destroy
    @salesman = Salesman.find(params[:id])
    check, msg = @salesman.verify_destroy

    if check
      flash[:notice] = msg
    else
      flash[:error] = msg
    end
    
    respond_to do |format|
      format.html { redirect_back_or_default(salesmen_url) }
      format.xml  { head :ok }
    end
  end
end
