Feature: Stripe Connect

  In order to receive/pay invoices for my Cake's activity
  As a User
  I want to integrate my Stripe account to my Cake account

  Scenario: Fundraiser Connect
    Given a fundraiser without stripe account exists
    And that fundraiser is logged in
    When he visits the fundraiser home page
    And he press the "Connect with Stripe" link
    Then he should see "Please add your bank account information"
    And a stripe account should be created for that fundraiser