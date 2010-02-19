Given /^a "([^\"]*)" user exists$/ do |provider|
  User.create!(:name => 'Marshall Eriksen', :creating_for_react => true)
end

Given /^([0-9]+) users? should exist$/ do |count|
  User.count.should eql(count.to_i)
end

Given /^a token request is expected$/ do
  @provider = 'Twitter'

  Reflex::OAuthServer.expects(:token_request).with(@provider).returns({ 
    'redirectUrl'       => 'https://twitter.com/fake_controller/oauth/authorize',
    'reactOAuthSession' => 'FAKE_OAUTH_TOKEN'
  })
end

Given /^a token access is expected for an unregistered user$/ do
  Reflex::OAuthServer.expects(:token_access).returns({ 
    'connectedWithProvider' => @provider,
    'reactOAuthSession'     => 'FAKE_REACT_OAUTH_SESSION'
  })
end

Given /^a token access is expected for a registered user$/ do
  Reflex::OAuthServer.expects(:token_access).returns({ 
    'connectedWithProvider' => @provider,
    'reactOAuthSession'     => 'FAKE_REACT_OAUTH_SESSION',
    'applicationUserId'     => User.last.id
  })
end

Given /^a session profile fetched is expected$/ do
  Reflex::OAuthServer.expects(:session_get_profile).with('FAKE_OAUTH_TOKEN').returns({
    'real_name'       => 'Marshall Eriksen',
    'user_name'       => 'marshall',
    'profile_picture' => 'http://awesome.com/marshall.jpg'
  })  
end

Given /^a user id is set for the available token$/ do
  Reflex::OAuthServer.expects(:token_set_user_id).returns({
    'applicationUserId'     => 1,
    'connectedWithProvider' => @provider,
  })
end

Given /^a registered user exists with login: "([^\"]*)", password: "([^\"]*)"$/ do |login, password|
  User.create!(:login => login, :name => login, :password => password, :password_confirmation => password)
end

Given /^I am logged in as "([^\"]*)" with password "([^\"]*)"$/ do |login, password|
  When "I am on the login page"
  And "I fill in \"Login\" with \"#{login}\""
  And "I fill in \"Password\" with \"#{password}\""
  And "I press \"Login\""
end

Then /^I should be logged out$/ do
  Then "I should not see \"My Profile\""
  And "I should see \"Login\""
end

Then /^I should be logged in$/ do
  Then "I should see \"My Profile\""
  And "I should see \"Logout\""
end
