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
