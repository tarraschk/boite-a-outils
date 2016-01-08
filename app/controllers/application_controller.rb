class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :redirect_to_mail

  def redirect_to_mail
    redirect_to user_omniauth_authorize_path(:google_oauth2) unless user_signed_in? || request.env['REQUEST_PATH'] == '/users/auth/google_oauth2/callback'
  end

  def after_sign_in_path_for(resource)
    case resource
      when User
        mails_user_path(resource)
      else
        root_path
    end
  end

end
