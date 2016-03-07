class Mailer

  def send_error(e)
    Mail.defaults do
      delivery_method :smtp, { :address              => "smtp.gmail.com",
                               :port                 => 587,
                               :user_name            => ENV['email_username'],
                               :password             => ENV['email_password'],
                               :authentication       => 'plain',
                               :enable_starttls_auto => true  }
    end
    Mail.deliver do
      to "maxime.alayeddine@juppe-2017.fr"
      from ENV['email_username']
      subject "[BOA] Erreur détectée"
      html_part do
        content_type 'text/html; charset=UTF-8'
        body e
      end
    end
  end

end