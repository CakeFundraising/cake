Feature: Credit Card
  
  In order to reuse my credit card information
  As a Sponsor
  I want to store my credit card information

  @javascript @real_http
  Scenario Outline: Create Credit Card
    Given a sponsor exists
    And a stripe account for that sponsor exists
    And that sponsor is logged in
    When he visits the sponsor credit card page
    And he fills in the "Number" field with <number>
    And he fills in the "CVC" field with <cvc>
    And he selects <exp_month> in "Expiration Month"
    And he selects <exp_year> in "Expiration Year"
    And he press the "Save" button
    Then he should see "<message>"
    And a credit card token <should?> be stored in the sponsor's stripe account

    Examples: Correct Data 
    | number            | cvc | exp_month | exp_year | message                                      | should? |
    | 4242424242424242  | 123 | 8         | 2018     | Your credit card information has been saved. | should  |
    | 5555555555554444  | 897 | 1         | 2020     | Your credit card information has been saved. | should  |

    Examples: Incorrect Data
    | number            | cvc | exp_month | exp_year | message                        | should?     |
    |                   | 123 | 8         | 2018     | This field is required.        | should not  |
    | 4678977797998879  | 123 | 8         | 2018     | Your card number is incorrect. | should not  |
    | 5555555555554444  |     | 8         | 2018     | This field is required.        | should not  | 
    | 4242424242424242  | 897 | 1         |          | This field is required.        | should not  | 
