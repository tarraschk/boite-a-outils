class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # before_action do
  #   if current_user && current_user.root?
  #     Rack::MiniProfiler.authorize_request
  #   end
  # end

  helper_method :tools_controller?
  def tools_controller?
    false
  end


  private
  def render_error(status, exception)
    Rollbar.critical(status, exception)
    render template: "errors/error_#{status}", status: status
  end
end