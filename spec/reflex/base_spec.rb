require File.expand_path(File.join(File.dirname(__FILE__), '..') + '/spec_helper')

describe Reflex::Base do
  include ReflexSpecHelper

  before(:each) do
    @configuration = Reflex.configure(:endpoint => 'http://social.react.com/XmlRpc_v2/', :secret => 'secret', :key => 'key')
  end

  describe "call" do
    it "should delegate to a XMLRPC client" do
      mock_client = mock()
      XMLRPC::Client.expects(:new).with('social.react.com', '/XmlRpc_v2/', 80).returns(mock_client)
      mock_client.expects(:call).with('System.methodDescription', 'System.listMethods')
      
      Reflex::Base.call('System.methodDescription', 'System.listMethods')
    end
  end
  
  describe "call!" do
    it "should add authentication parameters and delete to a XMLRPC client" do
      mock_client = mock()
      XMLRPC::Client.expects(:new).with('social.react.com', '/XmlRpc_v2/', 80).returns(mock_client)
      mock_client.expects(:call).with('OAuthServer.getProviders', 'key', 'secret')
      
      Reflex::Base.call!('OAuthServer.getProviders')      
    end
  end
end