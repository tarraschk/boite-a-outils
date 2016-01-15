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
    @nb_person = NationBuilderClient.new.call(:people, :show, id: @person.people_id)
    @nb_person["person"]["people_id"] = @person.people_id
    @nb_person["person"]["original_id"] = @person.id
    render json: @nb_person["person"]
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
      params.require(:person).permit(:recruiter_id, :email, :phone_number, :first_name, :last_name)
    end
end
