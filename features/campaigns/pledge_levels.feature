Feature: Pledge Levels
  
  Background:
    Given a fundraiser exists
    And a campaign of that fundraiser exists
    And that fundraiser is logged in
    When he visits the campaign wizard sponsors page
    And he press the "Set custom sponsorship pledge levels" button

  #No Levels (New)
  @javascript
  Scenario Outline: Linear Insertion
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

  @javascript
  Scenario Outline: Linear Insertion and Middle level removal
    And he fills in the "Pledge Level" field with <lowest_name>
    And he fills in the "campaign_sponsor_categories_attributes_0_max_value" field with <lowest_max_value>
    And he press the "Add Next Pledge Level" link
    And he fills in the appearing "Pledge Level" field with <medium_name>
    And he fills in the appearing "Max value" field with <medium_max_value>
    And he press the "Add Next Pledge Level" link
    And he fills in the appearing "Pledge Level" field with <highest_name>
    And he fills in the appearing "Max value" field with <highest_max_value>
    And he removes the Middle level
    Then Top Level min value should be <lowest_max_value>

  Examples: Succesful step
    | lowest_name      | lowest_max_value | medium_name  | medium_max_value | highest_name     | highest_max_value |
    | Silver Sponsor   | 100000           | Gold Sponsor | 1000000          | Platinum Sponsor | 10000000          |
    | Minor            | 10000            | Medium       | 100000           | Major            | 1000000           |
    | Minor            | 599              | Medium       | 5688             | Major            | 12545             |

  #### Already stored levels (Edit)
  ## Insertions
  @javascript
  Scenario Outline: Linear Insertion
    And he fills in the "Pledge Level" field with <lowest_name>
    And he fills in the "campaign_sponsor_categories_attributes_0_max_value" field with <lowest_max_value>
    And he press the "Save & Continue" button
    #returns to pledge levels page
    And he visits the campaign wizard sponsors page
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
  | Minor            | 100000           |              | 1000000          | Platinum Sponsor | 10000000          | This field is required.                  |
  | Minor            | 599              | Medium       | 56               | Major            | 1000000           | Please enter a value greater than $600   |
  | Minor            | 599              | Medium       | 5999             | Major            | 2500              | Please enter a value greater than $6000  |
  | Minor            | 10000            | Medium       | 10000            | Major            | 1000000           | Please enter a value greater than $10001 |

  ## Removals
  @javascript 
  Scenario Outline: Linear Removal (Top Level removal)
    #store levels
    And he fills in the "Pledge Level" field with <lowest_name>
    And he fills in the "campaign_sponsor_categories_attributes_0_max_value" field with <lowest_max_value>
    And he press the "Add Next Pledge Level" link
    And he fills in the appearing "Pledge Level" field with <medium_name>
    And he fills in the appearing "Max value" field with <medium_max_value>
    And he press the "Add Next Pledge Level" link
    And he fills in the appearing "Pledge Level" field with <highest_name>
    And he fills in the appearing "Max value" field with <highest_max_value>
    And he press the "Save & Continue" button
    And he visits the campaign wizard sponsors page
    #removal steps
    And he removes the Top level
    Then Middle Level min value should be <lowest_max_value>

  Examples: Succesful step
    | lowest_name      | lowest_max_value | medium_name  | medium_max_value | highest_name     | highest_max_value |
    | Silver Sponsor   | 100000           | Gold Sponsor | 1000000          | Platinum Sponsor | 10000000          |
    | Minor            | 10000            | Medium       | 100000           | Major            | 1000000           |
    | Minor            | 599              | Medium       | 5688             | Major            | 12545             |

  @javascript
  Scenario Outline: Middle Level removal
    #store levels
    And he fills in the "Pledge Level" field with <lowest_name>
    And he fills in the "campaign_sponsor_categories_attributes_0_max_value" field with <lowest_max_value>
    And he press the "Add Next Pledge Level" link
    And he fills in the appearing "Pledge Level" field with <medium_name>
    And he fills in the appearing "Max value" field with <medium_max_value>
    And he press the "Add Next Pledge Level" link
    And he fills in the appearing "Pledge Level" field with <highest_name>
    And he fills in the appearing "Max value" field with <highest_max_value>
    And he press the "Save & Continue" button
    And he visits the campaign wizard sponsors page
    #removal steps
    And he removes the Middle level
    Then Top Level min value should be <lowest_max_value>

  Examples: Succesful step
    | lowest_name      | lowest_max_value | medium_name  | medium_max_value | highest_name     | highest_max_value |
    | Silver Sponsor   | 100000           | Gold Sponsor | 1000000          | Platinum Sponsor | 10000000          |
    | Minor            | 10000            | Medium       | 100000           | Major            | 1000000           |
    | Minor            | 599              | Medium       | 5688             | Major            | 12545             |

