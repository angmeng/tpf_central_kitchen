class ProductsController < ApplicationController
  autocomplete :product, :name, :extra_data => [:code], :display_value => :funky_method
  before_filter :authenticated_admin, :except => [:autocomplete_product_name]
  before_filter :check_menu_accessible, :except => [:autocomplete_product_name]
  before_filter :set_locale
  
  def index
    @search = Product.includes(:product_category, :product_group).search(params[:search])
    @products = @search.paginate(:page => params[:page], :per_page => 50)
  end
  
  def show
    @product = Product.find(params[:id])
    @product.revert_to(params[:version].to_i) if params[:version]
    @options = Outlet.for_options
    @first, @last, @next, @previous = Product.next_previous_label(@product.id)
  end
  
  def new
    @product = Product.new
  end
  
  def create
    @product = Product.new(params[:product])
    if @product.save
      flash[:notice] = (t "flashes.successfully_created")
      redirect_to @product
    else
      render :action => 'new'
    end
  end
  
  def edit
    @product = Product.find(params[:id])
  end
  
  def update
    @product = Product.find(params[:id])
    
    respond_to do |format|
      format.html {
        if @product.update_attributes(params[:product])
          flash[:notice] = (t "flashes.successfully_updated")
          redirect_to @product
        else
          render :action => 'edit'
        end
      }
      format.js  { 
        @product.update_attributes(params[:product])
        render :update do |page|
         page.replace_html 'uom_assignment', :partial => 'uom_assignment', :locals => {:product => @product}
         page.show "note"
         page.visual_effect :highlight, "note"
         page.visual_effect :fade, "note", :duration => 3
        end
      }
    end
    
  end
  
  def destroy
    
    @product = Product.find(params[:id])
    checked, msg = @product.verify_for_destroy
    if checked
      flash[:notice] = msg
    else
      flash[:error] = msg
    end
    
    redirect_back_or_default(products_url)
  end
  
  def add_supplier
    product = Product.find(params[:id])
    product.add_outlet_supplier(params[:option])
    # render :update do |page|
    #   page.replace_html 'for_suppliers', :partial => 'product_suppliers', :locals => {:product => product}
    #   page.show "note"
    #   page.visual_effect :highlight, "note"
    #   page.visual_effect :fade, "note", :duration => 3
      
    # end
    redirect_to :back
  end
  
  def remove_supplier
    if request.post?
      product = Product.find(params[:id])
      params[:list] ||= []
      params[:list].each do |item_id, content|
        product.outlet_product_suppliers.find(item_id).destroy if content[:selected].to_i == 1
      end
      redirect_to product
    else
      item = OutletProductSupplier.find(params[:id])
      product = item.product
      item.destroy
      # render :update do |page|
      #   page.replace_html 'for_suppliers', :partial => 'product_suppliers', :locals => {:product => product}
      #   page.show "note"
      #   page.visual_effect :highlight, "note"
      #   page.visual_effect :fade, "note", :duration => 3
      # end
      redirect_to :back
    end
    
  end
  
  def add_uom
    product = Product.find(params[:id])
    product.add_uom(params[:option])
    # render :update do |page|
    #   page.replace_html 'uom_listing', :partial => 'uom_listing', :locals => {:product => product}
    #   page.replace_html 'uom_assignment', :partial => 'uom_assignment', :locals => {:product => product}
    #   page.show "note"
    #   page.visual_effect :highlight, "note"
    #   page.visual_effect :fade, "note", :duration => 3
      
    # end
    redirect_to :back
  end
  
  def remove_uom
    p = ProductUom.find(params[:id])
    product = p.product
    p.destroy
    # render :update do |page|
    #   page.replace_html 'uom_listing', :partial => 'uom_listing', :locals => {:product => product}
    #   page.replace_html 'uom_assignment', :partial => 'uom_assignment', :locals => {:product => product}
    #   page.show "note"
    #   page.visual_effect :highlight, "note"
    #   page.visual_effect :fade, "note", :duration => 3
    # end
    redirect_to :back
  end
  
  def add_location
    product = Product.find(params[:id])
    product.add_location(params[:option])
    # render :update do |page|
    #   page.replace_html 'store', :partial => 'locations', :locals => {:product => product}
    #   page.show "note"
    #   page.visual_effect :highlight, "note"
    #   page.visual_effect :fade, "note", :duration => 3
      
    # end
    redirect_to :back
  end
  
  def remove_location
    product = Product.find(params[:id])
    product.remove_location
    flash[:notice] = "Operation Completed"
    redirect_to(product)
  end
  
  def update_uom
    product = Product.find(params[:id])
    params[:uom] ||= []
    
    params[:uom].each {|uom_id, content|
     uom = ProductUom.find(uom_id)
     uom.update_attributes(content)  
    }
    # render :update do |page|
    #    page.replace_html 'uom_listing', :partial => 'uom_listing', :locals => {:product => product}
    #    page.replace_html 'uom_assignment', :partial => 'uom_assignment', :locals => {:product => product}
    #    page.show "note"
    #    page.visual_effect :highlight, "note"
    #    page.visual_effect :fade, "note", :duration => 3
    # end
    redirect_to :back
  end
  
end
