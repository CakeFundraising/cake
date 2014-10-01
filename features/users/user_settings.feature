Feature: User Settings
  
  In order to change my account information
  As a User
  I want to edit my account data
  
  Scenario Outline: Account Settings
    Given a confirmed user exists with email: "example@example.com", full_name: "Test User"
    And the user is logged in
    When he visits the account settings page
    And he fills in the "Full Name" field with <full_name>
    And he fills in the "Email Address" field with <email>
    And he fills in the "user_password" field with <password>
    And he fills in the "user_password_confirmation" field with <password_confirmation>
    And he fills in the "Enter Password To Confirm Changes" field with <current_password>
    And he press the "Update Account" button
    Then he should see "<message>"

  Examples: Successful update
  | full_name       | email                 | password          | password_confirmation   | current_password | message                                |
  | Emiliano Coppo  | emiliano@bytelion.com |                   |                         | password         | You updated your account successfully. |
  | Other User      | example@example.com   |                   |                         | password         | You updated your account successfully. |
  | Test User       | emiliano@bytelion.com |                   |                         | password         | You updated your account successfully. |
  | Test User       | example@example.com   | anonUser123       | anonUser123             | password         | You updated your account successfully. |
    
  Examples: Failed update
  | full_name       | email                 | password          | password_confirmation   | current_password | message                    |
  | Emiliano Coppo  | example@example.com   |                   |                         |                  | can't be blank             |
  | Test User       | emiliano@bytelion.com |                   |                         |                  | can't be blank             |
  | Test User       | example@example.com   | anonUser123       | anonUser                | password         | doesn't match Password     | 
  | Test User       | info@cakefundraising  |                   |                         | password         | Email Address*is invalid           | 