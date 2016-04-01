class AdminToolsController < ApplicationController
  before_action :check_admin?

  def check_admin?
    render status: 401 and return if Rails.env.production? && !current_user.root
    true
  end

  def dashboard
    render
  end

  def people_databable
    respond_to do |format|
      format.html
      format.json { render json: PersonDatatable.new(view_context) }
    end
  end

  def send_to_nation_builder
    params.require(:person_id)

    @person = Person.find(params[:person_id])
    @person.send_to_nation_builder(true)
    render status: :ok, json: {success: !!@person.people_id, error: @person.nation_builder_error}
  end

  def send_all_to_nation_builder
    NationBuilderSendAllNewPeopleWorker.perform_async
    render status: :ok
  end

end