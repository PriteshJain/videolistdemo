class EntriesController < ApplicationController
  before_action :set_entry, only: [:show, :update, :destroy]

  # GET /entries
  def index
    @page = params[:page]
    @entries = Entry.order(created_at: :desc).page(@page).per(2)
    render 'index.json'
  end

  # GET /entries/1
  def show
    render 'show.json'
  end

  # POST /entries
  def create
    @entry = Entry.new(entry_params)
    @entry.user = current_user
    if @entry.save
      render 'show.json'
    else
      render json: @entry.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /entries/1
  def update
    if @entry.update(entry_params)
      render json: @entry
    else
      render json: @entry.errors, status: :unprocessable_entity
    end
  end

  # DELETE /entries/1
  def destroy
    @entry.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entry
      @entry = Entry.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def entry_params
      params.require(:entry).permit(:description, :video, :title, :tags)
    end

end
