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
    And he fills in the "campaign_launch_date" field with <launch_date>
    And he fills in the "campaign_end_date" field with <end_date>
    And he selects <causes> in "campaign_causes"
    And he checks <scopes> from the Types of Campaigns options
    And he press the "Save & Continue" button
    Then he should see "<message>"

    Examples: Succesful step
    | name            | causes         | scopes  | launch_date | end_date   | message                            |
    | My new campaign | Arts & Culture | National| 04/12/2015  | 06/21/2015 | Campaign was successfully created. |
    | Other campaign  | US Relief      |  Global | 08/21/2014  | 12/21/2014 | Campaign was successfully created. |

    Examples: Failed step
    | name            | causes         | scopes  | launch_date | end_date   | message         |
    | My new campaign | Arts & Culture | Local   |             | 06/21/2015 | can't be blank  |
    |                 | US Relief      | Global  | 08/21/2014  | 12/21/2014 | can't be blank  |

  Scenario Outline: Tell your Story
    And a campaign of that fundraiser exists
    When he goes to campaign wizard tell your story page
    And he fills in the "Headline" field with <headline>
    And he fills in the "Story" field with <story>
    And he fills in the "Campaign Mission Statement" field with <mission>
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
    And a campaign of that fundraiser exists with custom_pledge_levels: true
    When he goes to campaign wizard sponsors page
    And he fills in the "Lowest Pledge Level" field with <lowest_name>
    And he fills in the "campaign_sponsor_categories_attributes_2_max_value" field with <lowest_max_value>
    And he fills in the "Medium Pledge Level" field with <medium_name>
    And he fills in the "campaign_sponsor_categories_attributes_1_max_value" field with <medium_max_value>
    And he fills in the "Highest Pledge Level" field with <highest_name>
    And he fills in the "campaign_sponsor_categories_attributes_0_max_value" field with <highest_max_value>
    And he press the "Save & Continue" button
    Then he should see "<message>"
    
    Examples: Succesful step
    | lowest_name      | lowest_max_value | medium_name  | medium_max_value | highest_name     | highest_max_value | message                            |
    | Silver Sponsor   | 100000           | Gold Sponsor | 1000000          | Platinum Sponsor | 10000000          | Campaign was successfully updated. |
    | Minor            | 10000            | Medium       | 100000           | Major            | 1000000           | Campaign was successfully updated. |

    Examples: Failed step
    | lowest_name      | lowest_max_value | medium_name  | medium_max_value | highest_name     | highest_max_value | message                                                                                               |
    |                  | 100000           | Gold Sponsor | 1000000          | Platinum Sponsor | 10000000          | can't be blank                                                                                        |
    | Minor            | 45               | Medium       | 100000           | Major            | 1000000           | Sponsor categories The max and min values must not overlap. Max value must be greater than Min value. |
    | Minor            | 10000            | Medium       | 10000            | Major            | 1000000           | Sponsor categories The max and min values must not overlap. Max value must be greater than Min value. |

  Scenario: Solicit Sponsors
    And a campaign of that fundraiser exists
    When he goes to campaign wizard share page
    Then he should see the invitation link and badge