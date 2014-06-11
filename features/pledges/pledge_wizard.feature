Feature: Pledge Wizard

  In order to receive clicks from Customer users
  As a Sponsor
  I want to create a Pledge for a Campaign

  Background:
    Given a sponsor exists
    And that sponsor is logged in

  #@javascript
  Scenario Outline: Your Pledge
    And a campaign with pledge levels exists
    When he visits the new pledge page
    And he fills in the "pledge_amount_per_click" field with <click_amount>
    And he fills in the "pledge_total_amount" field with <total_amount>
    And he fills in the "pledge_website_url" field with <website>
    And he checks the "By clicking here I agree to..." checkbox
    And he press the "Agree & Continue" button
    Then he should see "<message>"

  Examples: Successful step
  | click_amount | total_amount | website             | message                          |
  | 10.00        | 1000.00    | example.com         | Pledge was successfully created. |
  | 5.00         | 2000.00    | http://example.com/ | Pledge was successfully created. |

  Examples: Failed Step
  | click_amount | total_amount | website             | message                |
  | 0.00         | 100000.00    | example.com         | must be greater than 0 |
  | 5.00         |              | http://example.com/ | must be greater than 0 |
  | 5.00         | 100000.00    |                     | can't be blank         |
  | 5.00         | -1588.00     | http://example.com/ | must be greater than 0 |

  Scenario Outline: Tell your Story
    And a pledge of that sponsor exists
    When he goes to pledge wizard tell your story page
    And he fills in the "Pledge mission statement" field with <mission>
    And he fills in the "Headline" field with <headline>
    And he fills in the "Your Story" field with <description>
    And he attachs an "avatar" image on the "pledge_picture_attributes_avatar" field
    And he attachs an "banner" image on the "pledge_picture_attributes_banner" field
    And he press the "Save & Continue" button
    Then he should see "<message>"

  Examples: Successful step
  | mission   | headline  | description                       | message                          |
  | Some text | More text | Long text describing the pledge.. | Pledge was successfully updated. |

  Examples: Failed Step
  | mission   | headline  | description                       | message        |
  |           | More text | Long text describing the pledge.. | can't be blank |
  |           | More text |                                   | can't be blank |

  Scenario Outline: Add Coupon
    And a pledge of that sponsor exists
    When he goes to pledge wizard add coupon page
    And he fills in the "Title" field with <title>
    And he fills in the "Expires at" field with <expires_at>
    And he fills in the "Description" field with <description>
    And he attachs an "avatar" image on the "pledge_coupons_attributes_0_avatar" field
    And he attachs an "qrcode" image on the "pledge_coupons_attributes_0_qrcode" field
    And he press the "Continue" button
    Then he should see "<message>"

    Examples: Skip coupons
    | title     | expires_at | description                        | message                          |
    |           |            |                                    | Pledge was successfully updated. |
    |           | 02/09/2014 | Long text describing the coupon... | Pledge was successfully updated. |
    
    Examples: Successful step
    | title     | expires_at | description                        | message                          |
    | My Coupon | 02/08/2015 | Long text describing the coupon... | Pledge was successfully updated. |

    Examples: Failed step
    | title     | expires_at | description                        | message        |
    | My Coupon |            | Long text describing the coupon... | can't be blank |
    | My Coupon | 02/08/2015 |                                    | can't be blank |

  Scenario: Confirm your Pledge
    And a pledge of that sponsor exists
    And a pledge request related to that pledge exists
    When he goes to pledge wizard share page
    And he press the "Confirm your Pledge" link
    Then he should see "Pledge was successfully launched."
    And the pledge should have a "pending" status
    And it should delete the related pledge request 