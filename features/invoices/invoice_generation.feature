Feature: Invoice Generation
  
  In order to enable Sponsors to pay their invoices
  As the System
  I have to generate the invoices for a campaign

  Scenario: Background Job  
    Given a campaign exists
    And a pledge of that campaign exists
    When the campaign ends
    Then an invoice should be generated for that pledge
    And 2 email should be delivered with subject: "You have outstanding invoices."