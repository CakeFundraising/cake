Feature: Pledge Campaign
  
  In order to receive clicks from users
  As a Sponsor
  I want to pledge a campaign

  Background:
    Given a fundraiser exists
    And a campaign of that fundraiser exists

  Scenario: Pledge Invitation link, existing Sponsor
    And a sponsor exists
    And that sponsor is logged in
    When he visits the pledge invitation page
    Then he is taken to the new pledge page

  Scenario: Pledge Invitation link, unregistered User
    And the user is not registered as sponsor
    When he visits the pledge invitation page
    Then he should be redirected to the new registration page as sponsor
    And the user registers as a sponsor
    And he logs in
    Then he is taken to the new pledge page
    And the page has the correct campaign selected

  Scenario: Pledge Invitation link, existing FR user
    And a fundraiser exists
    And that fundraiser is logged in
    When he visits the pledge invitation page
    And he should be redirected to the new registration page as sponsor
    And the user registers as a sponsor
    And he logs in
    Then he is taken to the new pledge page
    And the page has the correct campaign selected