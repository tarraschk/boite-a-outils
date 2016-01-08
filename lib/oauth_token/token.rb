# app/models/token.rb

require 'net/http'
require 'json'

module Token

  def to_params
    {refresh_token: refresh_token,
     client_id:     Rails.application.secrets.google_app_id,
     client_secret: Rails.application.secrets.google_app_secret,
     grant_type:    'refresh_token'}
  end

  def request_token_from_google
    url = URI('https://accounts.google.com/o/oauth2/token')
    Net::HTTP.post_form(url, to_params)
  end

  def refresh!
    response = request_token_from_google
    data = JSON.parse(response.body)
    update_attributes(
        access_token: data['access_token'],
        expires_at: Time.now + (data['expires_in'].to_i).seconds
    )
  end

  def expired?
    expires_at < Time.now
  end

  def fresh_token
    refresh! if expired?
    access_token
  end

  def google_client
    return @client if @client
    @client = Google::APIClient.new
    @client.authorization.client_id     = Rails.application.secrets.google_app_id
    @client.authorization.client_secret = Rails.application.secrets.google_app_secret
    @client.authorization.access_token  = self.access_token
    @client.authorization.refresh_token = self.refresh_token
    @client
  end

  def gmail_api
    google_client.discovered_api('gmail', 'v1')
  end

end
