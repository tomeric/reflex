# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.load_paths += Dir.glob(File.join(Rails.root, '..', '..', '..', '..'))
  config.gem 'authlogic'
  config.gem 'cucumber'
  config.gem 'test-unit',        :version => '= 1.2.3', :lib => false
  config.gem 'cucumber-rails',   :lib => false
  config.gem 'database_cleaner', :lib => false
  config.gem 'capybara',         :lib => false
  config.gem 'rspec',            :lib => false
  config.gem 'rspec-rails',      :lib => false
  config.time_zone = 'UTC'
  config.cache_classes = true
  config.whiny_nils = true
  config.action_controller.consider_all_requests_local = true
  config.action_controller.perform_caching             = false
  config.action_controller.allow_forgery_protection    = false
  config.action_mailer.delivery_method = :test
end

require 'reflex/rails/init'