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
