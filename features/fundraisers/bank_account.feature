Feature: Bank Account

  In order to receive payments for my invoices
  As a Fundraiser
  I want to add my bank account information

  @javascript @real_http
  Scenario Outline: Create Bank Account
    Given a fundraiser exists
    And that fundraiser is logged in
    And he confirms the alert dialog
    When he visits the fundraiser bank account page
#    Then show me the page
    And he reenters his password
    And he press the "Submit Password" button
    And he fills in the "bank_account_name" field with <name>
    And he selects <type> in "Account Type"
    And he fills in the "Contact Email" field with <email>
    And he fills in the "Tax ID" field with <tax_id>
    And he fills in the "Routing Number" field with <routing>
    And he fills in the "Account Number" field with <account>
    And he press the "Save & Continue" button
    Then he should see "<message>"
    And a bank account token <should?> be stored in the fundraiser's stripe account

    Examples: Correct data
    | name        | type         | email               | tax_id     | routing   | account      | message                                       | should? |
    | Tony Bardon | Individual   | example@example.com | 000000000  | 110000000 | 000123456789 | Your bank account information has been saved. | should  |
    | Coke Cola   | Corporation  | example@coke.com    | 000000000  | 110000000 | 000123456789 | Your bank account information has been saved. | should  |

    Examples: Incorrect data
    | name       | type         | email               | tax_id    | routing   | account      | message                 | should?    |
    | My Name    | Individual   | example@example.com | 000000000 |           | 4978979      | This field is required. | should not |
    | My Name    | Individual   | example@example.com | 000000000 | 011401533 |              | This field is required. | should not |
    |            | Individual   | example@example.com | 000000000 | 110000000 | 000123456789 | This field is required. | should not |
    | My Name    |              | example@example.com | 000000000 | 110000000 | 000123456789 | This field is required. | should not |
    | My Name    | Individual   |                     | 000000000 | 110000000 | 000123456789 | This field is required. | should not |