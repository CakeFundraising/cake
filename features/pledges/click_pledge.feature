Feature: Click Donation to Pledge
  
  In order to contribute to a Campaign
  As a Consumer User
  I want to donate my click in a Pledge

  Background:
    Given a pledge exists
    And a unique user visits Cake

  @javascript @truncateDB
  Scenario: Successful Donation in Pledge Page
    When he visits the pledge's page
    And he press the "Click to help. It's free" button
    And he sees the click contribution modal
    And he press the "Contribute" link
    Then he should see "Thanks for helping!" in the click contribution modal
    And the sponsor website should be open in a new window
    And a click should be added to the Pledge

  Scenario: Failed Donation in Pledge Page
    And the user has already donated to that pledge
    When he visits the pledge's page
    Then he should see "Thanks for your contribution"
    And the "Contribute" link should not be present