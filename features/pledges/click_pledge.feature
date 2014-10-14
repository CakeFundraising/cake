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
    And he press the click button
    Then he should see "Your click has already been counted, but please visit our sponsor again!" in the click contribution modal
    Then he should see "VISIT OUR SPONSOR AGAIN" in the click contribution modal
    And the sponsor website should be open in a new window
    And a click should be added to the Pledge

  @javascript
  Scenario: Failed Donation in Pledge Page
    And the user has already donated to that pledge
    When he visits the pledge's page
    Then he should see "THANKS FOR YOUR CONTRIBUTION!"
    And the "Contribute" link should not be present

  Scenario: Pledge fully subscribed
    And the pledge is fully subscribed
    When he visits the pledge's page
    Then he should see "Pledge fully subscribed"
    And the "Contribute" link should not be present