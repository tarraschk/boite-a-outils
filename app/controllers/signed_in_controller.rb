class SignedInController < ApplicationController
  before_action :redirect_to_dashboard

  def redirect_to_dashboard
    redirect_to dashboard_path unless user_signed_in? || request.env['REQUEST_PATH'].in?(['/users/auth/google_oauth2/callback', dashboard_path])
  end

  def after_sign_in_path_for(resource)
    case resource
      when User
        dashboard_path
      else
        root_path
    end
  end

  before_action :get_self
  def get_self
    @nb_person = NationBuilderClient.new.call(:people, :show, id: current_person.people_id)['person']
    @nb_person['people_id']   = current_person.people_id
    @nb_person['original_id'] = current_person.id

    Person.skip_callbacks = true
    person = current_person
    person.email          = @nb_person['email']
    person.mobile         = @nb_person['mobile']
    person.phone          = @nb_person['phone']
    person.first_name     = @nb_person['first_name']
    person.last_name      = @nb_person['last_name']
    person.support_level  = @nb_person['support_level']
    person.tags           = @nb_person['tags']
    person.mandat         = @nb_person['mandat']

    person.save

    person.home_address ||= Address.new

    if home_address = @nb_person['primary_address'] || @nb_person['home_address']
      person.home_address.address1 = home_address['address1']
      person.home_address.address2 = home_address['address2']
      person.home_address.address3 = home_address['address3']
      person.home_address.city     = home_address['city']
      person.home_address.zip      = home_address['zip']
      person.home_address.save
    end

    Person.skip_callbacks = false
  end

  helper_method :current_person
  def current_person
    @current_person ||= current_user && current_user.person
  end
end