class Mailer

  def send_error(e)
    email = { :from_email   => 'petitrobotajx@gmail.com',
              :from_name    => "Robot AJx",
              :subject      => "[BOA] Erreur détectée",
              :text_part    => e,
              :recipients   => [{:email => "maxime.alayeddine@juppe-2017.fr"}] }
    Mailjet::Send.create(email)
  end
  
end