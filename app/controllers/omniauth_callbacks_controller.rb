# encoding: utf-8

class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2

    email = request.env['omniauth.auth'].info['email']
    unless email && email.split('@')[1].in?(%w(alainjuppe2017.fr juppe-2017.fr))
      flash['danger'] = "Veuillez vous connecter à l’aide d'une adresse juppe-2017.fr ou alainjuppe2017.fr"
      redirect_to dashboard_path
      return
    end
    @user = User.find_for_google_oauth2(request.env["omniauth.auth"], current_user)

    if @user.nil?
      flash['danger'] = "Vous n'existez pas"
      redirect_to :back
    elsif @user.persisted?
      flash[:success] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
