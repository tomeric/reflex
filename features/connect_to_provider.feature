Feature: Connect to provider
  In order to use the new social login features
  As an existing user
  I want to connect my profile to a social provider
  
  Scenario: Connect to a provider
    Given a registered user exists with login: "marshall", password: "awesome"
    And I am logged in as "marshall" with password "awesome"
    And I am on my profile
    And I follow "Edit my profile"   
    
    Given a token access is expected for an unregistered user
    And a user id is set for the available token    
    When I press "Twitter"
    # And I press "Allow"
    
    When I go to my profile
    Then I should see "Twitter"