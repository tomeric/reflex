Feature: Social authentication
  In order to allow visitors to get access to certain features
  As a visitor who is connected to one of our social providers
  I want to login via one of these social providers
  
  Scenario: Logging in for the first time
    Given I am on the homepage
    And I follow "Login"

    Given a token request is expected
    When I press "Twitter"

    Given a token access is expected for an unregistered user
    And a session profile fetched is expected
    And a user id is set for the available token
    When I press "Allow"

    Then I should be logged in
    And I should see "Marshall Eriksen"
  
  Scenario: Logging in for the second time
    Given a "Twitter" user exists
    And I am on the homepage
    Then I should see "Marshall Eriksen"
    
    When I follow "Login"
    
    Given a token request is expected
    When I press "Twitter"
    
    Given a token access is expected for a registered user
    When I press "Allow"
    And I should be logged in
    And 1 user should exist
    
    When I follow "My Profile"
    Then I should see "Marshall Eriksen"