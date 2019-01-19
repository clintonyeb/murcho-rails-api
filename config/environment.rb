if Rails.env.development?
  ENV['FRONT_END'] = 'http://localhost:8080'
end

if Rails.env.production?
  ENV['FRONT_END'] = 'https://murcho.com'
end

# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!
