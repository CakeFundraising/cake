Feature: Fundraiser Email Notifications
  
  In order to receive notifications from the activity in Cake
  As a Fundraiser
  I want to edit my email notifications settings

  Background:
    Given a fundraiser exists

  Scenario Outline: New pledge offers
    And a pledge of that fundraiser exists
    And the fundraiser <wants?> to receive notifications for "New pledge offers"
    When the pledge is launched 
    Then <quantity> email should be delivered with subject: "You have a new pledge offer."

    Examples: Enabled notification
    | wants? | quantity |
    | wants  | 1        |
    
    Examples: Disabled notification
    | wants?        | quantity |
    | doesn't want  | 0        |

  Scenario Outline: Change to account information
    And the fundraiser <wants?> to receive notifications for "Change of account information"
    When the fundraiser's account information is changed 
    Then <quantity> email should be delivered with subject: "Your account information has been modified."

    Examples: Enabled notification
    | wants? | quantity |
    | wants  | 1        |
    
    Examples: Disabled notification
    | wants?        | quantity |
    | doesn't want  | 0        |

  Scenario Outline: Change to public profile
    And the fundraiser <wants?> to receive notifications for "Change to public profile"
    When the fundraiser's public profile is changed 
    Then <quantity> email should be delivered with subject: "Your public profile has been modified."

    Examples: Enabled notification
    | wants? | quantity |
    | wants  | 1        |
    
    Examples: Disabled notification
    | wants?        | quantity |
    | doesn't want  | 0        |

  Scenario Outline: Campaign ends
    And a campaign of that fundraiser exists
    And the fundraiser <wants?> to receive notifications for "Campaign end summary"
    When his campaign ends
    Then <quantity> email should be delivered with subject: "Your campaign has ended."

    Examples: Enabled notification
    | wants? | quantity |
    | wants  | 1        |
    
    Examples: Disabled notification
    | wants?        | quantity |
    | doesn't want  | 0        |