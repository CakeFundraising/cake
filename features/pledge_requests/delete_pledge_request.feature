Feature: Delete Pledge Request

  In order to delete my pledge request
  As a Fundraiser
  I want to use Cake to delete it

  Scenario: Table display
    Given a fundraiser exists
    And a pledge request of that fundraiser exists
    And that fundraiser is logged in
    When he visits the fundraiser pending pledges page
    And he press the delete button
    Then he should see "Pledge request was successfully destroyed."    