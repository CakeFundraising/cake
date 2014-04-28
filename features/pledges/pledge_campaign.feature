Feature: Pledge Campaign
  
  In order to receive clicks from users
  As a Sponsor
  I want to pledge a campaign

  Background:
    Given a fundraiser exists
    And a campaign of that fundraiser exists

  # FR solicits potential sponsors by sending a campaign link.
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

  # Sponsor sees the Campaign by browsing or searching on Cake for a Campaign to support.
  # We should add the same scenarios when the Sponsor is actually using the search pages
  Scenario: Unsolicited Pledge, existing Sponsor
    And a sponsor exists
    And that sponsor is logged in
    When he visits the campaign's page
    And he press the "Make a Pledge" link
    Then he is taken to the new pledge page
    And the page has the correct campaign selected

  Scenario: Unsolicited Pledge, unregistered User
    And the user is not registered as sponsor
    When he visits the campaign's page
    And he press the "Make a Pledge" link
    Then he should be redirected to the new registration page as sponsor
    And the user registers as a sponsor
    And he logs in
    Then he is taken to the new pledge page
    And the page has the correct campaign selected

  Scenario: Unsolicited Pledge, existing FR user
    And a fundraiser exists
    And that fundraiser is logged in
    When he visits the campaign's page
    And he press the "Make a Pledge" link
    Then he should be redirected to the new registration page as sponsor
    And the user registers as a sponsor
    And he logs in
    Then he is taken to the new pledge page
    And the page has the correct campaign selected

  # Pledges solicited from FR to Sponsor using Cake not the campaign link. (Pledge Request)
  # Check out the features/pledges/pledge_request.feature to see the scenarios.