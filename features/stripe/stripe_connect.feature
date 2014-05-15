Feature: Stripe Connect

  In order to receive/pay invoices for my Cake's activity
  As a User
  I want to integrate my Stripe account to my Cake account

  Scenario: Fundraiser Connect
    Given a fundraiser exists
    And that fundraiser is logged in
    When he visits the fundraiser home page
    And he press the "Connect with Stripe" link
    Then he should see "You have connected your Stripe account successfully."
    And he should see some information about his Stripe account