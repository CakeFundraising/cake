Feature: Direct Donation
  
  In order to contribute to a campaign
  As a Consumer User
  I want to do a direct donation to that campaign

  @javascript
  Scenario: Donate in Campaign Page
    Given a consumer user
    And a fundraiser exists
    And a campaign of that fundraiser exists
    When he visits the campaign's page
    And he fills in the "direct_donation_amount" field with 5
    And he press the "Make a Direct Donation" button
    And he fills in the "Email" field with consumer@example.com
    And he fills in the "Credit number" field with 4242424242424242
    And he fills in the "cc-exp" field with 05/17
    And he fills in the "cvcInput" field with 123
    And he press the "Pay $5.00" button
    Then he should see "Thanks for contributing!"