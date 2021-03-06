$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems' unless RUBY_VERSION >= "1.9"
require 'authlogic'
require 'reflex'
require 'spec'
require 'spec/autorun'
require 'mocha'
require 'fakeweb'
require 'mime/types'

TEST_DATABASE_FILE = File.join(File.dirname(__FILE__), '..', 'test.sqlite3')
File.unlink(TEST_DATABASE_FILE) if File.exist?(TEST_DATABASE_FILE)
ActiveRecord::Base.establish_connection("adapter" => "sqlite3", "database" => TEST_DATABASE_FILE)
ActiveRecord::Base.silence do
  ActiveRecord::Migration.verbose = false
  load File.join(File.dirname(__FILE__), 'schema.rb')
end

class Authorizable < ActiveRecord::Base
end

Spec::Runner.configure do |config|
  config.mock_with :mocha
end

module ReflexSpecHelper
  def self.included(base)
    config_file = File.join(File.dirname(__FILE__), 'reflex.yml')    
    
    if File.exists?(config_file)
      settings = YAML.load(File.open(config_file))
      configuration = settings.inject({}) do |options, (key, value)|
                        options[(key.to_sym rescue key) || key] = value
                        options
                      end

      Reflex.configure(configuration)
    else
      puts "** [Reflex] #{config_file} does not exist, skipping Reflex configuration"
    end

    ::XMLRPC::Client.class_eval do
      def call2(method, *args)
        puts "XMLRPC Request: #{method}(#{args.map(&:inspect).join(", ")})" if defined?($debug_response) && $debug_response
        request = create().methodCall(method, *args)
        data = do_rpc(request, false)
        puts "XMLRPC Response:\n#{data}\n" if defined?($debug_response) && $debug_response
        parser().parseMethodResponse(data)
      end     
    end
  end
  
  def debug_response(&block)
    FakeWeb.allow_net_connect = true
    $debug_response = true
    yield
    $debug_response = false
    FakeWeb.allow_net_connect = false
  end
  
  def fake_response(filename, options = {})
    File.join(File.dirname(__FILE__), "fakeweb", filename)
  end
end