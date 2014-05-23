Feature: Stripe Connect

  In order to receive/pay invoices for my Cake's activity
  As a User
  I want to integrate my Stripe account to my Cake account

  @javascript @real_http
  Scenario Outline: Fundraiser Connect
    Given a fundraiser without stripe account exists
    And that fundraiser is logged in
    When he visits the fundraiser home page
    And he press the "Connect with Stripe" link
    And he fills in the "Owner Name" field with <name>
    And he selects <type> in "Account Type"
    And he fills in the "Contact Email" field with <email>
    And he fills in the "Routing Number" field with <routing>
    And he fills in the "Account Number" field with <account>
    And he press the "Save" button
    And he waits some seconds
    Then he should see "<message>"
    And he should see some information about his Stripe account
    And a stripe account should be created for that fundraiser

    Examples: Correct data
    | name        | type         | email               | routing   | account      | message                                              |
    | Tony Bardon | Individual   | example@example.com | 110000000 | 000123456789 | You have connected your Stripe account successfully. |
    | Coke        | Corporation  | example@coke.com    | 110000000 | 000123456789 | You have connected your Stripe account successfully. |

    Examples: Incorrect data
    | name       | type         | email               | routing   | account      | message                                              |
    | Myself     | Individual   | example@example.com |           | 4978979      | You have connected your Stripe account successfully. |
    | Myself     | Individual   | example@example.com | 011401533 |              | You have connected your Stripe account successfully. |
    | Myself     | Individual   | example@example.com | 111111111 | 4564688      | You have connected your Stripe account successfully. |
    |            | Individual   | example@example.com | 110000000 | 000123456789 | You have connected your Stripe account successfully. |
    | Myself     |              | example@example.com | 110000000 | 000123456789 | You have connected your Stripe account successfully. |
    | Myself     | Individual   |                     | 110000000 | 000123456789 | You have connected your Stripe account successfully. |
    | Myself     | Individual   | example@example     | 110000000 | 000123456789 | You have connected your Stripe account successfully. |