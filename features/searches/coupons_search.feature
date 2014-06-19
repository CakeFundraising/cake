Feature: Coupons Search Page
  
  In order to find coupons on Cake
  As any user
  I want to be able to search and filter coupons

  Background:
    Given the following coupons exist
    | title                   | merchandise_categories  |
    | 20% off on pants        | Cash & Credits          |
    | Intelligent Rubber Hat  | Mortgage & Insurance    | 
    | Gorgeous Cotton Shirt   | Legal & Accounting      |
    | Rustic Wooden Table     | Internet & Websites     |
    | Small Cotton Gloves     | Baby & Children         |
    When a user visits the search coupons page

  @search
  Scenario Outline: Searching 
    And he fills in the "search" field with <query>
    And he press the "Search" button
    Then he should see "<coupon_title>"

  Examples: Successful search
  | query       | coupon_title          |
  | pants       | 20% off on pants      |
  | Table       | Rustic Wooden Table   |
  | Shirt       | Gorgeous Cotton Shirt |

  Examples: Empty search
  | query    | coupon_title      |
  | Computer | No results found. |
  | Car      | No results found. |

  @search
  Scenario Outline: Filtering 
    And he press the "<filter>" link
    Then he should see "<coupon_title>"

  Examples: Successful filtering
  | filter                | coupon_title           |
  | Legal & Accounting    | Gorgeous Cotton Shirt  |
  | Internet & Websites   | Rustic Wooden Table    |
  | Mortgage & Insurance  | Intelligent Rubber Hat |