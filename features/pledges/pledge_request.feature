Feature: Pledge Requests
  
  In order to have sponsors for my campaign
  As a Fundraiser
  I want to create Pledge Requests to compatible Sponsors

  Background:
    Given a fundraiser exists
    Given a sponsor exists
    And a campaign of that fundraiser exists
    And that fundraiser is logged in

  Scenario: FR request a pledge to Sponsor
    When the fundraiser visits the sponsor's page
    And he press the "Request Pledge" link
    Then he should be taken to the new pledge request page