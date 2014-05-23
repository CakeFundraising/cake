Feature: Fundraiser Dashboard
  
  In order to use the CakeFundraising platform
  As a Fundraiser
  I should be able to manage the entities involved

  Background:
    Given a fundraiser exists
    And 5 campaigns of that fundraiser exist
    And 3 past campaigns of that fundraiser exist
    And 2 unsolicited pledges of his campaigns exist
    And 3 requested pledges of his campaigns exist
    And that fundraiser is logged in

  Scenario: Home
    When he visits the fundraiser home page
    Then he should see his fundraiser home dashboard

  Scenario: Active Campaigns
    When he visits the fundraiser campaigns page
    Then he should see his active campaigns

  Scenario: Pending Pledges
    When he visits the fundraiser pending pledges page
    Then he should see his unsolicited pledges
    Then he should see his requested pledges

  Scenario: History
    When he visits the fundraiser history page
    Then he should see his past campaigns
    Then he should see his sponsors

  Scenario: Billing
    And 5 pending invoices from that fundraiser exist
    And 5 past invoices from that fundraiser exist
    When he visits the fundraiser billing page
    Then he should see his outstanding invoices
    Then he should see his past invoices
