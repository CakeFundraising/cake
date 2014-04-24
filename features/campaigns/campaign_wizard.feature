Feature: Campaign Wizard Steps
  
  In order to create a Campaign
  As a Fundraiser 
  I have to complete the campaign creation wizard

  Background:
    Given a fundraiser exists
    And that fundraiser is logged in
  
  Scenario Outline: Tell your Story Step
    When he goes to new campaign's page
    And he fills in "Title" field with <title>
    And he selects <causes> in "Causes"
    And he selects <scopes> in "Scopes"
    And he fills in "Story" field with <story>
    And he fills in "Headline" field with <headline>
    And he fills in "campaign_launch_date" field with <launch_date>
    And he fills in "campaign_end_date" field with <end_date>
    And he press the "Save & Continue" button
    Then he should see "<message>"

    Examples: Succesful step
    | title           | causes         | scopes  | story           | headline      | launch_date | end_date   | message                            |
    | My new campaign | Arts & Culture | National| Some story text | Some headline | 12/04/2015  | 21/06/2015 | Campaign was successfully created. |
    | Other campaign  | US Relief      |  Global | Some story text | Some headline | 21/08/2014  | 21/12/2014 | Campaign was successfully created. |

    Examples: Failed step
    | title           | causes         | scopes  | story           | headline      | launch_date | end_date   | message         |
    | My new campaign | Arts & Culture | Local   | Some story text |               | 12/04/2015  | 21/06/2015 | can't be blank  |
    |                 | US Relief      | Global  | Some story text | Some headline | 21/08/2014  | 21/12/2014 | can't be blank  |
  
  Scenario Outline: Pledge Levels
    And a campaign exists of that fundraiser
    When he goes to pledge levels page
    And he fills in "Name" field with <name>
    And he fills in "Min value" field with <min_value>
    And he fills in "Max value" field with <max_value>
    And he press the "Save & Continue" button
    Then he should see "<message>"
    
    Examples: Succesful step
    | name             | min_value | max_value  | message                            |
    | Platinum Sponsor | 100000    | 10000000   | Campaign was successfully updated. |
    | Gold Sponsor     | 10000     | 100000     | Campaign was successfully updated. |

    Examples: Failed step
    | name             | min_value | max_value  | message                |
    |                  | 100000    | 10000000   | can't be blank         |
    | Gold Sponsor     |           | 100000     | must be greater than 0 |

  Scenario: Solicit Sponsors
    And a campaign exists of that fundraiser
    When he goes to solicit sponsors page
    Then he should see the invitation link and badge