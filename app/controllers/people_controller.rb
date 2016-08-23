class PeopleController < SignedInController
  before_action :set_person, only: [:show, :edit, :update]

  before_action :authorize_person_controller!

  def authorize_person_controller!
    if @person
      return true if current_user.root
      unless ((current_person.people_id == @person.parent_id) || (current_person.id == @person.id))
        render status: 401 and return
      end
    end
    true
  end

  def index
    if current_person.is_departemental_comitees_manager? && current_person.departement_comitees_manager
      @children = Person.animators_for_department(current_person.departement_comitees_manager)
      @children |= current_person.children.activated.order("(contacted is null or contacted = false) DESC, last_name ASC")
    else
      @children = current_person.children.activated.order("(contacted is null or contacted = false) DESC, last_name ASC")
    end
    #@children = Array.new
    #current_person.children.each do |child|
    #  nb_person = NationBuilderClient.new.call(:people, :show, id: child.people_id)
    #  @children << nb_person["person"]
    #end
    render json: @children, :include => :home_address, :methods => [ :children, :children_count ]
  end

  # GET /people/1
  # GET /people/1.json
  def show
    #@nb_person = NationBuilderClient.new.call(:people, :show, id: @person.people_id)['person']
    #@nb_person['people_id']   = @person.people_id
    #@nb_person['original_id'] = @person.id

    #Person.skip_callbacks = true
    # person = Person.find_or_initialize_by(people_id: @nb_person['people_id'])
    # person.email          = @nb_person['email']
    # person.mobile         = @nb_person['mobile']
    # person.phone          = @nb_person['phone']
    # person.first_name     = @nb_person['first_name']
    # person.last_name      = @nb_person['last_name']
    # person.support_level  = @nb_person['support_level']
    # person.tags           = @nb_person['tags']
    # person.mandat         = @nb_person['mandat']
    #
    # person.save
    #
    # person.home_address ||= Address.new
    #
    # if home_address = @nb_person['primary_address'] || @nb_person['home_address']
    #   person.home_address.address1 = home_address['address1']
    #   person.home_address.address2 = home_address['address2']
    #   person.home_address.address3 = home_address['address3']
    #   person.home_address.city     = home_address['city']
    #   person.home_address.zip      = home_address['zip']
    #   person.home_address.save
    # end
    #
    # Person.skip_callbacks = false
    person = Person.find_by_id(@person.id)
    render json: person.attributes.merge(home_address: person.home_address)
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit
    @nb_person = NationBuilderClient.new.call(:people, :show, id: @person.people_id)
  end

  # POST /people
  # POST /people.json
  def create
    @person = Person.new(person_params)
    @person.parent_id = current_person.people_id
    @person.tags = (JSON.parse(current_person.tags) & ["comite_membre", "comite_jeune", "comite_comite"]) | ["comite_boiteaoutils"]
    if current_person.people_id == 2013
      @person.send_to_nation_builder(true)
    end
    if @person.save_without_callbacks
      render json: @person, :include => :home_address
    else
      render json: @person.errors
    end
  rescue => e
    render status: 500, json: {nb_error: "Attention, la synchronisation avec NationBuilder a échoué, merci de réessayer."}
  end

  # PATCH/PUT /people/1
  # PATCH/PUT /people/1.json
  def update
    respond_to do |format|
      if @person.update_without_callbacks(person_params)
        format.html { redirect_to @person, notice: 'Person was successfully updated.' }
        format.json { render :show, status: :ok, location: @person }
      else
        format.html { render :edit }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @person = current_person.children.activated.find_by(id: params[:id])
    if @person
      @person.desactivate
      flash[:success] = "Personne supprimée avec succès."
      render json: @person
    else
      flash[:danger] = "Erreur dans la suppression demandée. Veuillez contacter le support."
      render json: {result: 'Not Found'}, status: '404'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find_by(id: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def person_params
      permit_list = [:recruiter_id, :email, :phone, :mobile, :first_name, :last_name, :contacted, :mandat, :support_level, :tags, :home_address_attributes => [:id, :address1, :address2, :address3, :zip, :city]]
      params.require(:person).merge(contacted: true).permit(*permit_list)
    end
end
