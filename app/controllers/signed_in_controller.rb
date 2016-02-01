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

  helper_method :current_person
  def current_person
    @current_person ||= current_user && current_user.person
  end
end