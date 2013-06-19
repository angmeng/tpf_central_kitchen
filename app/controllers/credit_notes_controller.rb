class CreditNotesController < ApplicationController
  # GET /credit_notes
  # GET /credit_notes.json
  def index
    @search = CreditNote.joins(:outlet).order("credit_date DESC, outlets.name").search(params[:search])
    @credit_notes = @search.paginate(:page => params[:page], :per_page => 50)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @credit_notes }
    end
  end

  # GET /credit_notes/1
  # GET /credit_notes/1.json
  def show
    @credit_note = CreditNote.find(params[:id])
    @current_items = @credit_note.credit_note_items

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @credit_note }
    end
  end

  # GET /credit_notes/new
  # GET /credit_notes/new.json
  def new
    @credit_note = CreditNote.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @credit_note }
    end
  end

  # GET /credit_notes/1/edit
  def edit
    @credit_note = CreditNote.find(params[:id])
  end

  # POST /credit_notes
  # POST /credit_notes.json
  def create
    @credit_note = CreditNote.new(params[:credit_note])
    @credit_note.credit_note_number = Setting.generate_credit_note_number

    respond_to do |format|
      if @credit_note.save
        Setting.increment_of_credit_note
        format.html { redirect_to @credit_note, notice: 'Credit note was successfully created.' }
        format.json { render json: @credit_note, status: :created, location: @credit_note }
      else
        format.html { render action: "new" }
        format.json { render json: @credit_note.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_items
    credit_note = CreditNote.find(params[:id])
    params[:item] ||= []
    credit_note.update_item_status(params[:item])
    flash[:notice] = "Update completed"
    redirect_to(credit_note)
  end

  def add_item
    if is_admin?
      credit_note = CreditNote.find(params[:id])
      credit_note.add_order_items(params[:credit_note_item])
      flash[:notice] = "Operation Completed"
      redirect_to(credit_note)
    else
      flash[:error] = "You cannot access this area"
      redirect_to(:action => 'index')
    end
  
  end
  
  def remove_item
    if is_admin?
      credit_note_item = CreditNoteItem.find(params[:id])
      credit_note      = credit_note_item.credit_note
      credit_note_item.destroy
      flash[:notice] = (t "flashes.successfully_removed")
      redirect_to(credit_note)
    else
      flash[:error] = "You cannot access this area"
      redirect_to(:action => 'index')
    end
  end

  # PUT /credit_notes/1
  # PUT /credit_notes/1.json
  def update
    @credit_note = CreditNote.find(params[:id])

    respond_to do |format|
      if @credit_note.update_attributes(params[:credit_note])
        format.html { redirect_to @credit_note, notice: 'Credit note was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @credit_note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /credit_notes/1
  # DELETE /credit_notes/1.json
  def destroy
    @credit_note = CreditNote.find(params[:id])
    @credit_note.destroy

    respond_to do |format|
      format.html { redirect_to credit_notes_url }
      format.json { head :no_content }
    end
  end
end
