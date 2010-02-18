require File.expand_path(File.join(File.dirname(__FILE__), '..') + '/spec_helper')
require 'fakeweb'

describe Reflex::OAuthServer do
  include ReflexSpecHelper

  before(:all) do
    Reflex.configure(:endpoint => 'http://social.react.com/XmlRpc_v2/')
    FakeWeb.allow_net_connect = false
    FakeWeb.clean_registry
  end

  describe 'get_providers' do    
    it 'should call OAuthServer.getProviders securely' do
      Reflex::OAuthServer.expects(:call!).with('OAuthServer.getProviders')     
      Reflex::OAuthServer.get_providers
    end
    
    describe 'response' do
      before(:each) do
        FakeWeb.register_uri(:post, 'http://social.react.com/XmlRpc_v2/', :response => fake_response('OAuthServer.getProviders'))
        @response = Reflex::OAuthServer.get_providers
      end
      
      it 'should be an array' do
        @response.should be_an_instance_of(Array)
      end
    
      it 'should include "Twitter"' do
        @response.should include('Twitter')
      end
    end
  end
  
  describe 'token_request' do
    before(:each) do
          end
    
    it 'should call OAuthServer.tokenRequest securely' do
      Reflex::OAuthServer.expects(:call!).with('OAuthServer.tokenRequest', 'Twitter')     
      Reflex::OAuthServer.token_request('Twitter')
    end
    
    describe 'response' do
      before(:each) do
        FakeWeb.register_uri(:post, 'http://social.react.com/XmlRpc_v2/', :response => fake_response('OAuthServer.tokenRequest'))      
        @response = Reflex::OAuthServer.token_request('Twitter')
      end
    
      it 'should be a hash' do
        @response.should be_an_instance_of(Hash)
      end
    
      it 'should include a redirectUrl' do
        @response['redirectUrl'].should =~ /twitter\.com\/oauth/
      end
    
      it 'should include a reactOAuthSession' do
        @response['reactOAuthSession'].should == 'FILTERED'
      end
    end
  end
  
  describe 'token_access' do    
    it 'should call OAuthServer.tokenAccess securely' do
      Reflex::OAuthServer.expects(:call!).with('OAuthServer.tokenAccess', { 'oauth_token' => 'FILTERED', 'oauth_verifier' => 'FILTERED', 'ReactOAuthSession' => 'FILTERED' })     
      Reflex::OAuthServer.token_access({ 'oauth_token' => 'FILTERED', 'oauth_verifier' => 'FILTERED', 'ReactOAuthSession' => 'FILTERED' })
    end
    
    describe 'response' do
      before(:each) do
        FakeWeb.register_uri(:post, 'http://social.react.com/XmlRpc_v2/', :response => fake_response('OAuthServer.tokenAccess'))      
        @response = Reflex::OAuthServer.token_access({ 'oauth_token' => 'FILTERED', 'oauth_verifier' => 'FILTERED', 'ReactOAuthSession' => 'FILTERED' })
      end
    
      it 'should be a hash' do
        @response.should be_an_instance_of(Hash)
      end
    
      it 'should include the connected provider' do
        @response['connectedWithProvider'].should == 'Twitter'
      end
    
      it 'should include the application user ID' do
        @response['applicationUserId'].should == '1'      
      end
    
      it 'should include the react OAuth Session' do
        @response['reactOAuthSession'].should == 'FILTERED'      
      end
    end
  end
  
  describe 'token_set_user_id' do
    it 'should call OAuthServer.tokenSetUserId securely' do
      Reflex::OAuthServer.expects(:call!).with('OAuthServer.tokenSetUserId', 1, 'FILTERED')
      Reflex::OAuthServer.token_set_user_id(1, 'FILTERED')
    end
    
    describe 'response' do
      before(:each) do
        FakeWeb.register_uri(:post, 'http://social.react.com/XmlRpc_v2/', :response => fake_response('OAuthServer.tokenSetUserId'))      
        @response = Reflex::OAuthServer.token_set_user_id(1, 'FILTERED')
      end      
    
      it 'should be a hash' do
        @response.should be_an_instance_of(Hash)
      end
    
      it 'should include the application user ID' do
        @response['applicationUserId'].should == '1'
      end

      it 'should include the connected provider' do
        @response['connectedWithProvider'].should == 'Twitter'
      end
    end
  end
  
  describe 'user_get_providers' do
    it 'should call OAuthServer.user_get_providers securely' do
      Reflex::OAuthServer.expects(:call!).with('OAuthServer.userGetProviders', 1)
      Reflex::OAuthServer.user_get_providers(1)      
    end
    
    describe 'response' do
      before(:each) do
        FakeWeb.register_uri(:post, 'http://social.react.com/XmlRpc_v2/', :response => fake_response('OAuthServer.userGetProviders'))      
        @response = Reflex::OAuthServer.user_get_providers(1)
      end
      
      it 'should be a hash' do
        @response.should be_an_instance_of(Hash)
      end
      
      it 'should include the connected providers' do
        @response['connectedWithProviders'].should == ['Facebook', 'Twitter']
      end
    end
  end
  
  describe 'user_remove_provider' do
    it 'should call OAuthServer.user_remove_provider securely' do
      Reflex::OAuthServer.expects(:call!).with('OAuthServer.userRemoveProvider', 1, 'Twitter')
      Reflex::OAuthServer.user_remove_provider(1, 'Twitter')
    end
    
    describe 'response' do
      before(:each) do
        FakeWeb.register_uri(:post, 'http://social.react.com/XmlRpc_v2/', :response => fake_response('OAuthServer.userRemoveProvider'))      
        @response = Reflex::OAuthServer.user_remove_provider(1, 'Twitter')
      end
      
      it 'should be true' do
        @response.should be_true
      end
    end
  end
  
  describe 'user_get_profile' do
    it 'should call OAuthServer.userGetProfile securely' do
      Reflex::OAuthServer.expects(:call!).with('OAuthServer.userGetProfile', 1, 'Twitter')
      Reflex::OAuthServer.user_get_profile(1, 'Twitter')
    end
    
    describe 'response' do
      before(:each) do
        FakeWeb.register_uri(:post, 'http://social.react.com/XmlRpc_v2/', :response => fake_response('OAuthServer.userGetProfile'))      
        @response = Reflex::OAuthServer.user_get_profile(1, 'Twitter')
      end
      
      it 'should be a hash' do
        @response.should be_an_instance_of(Hash)
      end
      
      it 'should include the real name' do
        @response['real_name'].should == 'Barney Stinson'
      end
      
      it 'should include the user name' do
        @response['user_name'].should == 'barney'
      end
      
      it 'should include a profile picture' do
        @response['profile_picture'].should == 'http://awesome.com/barney.jpg'
      end
    end
  end
  
  describe 'session_get_profile' do
    it 'should call OAuthServer.sessionGetProfile securely' do
      Reflex::OAuthServer.expects(:call!).with('OAuthServer.sessionGetProfile', 'FILTERED')
      Reflex::OAuthServer.session_get_profile('FILTERED')
    end
    
    describe 'response' do
      before(:each) do
        FakeWeb.register_uri(:post, 'http://social.react.com/XmlRpc_v2/', :response => fake_response('OAuthServer.sessionGetProfile'))      
        @response = Reflex::OAuthServer.session_get_profile('FILTERED')
      end
      
      it 'should be a hash' do
        @response.should be_an_instance_of(Hash)
      end
      
      it 'should include the real name' do
        @response['real_name'].should == 'Barney Stinson'
      end
      
      it 'should include the user name' do
        @response['user_name'].should == 'barney'
      end
      
      it 'should include a profile picture' do
        @response['profile_picture'].should == 'http://awesome.com/barney.jpg'
      end
    end
  end
end