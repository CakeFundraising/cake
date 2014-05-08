Feature: Accept or Reject Pledge Request

  In order to get clicks from Consumer users
  As a Sponsor
  I want to accept or reject fundraisers's pledges

  Background:
    Given a sponsor exists
    And a pledge request of that sponsor exists
    And that sponsor is logged in
    When the sponsor visits the sponsor pledge requests page

  Scenario: Accept Pledge
    And he press the "Accept" link
    Then he should be taken to the new pledge page
    And the page has the correct campaign selected for that pledge request

  Scenario: Reject Pledge
    And he press the "Reject" link
    Then he should be taken to the sponsor pledge requests page
    And he should see "Pledge request rejected."
    And 1 email should be delivered with subject: "Your Pledge Request has been rejected."
    And the pledge request should have a "rejected" status
    And a rejected flag should be present in the fundraiser pending pledges page