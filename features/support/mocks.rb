class MockController < ActionController::Base
  def oauth_authorize
    render_fake('oauth_authorize.html.erb')
  end
  
  private
  
  def render_fake(template)
    render :template => File.join(File.dirname(__FILE__), 'mock_controller', template)    
  end
end

ActionController::Routing::Routes.draw do |map|
  map.with_options :controller => 'mock' do |fake|
    fake.oauth_authorize 'fake_controller/oauth/authorize', :action => 'oauth_authorize'
  end
end

Before do
  Reflex::OAuthServer.stubs(:get_providers).returns(['Twitter', 'Facebook'])
end