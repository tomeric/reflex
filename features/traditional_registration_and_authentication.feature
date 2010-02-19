Feature: Traditional registration
  In order to allow visitors without an account on one of our providers to create a profile
  As a visitor
  I want to register and login
  
  Scenario: Registration
    Given I am on the homepage
    And I follow "Register"
    
    When I fill in "Login" with "barney"
    And I fill in "Name" with "Barney Stinson" 
    And I fill in "Password" with "awesome"
    And I fill in "user_password_confirmation" with "awesome"
    And I press "Save"
    
    Then I should be on the users page
    And I should see "Barney Stinson"
  
  Scenario: Authentication
    Given a registered user exists with login: "barney", password: "awesome"
    And I am on the homepage
    
    When I follow "Login"
    And I fill in "Login" with "barney"
    And I fill in "Password" with "awesome"
    And I press "Login"
    
    Then I should be on the user page for "barney"
    And I should be logged in
  