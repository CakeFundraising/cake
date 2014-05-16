Feature: Direct Donation
  
  In order to contribute to a campaign
  As a Consumer User
  I want to do a direct donation to that campaign

  Background:
    Given a consumer user
    And a fundraiser exists
    And a campaign of that fundraiser exists
    When he visits the campaign's page

  @javascript
  Scenario: Correct Donation in Campaign Page
    And he fills in the "direct_donation_amount" field with 5
    And he press the "Make a Direct Donation" button
    And he sees the Stripe Checkout popup
    And he fills in the popup "Email" field with "email@example.com"
    And he fills in the popup "Card number" field with "4242424242424242" 
    And he fills in the popup "cc-exp" field with "08/15"
    And he fills in the popup "cc-csc" field with "123"
    And he press the "Pay $5.00" button within the popup
    Then he should see "Thanks for contributing!"
    And the campaign should have a new direct donation of 5 dollars
    And a charge of 5 dollars should be done to the credit card