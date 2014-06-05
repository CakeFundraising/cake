Feature: Campaign Launch

  In order to start recieving clicks from consumers
  As a Fundraiser
  I want to launch my Campaign

  Background:
    Given a fundraiser exists
    And a inactive campaign of that fundraiser exists
    And that fundraiser is logged in

  Scenario: Launch campaign from Active Campaigns page
    When he visits the fundraiser campaigns page
    And he press the "Launch Campaign" link
    Then he should see "Campaign is live now!"
    And he should be taken to the campaign's page
    And the inactive campaign should have a "live" status