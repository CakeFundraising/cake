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
    And he press the "Click Here!" link
    Then he should see "Your click has already been counted, but please visit our sponsor again!" in the click contribution modal
    Then he should see "VISIT OUR SPONSOR AGAIN" in the click contribution modal
    And the sponsor website should be open in a new window
    And a click should be added to the Pledge

  Scenario: Failed Donation in Pledge Page
    And the user has already donated to that pledge
    When he visits the pledge's page
    Then he should see "Thanks for your contribution"
    And the "Contribute" link should not be present

  Scenario: Pledge fully subscribed
    And the pledge is fully subscribed
    When he visits the pledge's page
    Then he should see "This pledge cannot accept more clicks. Thanks for your contribution!"
    And the "Contribute" link should not be present