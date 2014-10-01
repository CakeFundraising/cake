Feature: Edit Pledge

  In order to change my pledge offer
  As a Sponsor
  I want to be able to edit my pledge

  Background:
    Given a sponsor exist

  Scenario: Edit links in Active pledges
    And that sponsor is logged in
    And 5 pledges of that sponsor exist
    When he visits the sponsor active pledges page
    Then he should see 5 edit buttons 

  Scenario Outline: Edit pledge page
    And that sponsor is logged in
    And a pledge of that sponsor exists with mission: 'My mission', headline: 'This is my headline'
    When he goes to pledge wizard tell your story page
    And he fills in the "Pledge Purpose" field with <mission>
    And he fills in the "Headline" field with <headline>
    And he press the "Save & Continue" button
    Then he should see "<message>"

  Examples: Successful Edit
  | mission   | headline  | message                          |
  | Some text | More text | Pledge was successfully updated. |

  Examples: Failed Edit
  | mission           | headline  | message        |
  |                   | More text | can't be blank |
  | Some mission text |           | can't be blank |
