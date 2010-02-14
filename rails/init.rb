$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))

require 'lib/reflex'

config_file = File.join(File.dirname(Rails.root), File.basename(Rails.root), 'config', 'reflex.yml')

if File.exists?(config_file)
  settings = YAML.load(File.open(config_file))
  configuration = settings[Rails.env].symbolize_keys

  Reflex.configure(configuration)
else
  Rails.logger.warn "** [Reflex] #{config_file} does not exist, skipping Reflex configuration"
end

if defined?(Authlogic)
  require "lib/reflex/authlogic/callback_filter"

  ActionController::Dispatcher.middleware.insert_before(ActionController::ParamsParser, Reflex::Authlogic::CallbackFilter) 
end

$LOAD_PATH.shift