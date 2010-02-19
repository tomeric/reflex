Given /^a registered user exists with login: "([^\"]*)", password: "([^\"]*)"$/ do |login, password|
  User.create!(:login => login, :name => login, :password => password, :password_confirmation => password)
end

Then /^I should be logged in$/ do
  Then "I should see \"My Profile\""
  And "I should see \"Logout\""
end
