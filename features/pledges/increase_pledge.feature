Feature: Increase Pledge

  In order to continue collaborating with a campaign
  As a Sponsor
  I want to increase my pledge

  Scenario Outline: Increase pledge form
    Given a sponsor exists
    And a pledge of that sponsor exists with total_amount_cents: "9900"
    And that sponsor is logged in
    When he visits the increase pledge page
    And he fills in the "pledge_total_amount" field with <total_amount>
    And he press the "Save" button
    Then he should see "<message>"

  Examples: Succesful Increase
  | total_amount | message                       |
  | 99900        | Pledge increased succesfully. |
  | 123400       | Pledge increased succesfully. |

  Examples: Failed Increase
  | total_amount | message                                    |
  |              | is not a number and must be greater than 0 |
  | -15900       | must be greater than 0                     |


  #Scenario: Pledge increase request
  #  Given a fundraiser exists
  #  And a campaign of that fundraiser exists
  #  And a pledge of that campaign exists
  #  And that fundraiser is logged in
  #  When he visits the 