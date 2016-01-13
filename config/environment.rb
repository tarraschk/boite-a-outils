# Load the Rails application.
require File.expand_path('../application', __FILE__)


begin
  File.open("#{Rails.root}/config/secrets.yml",'rb') do |f|
    'LOAD secret'
    content = f.read
    cfg     = YAML.load(content)
    escfg   = cfg[Rails.env] || Hash.new

    escfg.each{ |k,v|
      ENV[k.upcase] = v.to_s
    }
  end
rescue Exception
  puts 'No config/environment_secret.yml file'
end

Rails.application.secrets.secret_token    = ENV['SECRET_TOKEN']
Rails.application.secrets.secret_key_base = ENV['SECRET_KEY_BASE']

# Initialize the Rails application.
Rails.application.initialize!
