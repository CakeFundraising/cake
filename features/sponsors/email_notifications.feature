Feature: Sponsor Email Notifications
  
  In order to receive notifications from the activity in Cake
  As a Sponsor
  I want to edit my email notifications settings

  Background:
    Given a sponsor exists
  
  #@javascript
  Scenario Outline: New pledge request
    And the sponsor user <wants?> to receive notifications for "New pledge request"
    #When a pledge request to that sponsor is made
    And a fundraiser exists
    And a campaign of that fundraiser exists with title: 'Test Pledge'
    And that fundraiser is logged in
    When he goes to the sponsor's page
    And he press the "Request Pledge" link
    And he selects Test Pledge in "Campaign"
    And he fills in the "Message" field with I want you as a partner.
    And he press the "Request Pledge" button
    Then <quantity> email should be delivered with subject: "You have a new pledge request."

    Examples: Enabled notification
    | wants? | quantity |
    | wants  | 1        |
    
    Examples: Disabled notification
    | wants?        | quantity |
    | doesn't want  | 0        |
  
  Scenario Outline: Change to account information
    And the sponsor user <wants?> to receive notifications for "Change of account information"
    And that sponsor is logged in
    When he visits the account settings page
    And he fills in the "Full Name" field with My new Full Name
    And he fills in the "Enter Password To Confirm Changes" field with password
    And he press the "Update Account" button
    Then <quantity> email should be delivered with subject: "Your account information has been modified."

    Examples: Enabled notification
    | wants? | quantity |
    | wants  | 1        |
    
    Examples: Disabled notification
    | wants?        | quantity |
    | doesn't want  | 0        |

  Scenario Outline: Change to public profile
    And the sponsor user <wants?> to receive notifications for "Change to public profile"
    And that sponsor is logged in
    When he visits the public profile page
    And he fills in the "Website" field with http://coke.com
    And he press the "Save Changes" button
    Then <quantity> email should be delivered with subject: "Your public profile has been modified."

    Examples: Enabled notification
    | wants? | quantity |
    | wants  | 1        |
    
    Examples: Disabled notification
    | wants?        | quantity |
    | doesn't want  | 0        |

  Scenario Outline: Campaign launch date missed
    And the sponsor has pledged a campaign
    And the sponsor user <wants?> to receive notifications for "Campaign launch date missed"
    When his campaign launch date is missed
    Then <quantity> email should be delivered with subject: "One of your pledged campaigns has missed its launch date!"

    Examples: Enabled notification
    | wants? | quantity |
    | wants  | 1        |
    
    Examples: Disabled notification
    | wants?        | quantity |
    | doesn't want  | 0        |

  Scenario Outline: Campaign is Launched
    And the sponsor has pledged a campaign
    And the sponsor user <wants?> to receive notifications for "Campaign is Launched"
    When his campaign is launched
    Then <quantity> email should be delivered with subject: "Your pledged campaign has been launched!"

    Examples: Enabled notification
    | wants? | quantity |
    | wants  | 1        |
    
    Examples: Disabled notification
    | wants?        | quantity |
    | doesn't want  | 0        |

  Scenario Outline: Offer to Pledge Accepted
    And a pledge of that sponsor exists
    And the sponsor user <wants?> to receive notifications for "Offer to Pledge Accepted"
    When the pledge is accepted by the fundraiser
    Then <quantity> email should be delivered with subject: "Your Pledge has been accepted."

    Examples: Enabled notification
    | wants? | quantity |
    | wants  | 1        |
    
    Examples: Disabled notification
    | wants?        | quantity |
    | doesn't want  | 0        |

  Scenario Outline: Offer to Pledge Rejected
    And a pledge of that sponsor exists
    And the sponsor user <wants?> to receive notifications for "Offer to Pledge Rejected"
    When the pledge is rejected by the fundraiser
    Then <quantity> email should be delivered with subject: "Your Pledge has been rejected."

    Examples: Enabled notification
    | wants? | quantity |
    | wants  | 1        |
    
    Examples: Disabled notification
    | wants?        | quantity |
    | doesn't want  | 0        |

  Scenario Outline: Pledge has been 100% subscribed
    And a pledge of that sponsor exists
    And the sponsor user <wants?> to receive notifications for "Pledge has been 100% subscribed"
    When the system identifies the pledge as fully subscribed
    Then <quantity> email should be delivered with subject: "Your pledge has been 100% subscribed."

    Examples: Enabled notification
    | wants? | quantity |
    | wants  | 1        |
    
    Examples: Disabled notification
    | wants?        | quantity |
    | doesn't want  | 0        |

  Scenario Outline: Request to increase a pledge
    And a pledge of that sponsor exists
    And the sponsor user <wants?> to receive notifications for "Request to increase a pledge"
    When a fundraiser requests an increase for that pledge
    Then <quantity> email should be delivered with subject: "Your pledge has a new increase request."

    Examples: Enabled notification
    | wants? | quantity |
    | wants  | 1        |
    
    Examples: Disabled notification
    | wants?        | quantity |
    | doesn't want  | 0        |

  Scenario: Invoice created
    And a pledge of that sponsor exists
    When the pledge campaign ends
    Then 2 emails should be delivered with subject: "You have outstanding invoices."