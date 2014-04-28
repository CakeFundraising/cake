Feature: Pledge Wizard

  In order to receive clicks from Customer users
  As a Sponsor
  I want to create a Pledge for a Campaign

  Background:
    Given a sponsor exists
    And that sponsor is logged in

  Scenario Outline: Your Pledge
    And the following campaigns exist:
    | title          |
    | My campaign    |
    | Other campaign |
    When he goes to new pledge page
    And he fills in the "pledge_amount_per_click" field with <click_amount>
    And he selects <donation_type> in "pledge_donation_type"
    And he selects <campaign> in "pledge_campaign_id"
    And he fills in the "pledge_total_amount" field with <total_amount>
    And he fills in the "pledge_website_url" field with <website>
    And he checks the "By clicking here I agree to..." checkbox
    And he press the "Agree & Continue" button
    Then he should see "<message>"

  Examples: Successful step
  | click_amount | donation_type      | campaign     | total_amount | website             | message                          |
  | 10.00        | Cash               | My campaign  | 100000.00    | example.com         | Pledge was successfully created. |
  | 5.00         | Goods & Services   | My campaign  | 100000.00    | http://example.com/ | Pledge was successfully created. |

  Examples: Failed Step
  | click_amount | donation_type      | campaign     | total_amount | website             | message                |
  | 0.00         | Cash               | My campaign  | 100000.00    | example.com         | must be greater than 0 |
  | 5.00         | Goods & Services   |              | 500.00       | http://example.com/ | can't be blank         |
  | 5.00         | Cash               |              | 100000.00    |                     | can't be blank         |
  | 5.00         | Goods & Services   |              | -1588.00     |                     | must be greater than 0 |

  Scenario Outline: Tell your Story
    And a pledge of that sponsor exists
    When he goes to pledge wizard tell your story page
    And he fills in the "Mission" field with <mission>
    And he fills in the "Headline" field with <headline>
    And he fills in the "Description" field with <description>
    And he attachs an "avatar" image for the pledge
    And he attachs an "banner" image for the pledge
    And he press the "Save & Continue" button
    Then he should see "<message>"

  Examples: Successful step
  | mission   | headline  | description                       | message                          |
  | Some text | More text | Long text describing the pledge.. | Pledge was successfully updated. |

  Examples: Failed Step
  | mission   | headline  | description                       | message        |
  |           | More text | Long text describing the pledge.. | can't be blank |
  |           | More text |                                   | can't be blank |