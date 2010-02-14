$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'reflex/base'
require 'reflex/configuration'
require 'reflex/oauth_server'
require 'reflex/system'

if defined?(Authlogic)
  require 'reflex/authlogic/session'
  require 'reflex/authlogic/acts_as_authentic'
end

$LOAD_PATH.shift