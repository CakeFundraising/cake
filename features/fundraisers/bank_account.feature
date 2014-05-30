Feature: Bank Account

  In order to receive payments for my invoices
  As a Fundraiser
  I want to add my bank accout information

  @javascript @real_http
  Scenario Outline: Create Bank Account
    Given a fundraiser exists
    And that fundraiser is logged in
    When he visits the fundraiser bank account page
    And he fills in the "Owner Name" field with <name>
    And he selects <type> in "Account Type"
    And he fills in the "Contact Email" field with <email>
    And he fills in the "Tax ID" field with <tax_id>
    And he fills in the "Routing Number" field with <routing>
    And he fills in the "Account Number" field with <account>
    And he press the "Save" button
    Then he should see "<message>"
    And a bank account token <should?> be stored in the fundraiser's stripe account

    Examples: Correct data
    | name        | type         | email               | tax_id     | routing   | account      | message                                              | should? |
    | Tony Bardon | Individual   | example@example.com | 000000000  | 110000000 | 000123456789 | You have connected your Stripe account successfully. | should  |
    | Coke        | Corporation  | example@coke.com    | 000000000  | 110000000 | 000123456789 | You have connected your Stripe account successfully. | should  |

    Examples: Incorrect data
    | name       | type         | email               | tax_id    | routing   | account      | message                                                                     | should?    |
    | Myself     | Individual   | example@example.com | 000000000 |           | 4978979      | Routing number must have 9 digits                                           | should not |
    | Myself     | Individual   | example@example.com | 000000000 | 011401533 |              | Must only use a test bank account number when making transfers in test mode | should not |
    |            | Individual   | example@example.com | 000000000 | 110000000 | 000123456789 | can't be blank                                                              | should not |
    | Myself     |              | example@example.com | 000000000 | 110000000 | 000123456789 | can't be blank                                                              | should not |
    | Myself     | Individual   |                     | 000000000 | 110000000 | 000123456789 | can't be blank                                                              | should not |