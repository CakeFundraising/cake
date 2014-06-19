Feature: Campaigns Search Page
  
  In order to find campaigns on Cake
  As any user
  I want to be able to search and filter campaigns

  Background:
    Given the following campaigns exist
    | title             | causes               |
    | My Campaign       | International Relief |
    | Campaign          | Education & Schools  | 
    | Save the children | Arts & Culture       |
    | Save Africa       | Health & Medicine    |
    | Help the homeless | Animals & Pets       |
    When a user visits the search campaigns page

  @search
  Scenario Outline: Searching 
    And he fills in the "search" field with <query>
    And he press the "Search" button
    Then he should see "<campaign_title>"

  Examples: Successful search
  | query       | campaign_title    |
  | Campaign    | My Campaign       |
  | homeless    | Help the homeless |
  | Save Africa | Save Africa       |

  Examples: Empty search
  | query    | campaign_title    |
  | Coke     | No results found. |
  | Maryland | No results found. |

  @search
  Scenario Outline: Filtering 
    And he press the "<filter>" link
    Then he should see "<campaign_title>"

  Examples: Successful filtering
  | filter                | campaign_title    |
  | International Relief  | My Campaign       |
  | Animals & Pets        | Help the homeless |
  | Health & Medicine     | Save Africa       |