class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  include Token

  devise :database_authenticatable, :registerable,
         :recoverable, :validatable, :omniauthable

  has_many :user_to_person_relations
  has_one  :person, through: :user_to_person_relations

  def self.find_for_google_oauth2(access_token, _signed_in_resource = nil)
    data = access_token.info
    user = User.find_by(provider: access_token.provider, uid: access_token.uid )
    if user
      user.update(
          access_token: access_token['credentials']['token'],
          refresh_token: access_token['credentials']['refresh_token'],
          expires_at: Time.at(access_token['credentials']['expires_at'])
      )
      return user
    else
      registered_user = User.find_by(:email => access_token.info.email)
      if registered_user
        return registered_user
      else
        begin
          nb_people = NationBuilderClient.new.call(:people, :match, email: data['email'])
        rescue => e
          Rails.logger.error e
          nb_people = {}
        end
        person = Person.find_by(people_id: nb_people['person'] && nb_people['person']['id'])
        if person
          new_user = person.users.create(
              name:           data['name'],
              #provider:       access_token.provider,
              email:          data['email'],
              #uid:            access_token.uid ,
              password:       'helloworld',
              access_token:   access_token['credentials']['token'],
              refresh_token:  access_token['credentials']['refresh_token'],
              expires_at:     access_token['credentials']['expired_at']
          )
          return new_user
        end
      end
    end
  end


  def get_emails
    results = google_client.execute!(
        api_method: gmail_api.users.threads.list,
        parameters: {
            userId: 'me',
            maxResults: 15
        }
    )

    emails = Set.new
    results.data.threads.each do |thread|
      results_thread = google_client.execute!(
          api_method: gmail_api.users.threads.get,
          parameters: {
              userId:           'me',
              id:               thread.id,
              format:           'metadata',
              metadataHeaders:   %w(To Cc Cci From),
              fields:           'messages/payload'
          })
      results_thread.data.messages.each do |message|
        message.payload.headers.each do |header|
          header.value.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i) { |x| emails.add(x) }
        end
      end
    end
    emails
  end
end
