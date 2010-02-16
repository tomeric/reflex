require File.expand_path(File.join(File.dirname(__FILE__), '..') + '/spec_helper')
require 'fakeweb'

describe Reflex::OAuthServer do
  include ReflexSpecHelper

  before(:all) do
    Reflex.configure(:endpoint => "http://social.react.com/XmlRpc_v1/")
    FakeWeb.allow_net_connect = false
    FakeWeb.clean_registry
  end

  describe "get_providers" do
    before(:each) do
      FakeWeb.register_uri(:post, "http://social.react.com/XmlRpc_v1/", :response => fake_response("OAuthServer.getProviders"))      
    end
    
    it "should call OAuthServer.getProviders with credentials" do
      Reflex::OAuthServer.expects(:oauth_call).with("OAuthServer.getProviders")     
      Reflex::OAuthServer.get_providers
    end
    
    it "should return an array" do
      Reflex::OAuthServer.get_providers.should be_an_instance_of(Array)
    end
    
    it "should include 'Twitter'" do
      Reflex::OAuthServer.get_providers.should include('Twitter')
    end
  end
  
  describe "token_request" do
    before(:each) do
      FakeWeb.register_uri(:post, "http://social.react.com/XmlRpc_v1/", :response => fake_response("OAuthServer.tokenRequest"))      
    end
    
    it "should call OAuthServer.tokenRequest with credentials and provider" do
      Reflex::OAuthServer.expects(:oauth_call).with("OAuthServer.tokenRequest", 'Twitter')     
      Reflex::OAuthServer.token_request('Twitter')
    end
    
    it "should return a hash" do
      Reflex::OAuthServer.token_request('Twitter').should be_an_instance_of(Hash)
    end
    
    it "should include a redirectUrl" do
      result = Reflex::OAuthServer.token_request('Twitter')
      result['redirectUrl'].should =~ /twitter\.com\/oauth/
    end
    
    it "should include a reactOAuthSession" do
      result = Reflex::OAuthServer.token_request('Twitter')
      result['reactOAuthSession'].should == "FILTERED"
    end
  end
  
  describe "token_access" do
    before(:each) do
      FakeWeb.register_uri(:post, "http://social.react.com/XmlRpc_v1/", :response => fake_response("OAuthServer.tokenAccess"))      
    end
    
    it "should call OAuthServer.tokenAccess with credentials and parameters" do
      Reflex::OAuthServer.expects(:oauth_call).with("OAuthServer.tokenAccess", { "oauth_token" => "FILTERED", "oauth_verifier" => "FILTERED", "ReactOAuthSession" => "FILTERED" })     
      Reflex::OAuthServer.token_access({ "oauth_token" => "FILTERED", "oauth_verifier" => "FILTERED", "ReactOAuthSession" => "FILTERED" })
    end
    
    it "should do return a hash" do
      result = Reflex::OAuthServer.token_access({ "oauth_token" => "FILTERED", "oauth_verifier" => "FILTERED", "ReactOAuthSession" => "FILTERED" })
      result.should be_an_instance_of(Hash)
    end
    
    it "should include the connected provider" do
      result = Reflex::OAuthServer.token_access({ "oauth_token" => "FILTERED", "oauth_verifier" => "FILTERED", "ReactOAuthSession" => "FILTERED" })
      result['connectedWithProvider'].should == 'Twitter'
    end
    
    it "should include the application user ID" do
      result = Reflex::OAuthServer.token_access({ "oauth_token" => "FILTERED", "oauth_verifier" => "FILTERED", "ReactOAuthSession" => "FILTERED" })
      result['applicationUserId'].should == '1'      
    end
    
    it "should include the react OAuth Session" do
      result = Reflex::OAuthServer.token_access({ "oauth_token" => "FILTERED", "oauth_verifier" => "FILTERED", "ReactOAuthSession" => "FILTERED" })
      result['reactOAuthSession'].should == 'FILTERED'      
    end
  end
end