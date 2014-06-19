Feature: Sponsors Search Page
  
  In order to find sponsors on Cake
  As any user
  I want to be able to search and filter sponsors

  Background:
    Given the following sponsors exist
    | name              | causes               |
    | Torrey Huels      | International Relief |
    | Baumbach-Dibbert  | Education & Schools  | 
    | MacGyver and Sons | Arts & Culture       |
    | Kiehn Inc         | Health & Medicine    |
    | Murphy Group      | Animals & Pets       |
    When a user visits the search sponsors page

  @search
  Scenario Outline: Searching 
    And he fills in the "search" field with <query>
    And he press the "Search" button
    Then he should see "<sponsor_name>"

  Examples: Successful search
  | query       | sponsor_name      |
  | Huels       | Torrey Huels      |
  | MacGyver    | MacGyver and Sons |
  | Group       | Murphy Group      |

  Examples: Empty search
  | query        | sponsor_name      |
  | Coke         | No results found. |
  | Maryland Co. | No results found. |

  @search
  Scenario Outline: Filtering 
    And he press the "<filter>" link
    Then he should see "<sponsor_name>"

  Examples: Successful filtering
  | filter                | sponsor_name      |
  | Education & Schools   | Baumbach-Dibbert  |
  | Animals & Pets        | Murphy Group      |
  | Health & Medicine     | Kiehn Inc         |