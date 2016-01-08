class GadgetFilesController < ApplicationController
  before_action :set_gadget_file, only: [:show, :edit, :update, :destroy]

  # GET /gadget_files
  # GET /gadget_files.json
  def index
    @gadget_files = GadgetFile.all
  end

  # GET /gadget_files/1
  # GET /gadget_files/1.json
  def show
    respond_to do |format|
      format.html
      format.xml { render xml: @gadget_file.html }
    end
  end

  # GET /gadget_files/new
  def new
    @gadget_file = GadgetFile.new
  end

  # GET /gadget_files/1/edit
  def edit
  end

  # POST /gadget_files
  # POST /gadget_files.json
  def create
    @gadget_file = GadgetFile.new(gadget_file_params)

    respond_to do |format|
      if @gadget_file.save
        format.html { redirect_to @gadget_file, notice: 'Gadget file was successfully created.' }
        format.json { render :show, status: :created, location: @gadget_file }
      else
        format.html { render :new }
        format.json { render json: @gadget_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gadget_files/1
  # PATCH/PUT /gadget_files/1.json
  def update
    respond_to do |format|
      if @gadget_file.update(gadget_file_params)
        format.html { redirect_to @gadget_file, notice: 'Gadget file was successfully updated.' }
        format.json { render :show, status: :ok, location: @gadget_file }
      else
        format.html { render :edit }
        format.json { render json: @gadget_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gadget_files/1
  # DELETE /gadget_files/1.json
  def destroy
    @gadget_file.destroy
    respond_to do |format|
      format.html { redirect_to gadget_files_url, notice: 'Gadget file was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gadget_file
      @gadget_file    = GadgetFile.find_by(id:  params[:id])
      @gadget_file  ||= GadgetFile.find_by(url: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gadget_file_params
      params.require(:gadget_file).permit(:url, :html)
    end
end
