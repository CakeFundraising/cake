Feature: Fundraiser Email Notifications
  
  In order to receive notifications from the activity in Cake
  As a Fundraiser
  I want to edit my email notifications settings

  Background:
    Given a fundraiser exists

  Scenario Outline: New pledge offers
    And a pledge of that fundraiser exists
    And the fundraiser user <wants?> to receive notifications for "New pledge offers"
    When the pledge is launched 
    Then <quantity> email should be delivered with subject: "You have a new pledge offer."

    Examples: Enabled notification
    | wants? | quantity |
    | wants  | 1        |
    
    Examples: Disabled notification
    | wants?        | quantity |
    | doesn't want  | 0        |

  Scenario Outline: Change to account information
    And the fundraiser user <wants?> to receive notifications for "Change of account information"
    And that fundraiser is logged in
    When he visits the account settings page
    And he fills in the "Full name" field with My new Full Name
    And he fills in the "Current password" field with password
    And he press the "Update Account" button
    Then <quantity> email should be delivered with subject: "Your account information has been modified."

    Examples: Enabled notification
    | wants? | quantity |
    | wants  | 1        |
    
    Examples: Disabled notification
    | wants?        | quantity |
    | doesn't want  | 0        |

  Scenario Outline: Change to public profile
    And the fundraiser user <wants?> to receive notifications for "Change to public profile"
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
    And the fundraiser user <wants?> to receive notifications for "Campaign end summary"
    When his campaign ends
    Then <quantity> email should be delivered with subject: "Your campaign has ended."

    Examples: Enabled notification
    | wants? | quantity |
    | wants  | 1        |
    
    Examples: Disabled notification
    | wants?        | quantity |
    | doesn't want  | 0        |

  Scenario Outline: Campaign launch date missed
    And a campaign of that fundraiser exists
    And the fundraiser user <wants?> to receive notifications for "Campaign launch date missed"
    When his campaign launch date is missed
    Then <quantity> email should be delivered with subject: "Your campaign has missed its launch date!"

    Examples: Enabled notification
    | wants? | quantity |
    | wants  | 1        |
    
    Examples: Disabled notification
    | wants?        | quantity |
    | doesn't want  | 0        |

  Scenario: Invoice created
    And a campaign of that fundraiser exists
    And a pledge of that campaign exists
    When his campaign ends
    Then 2 emails should be delivered with subject: "You have outstanding invoices."

  Scenario: Invoice Paid
    And a campaign of that fundraiser exists
    And a pledge of that campaign exists
    And a pending invoice of that pledge exists
    When the sponsor pays the invoice
    Then 1 email should be delivered with subject: "Your invoice has been paid."