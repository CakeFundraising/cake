Feature: User Sign In

  Like the User registration the User Sign In process has two flows:
  1. Email based: The user enters her email and password and press the Sign In button
  2. Via Social Networks: The user selects sign in via her social networks, the system automatically sign in the user, without filling out anything.

  Scenario Outline: Email based 
    Given the following fundraisers exist
    | email               | 
    | example@example.com | 
    | test@example.com    |
    | joana@streich.name  |
    | evans@osinski.info  |
    When they go to sign in page
    And they fill in the "user_email" field with <email>
    And they fill in the "user_password" field with <password>
    And they press the "Sign in" button
    Then I should see "<message>"

    Examples: Succesful login
    | email               | password      | message                 |
    | example@example.com | password      | Signed in successfully. |
    | test@example.com    | password      | Signed in successfully. |
    | joana@streich.name  | password      | Signed in successfully. |
    | evans@osinski.info  | password      | Signed in successfully. |

    Examples: Failed login
    | email               | password      | message                    |
    | example@example.com |               | Invalid email or password. |
    |                     | password      | Invalid email or password. |
    | joana@streich.name  | Mypassword    | Invalid email or password. |
    | unexistent@mail.info| password      | Invalid email or password. |


  Scenario Outline: Via Social Networks
    Given the following social_connected_users exist
    | provider |  uid          |
    | facebook | 4asdd787d787s |
    | twitter  | 877df787s8787 |
    | linkedin | asdsd7878d111 |
    When they go to sign in page
    When they press the "<provider_link>" link and allow the required permissions
    Then they should see "<message>"

    Examples: Succesful login
    | provider_link | message                                           |
    | Facebook      | Successfully authenticated from Facebook account. |
    | Twitter       | Successfully authenticated from Twitter account.  |
    | Linkedin      | Successfully authenticated from Linkedin account. |