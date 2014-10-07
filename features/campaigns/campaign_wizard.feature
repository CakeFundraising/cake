Feature: Campaign Wizard
  
  In order to create a Campaign
  As a Fundraiser 
  I want to complete the campaign creation wizard

  Background:
    Given a fundraiser exists
    And that fundraiser is logged in

  Scenario Outline: Basic Information
    When he goes to new campaign page
    And he fills in the "Campaign Name" field with <name>
    And he fills in the "campaign_goal" field with <goal>
    And he fills in the "campaign_launch_date" field with <launch_date>
    And he fills in the "campaign_end_date" field with <end_date>
    And he checks <causes> from Campaign Causes
    And he selects <main_cause> in "campaign_main_cause"
    And he checks <scopes> from Types of Campaigns
    And he press the "Save & Continue" button
    Then he should see "<message>"

    Examples: Succesful step
    | name            | goal  | main_cause        | causes         | scopes  | launch_date | end_date   | message                            |
    | My new campaign | 25000 | Food & Hunger     | Arts & Culture | National| 04/12/2015  | 06/21/2015 | Campaign was successfully created. |
    | Other campaign  | 25000 | Freedom & Liberty | US Relief      |  Global | 08/21/2014  | 12/21/2014 | Campaign was successfully created. |

    Examples: Failed step
    | name            | goal  | main_cause        | causes         | scopes  | launch_date | end_date   | message         |
    | My new campaign | 25000 | Food & Hunger     | Arts & Culture | Local   |             | 06/21/2015 | can't be blank  |
    |                 | 25000 | Freedom & Liberty | US Relief      | Global  | 08/21/2014  | 12/21/2014 | can't be blank  |

  Scenario Outline: Tell your Story
    And a campaign of that fundraiser exists
    When he goes to campaign wizard tell your story page
    And he fills in the "Headline" field with <headline>
    And he fills in the "Story" field with <story>
    And he fills in the "Campaign Purpose" field with <mission>
    And he press the "Save & Continue" button
    Then he should see "<message>"

    Examples: Succesful step
    | mission            | story           | headline      | launch_date | end_date   | message                            |
    | Some mission text  | Some story text | Some headline | 04/12/2015  | 06/21/2015 | Campaign was successfully updated. |
    | Other mission text | Some story text | Some headline | 08/21/2014  | 12/21/2014 | Campaign was successfully updated. |

    Examples: Failed step
    | mission            | story           | headline      | launch_date | end_date   | message         |
    | Some mission text  | Some story text |               | 04/12/2015  | 06/21/2015 | can't be blank  |
    |                    | Some story text | Some headline | 08/21/2014  | 12/21/2014 | can't be blank  |
  
  @javascript
  Scenario Outline: Pledge Levels
    And a campaign of that fundraiser exists
    When he goes to campaign wizard sponsors page
    And he press the "Set custom sponsorship pledge levels" button
    And he fills in the "Pledge Level" field with <lowest_name>
    And he fills in the "campaign_sponsor_categories_attributes_0_max_value" field with <lowest_max_value>
    And he press the "Add Next Pledge Level" link
    And he fills in the appearing "Pledge Level" field with <medium_name>
    And he fills in the appearing "Max value" field with <medium_max_value>
    And he press the "Add Next Pledge Level" link
    And he fills in the appearing "Pledge Level" field with <highest_name>
    And he fills in the appearing "Max value" field with <highest_max_value>
    And he press the "Save & Continue" button
    Then he should see "<message>"
    
    Examples: Succesful step
    | lowest_name      | lowest_max_value | medium_name  | medium_max_value | highest_name     | highest_max_value | message                            |
    | Silver Sponsor   | 100000           | Gold Sponsor | 1000000          | Platinum Sponsor | 10000000          | Campaign was successfully updated. |
    | Minor            | 10000            | Medium       | 100000           | Major            | 1000000           | Campaign was successfully updated. |

    Examples: Failed step
    | lowest_name      | lowest_max_value | medium_name  | medium_max_value | highest_name     | highest_max_value | message                                  |
    |                  | 100000           | Gold Sponsor | 1000000          | Platinum Sponsor | 10000000          | This field is required.                  |
    | Minor            | 45               | Medium       | 100000           | Major            | 1000000           | Please enter a value greater than $50    |
    | Minor            | 10000            | Medium       | 10000            | Major            | 1000000           | Please enter a value greater than $10001 |

  Scenario: Launch Campaign
    And a uncompleted campaign of that fundraiser exists
    When he goes to campaign wizard launch wizard page
    Then he should see a "Launch your Campaign now" button
    And he should see a "Save your campaign & secure Sponsors before you launch" button

  Scenario: Find Sponsors
    And a campaign of that fundraiser exists
    When he goes to campaign wizard share page
    Then he should see the invitation link and badge

    