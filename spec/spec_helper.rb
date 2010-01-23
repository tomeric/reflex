$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'reflex'
require 'spec'
require 'spec/autorun'
require 'mocha'
require 'fakeweb'
require 'mime/types'

Spec::Runner.configure do |config|
  config.mock_with :mocha
end

def FakeResponse(filename, options = {})
  File.join(File.dirname(__FILE__), "fakeweb", filename)
end