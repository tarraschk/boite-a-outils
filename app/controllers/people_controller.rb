class PeopleController < ApplicationController
  before_action :set_person, only: [:show, :edit, :update]

  before_action :authorize_person_controller!

  def authorize_person_controller!
    if @person
      unless current_person.people_id.in?([@person.parent_id, @person.people_id])
        render status: 401 and return
      end
    end
    true
  end

  def index
    @children = current_person.children
    #@children = Array.new
    #current_person.children.each do |child|
    #  nb_person = NationBuilderClient.new.call(:people, :show, id: child.people_id)
    #  @children << nb_person["person"]
    #end
    render json: @children
  end

  # GET /people/1
  # GET /people/1.json
  def show
    @nb_person = NationBuilderClient.new.call(:people, :show, id: @person.people_id)['person']
    @nb_person['people_id']   = @person.people_id
    @nb_person['original_id'] = @person.id

    Person.skip_callbacks = true
    person = Person.find_or_initialize_by(people_id: @nb_person['people_id'])
    person.email          = @nb_person['primary_email']
    person.mobile         = @nb_person['mobile']
    person.first_name     = @nb_person['first_name']
    person.last_name      = @nb_person['last_name']
    person.support_level  = @nb_person['support_level']
    person.tags           = @nb_person['tags']
    person.mandat         = @nb_person['tags']

    person.save

    person.primary_address ||= Address.new
    person.primary_address.address1
    person.primary_address.city
    person.primary_address.zip
    person.primary_address.save



    Person.skip_callbacks = false

    render json: @nb_person['person']
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

    respond_to do |format|
      if @person.save
        format.html { redirect_to @person, notice: 'Person was successfully created.' }
        format.json { render :show, status: :created, location: @person }
      else
        format.html { render :new }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1
  # PATCH/PUT /people/1.json
  def update
    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to @person, notice: 'Person was successfully updated.' }
        format.json { render :show, status: :ok, location: @person }
      else
        format.html { render :edit }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find_by(people_id: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def person_params
      if @person
        params.require(:person).permit(:recruiter_id, :email, :mobile, :first_name, :last_name, :contacted) # it's an update, no update parent_id
      else
        params.require(:person).permit(:recruiter_id, :email, :mobile, :first_name, :last_name, :contacted, :parent_id)
      end
    end
end
