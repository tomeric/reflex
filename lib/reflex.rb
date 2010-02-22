$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'reflex/base'
require 'reflex/configuration'
require 'reflex/oauth_server'
require 'reflex/system'

if defined?(Authlogic)
  require 'uuidtools'
  require 'reflex/authlogic/acts_as_authentic'
  require 'reflex/authlogic/session'
end

$LOAD_PATH.shift