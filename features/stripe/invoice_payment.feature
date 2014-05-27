Feature: Invoice Payment

  In order to pay my outstanding invoices
  As a Sponsor
  I want to use my credit card information to pay them

  Background: 
    Given a sponsor exists
    And a past pledge of that sponsor exists
    And an invoice for that pledge exists
    And that sponsor is logged in
    When he visits the sponsor billing page
    And he press the "Pay" link

  Scenario: Stripe Checkout Modal
    And he sees the Stripe Checkout popup
    And he fills in the popup "Email" field with "sponsor@example.com"
    And he fills in the popup "Card number" field with "4242424242424242" 
    And he fills in the popup "cc-exp" field with "08/15"
    And he fills in the popup "cc-csc" field with "123"
    And he press the "Pay $5.00" button within the popup
    Then he should see "Payment succeeded."
    And a payment for 5 dollars should be created