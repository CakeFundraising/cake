Feature: Pledge Creation Process
  
  After a FR has created his campaign, any Sponsor should be able to create a pledge to support that campaign

  Scenario: Via Campaign invitation mail to registered potential Sponsors.
    Given a campaign exists
    And a sponsor exists
    And that sponsor is logged in
    When the sponsor clicks on the invitation link to campaign
    Then the sponsor should see the pledge wizard

  Scenario: Via Campaign invitation mail to registered potential Sponsors.
    Given a campaign exists
    And the user is not registered as sponsor
    When the sponsor clicks on the invitation link to campaign
    Then he should be redirected to the new registration page as sponsor
    And he registers into the site
    And he logs in
    And he is taken to the new pledge page
    And the sponsor should see the pledge wizard

  