if not Rails.env.production?
  ENV['FRONT_END'] = 'http://localhost:8080'
end

# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!
