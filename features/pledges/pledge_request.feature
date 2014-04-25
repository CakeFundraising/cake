Feature: Pledge Requests
  
  In order to have sponsors for my campaign
  As a Fundraiser
  I want to create Pledge Requests to compatible Sponsors

  Background:
    Given a fundraiser exists
    And a sponsor exists
    And a campaign of that fundraiser exists
    And that fundraiser is logged in

  Scenario: FR request a pledge to Sponsor
    When the fundraiser visits the sponsor's page
    And he press the "Request Pledge" link
    Then he should be taken to the new pledge request page

  Scenario: Sucessful Pledge Request Creation
    And the fundraiser visits the sponsor's page
    And he press the "Request Pledge" link
    When he selects his campaign in the dropdown
    And he press the "Request Pledge" button
    Then he should see "Pledge request was successfully created."

  Scenario: Failed Pledge Request Creation #Missing Campaign
    And the fundraiser visits the sponsor's page
    And he press the "Request Pledge" link
    And he press the "Request Pledge" button
    Then he should see "can't be blank"

  Scenario: Sponsor receives pledge request from Fundraiser
    And a pledge request from the fundraiser to the sponsor exists
    And that sponsor is logged in
    When the sponsor visits the sponsor pledge requests page
    Then he should see the pledge request listed