Feature: Sponsor Dashboard
  
  In order to use the CakeFundraising platform
  As a Sponsor
  I should be able to manage the entities involved

  Background:
    Given a sponsor exists
    And that sponsor is logged in

  Scenario: Home
    When he visits the sponsor home page
    Then he should see his sponsor home dashboard

  Scenario: Active Pledges
    And 3 pledges of that sponsor exist
    When he visits the sponsor active pledges page
    Then he should see his active pledges

  Scenario: Pledge Requests
    And 3 pledge requests of that sponsor exist
    And 3 pledges of that sponsor exist
    And 3 pending pledges of that sponsor exist
    When he visits the sponsor pledge requests page
    Then he should see his pending pledge requests

  Scenario: History
    And 3 past pledges of that sponsor exist
    When he visits the sponsor history page
    Then he should see his past pledges
    Then he should see his fundraisers

  Scenario: Billing
    And 5 pending invoices from that sponsor exist
    And 5 past invoices from that sponsor exist
    When he visits the sponsor billing page
    Then he should see his outstanding invoices
    Then he should see his past invoices