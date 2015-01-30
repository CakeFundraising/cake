Feature: Accept and Reject Pledges

  In order to get pledges from Sponsors
  As a Fundraiser
  I want to accept or reject pledge offers

  Background:
    Given a fundraiser exists
    And a campaign of that fundraiser exists
    And a pending pledge of that campaign exists
    And that fundraiser is logged in
    When he visits the fundraiser pending pledges page

  @javascript
  Scenario: Accept Pledge
    And he press the "Accept" link
    Then he should see "Pledge accepted"
    And he should be taken to the campaign's page
    And 1 email should be delivered with subject: "Your Pledge has been accepted."
    And the pending pledge should have a "accepted" status
    And the pledge should be one of campaign's active pledges
    And the pledge should not be present in the fundraiser pending pledges page

  Scenario: Reject Pledge
    And he press the "Reject" link
    And he fills in the "Message" field with "Please we need more money from your pledge"
    And he press the "Send" button
    Then he should see "Pledge rejected."
    And he should be taken to the fundraiser pending pledges page
    And 1 email should be delivered with subject: "Your Pledge has been rejected."
    And the email should contain "Please we need more money from your pledge"
    And the pending pledge should have a "rejected" status
    And the pledge should not be present in the fundraiser pending pledges page
    And a rejected flag should be present in the sponsor pledge requests page