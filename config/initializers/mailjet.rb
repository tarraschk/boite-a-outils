# initializers/mailjet.rb
Mailjet.configure do |config|
  config.api_key = ENV['EMAIL_USERNAME']
  config.secret_key = ENV['EMAIL_PASSWORD']
  config.default_from = 'petitrobotajx@gmail.com'
end