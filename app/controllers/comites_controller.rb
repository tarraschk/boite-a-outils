class ComitesController < SignedInController
  before_action :set_comite, only: [:show, :edit, :update, :destroy]
  before_action :get_parent
  before_action :check_admin?

  def check_admin?
    render status: 401 and return if Rails.env.production? && !current_user.root
    true
  end
  
  def get_parent
    if user_signed_in?
      @children = current_person.children.activated
      @parent   = current_person.parent
    end
  end

  # GET /comites
  # GET /comites.json
  def index
    @comites = Comite.all.sort_by(&:updated_at).reverse!
  end

  # GET /comites/1
  # GET /comites/1.json
  def show
  end

  # GET /comites/new
  def new
    @comite = Comite.new
  end

  # GET /comites/1/edit
  def edit
  end

  # POST /comites
  # POST /comites.json
  def create
    @comite = Comite.new(comite_params)

    respond_to do |format|
      if @comite.save
        format.html { redirect_to @comite, notice: 'Comite was successfully created.' }
        format.json { render :show, status: :created, location: @comite }
      else
        format.html { render :new }
        format.json { render json: @comite.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comites/1
  # PATCH/PUT /comites/1.json
  def update
    respond_to do |format|
      if @comite.update(comite_params)
        format.html { redirect_to @comite, notice: 'Comite was successfully updated.' }
        format.json { render :show, status: :ok, location: @comite }
      else
        format.html { render :edit }
        format.json { render json: @comite.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comites/1
  # DELETE /comites/1.json
  def destroy
    @comite.destroy
    respond_to do |format|
      format.html { redirect_to comites_url, notice: 'Comite was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comite
      @comite = Comite.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comite_params
      params.require(:comite).permit(:number, :typecomite, :slug, :title, :desc1, :desc2, :coordinates, :active)
    end
end
