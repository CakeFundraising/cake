Feature: Campaign Wizard Steps
  
  In order to create a Campaign
  As a Fundraiser 
  I have to complete the campaign creation wizard

  Scenario: Tell your Story Step
    Given a fundraiser exists
    And that fundraiser is logged in
    When he goes to new campaign's page
    Then he should fill out the "Tell your story" form
    And he should be taken to the "Pledge Levels" step