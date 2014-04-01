Feature: User Registration
	
	User registration includes two sides:
	The form-based registration where the user has to manually fill out all the required fields.
	The Oauth registration, where we get some user data via Twitter or Google servicies and then we request the user to check out its data.
	In both cases we require activate the account through an email.


	Background:
		Given that I am not registered
		When I go to user's registration page

	Scenario Outline: User registration page
		And I fill in "user_full_name" field with <user_full_name>
		And I fill in "user_email" field with <user_email>
		And I fill in "user_password" field with <user_password>
		And I fill in "user_password_confirmation" field with <user_password_confirmation>
		And I press the "Sign up" button
		And I should see "<message>"
		And 1 email should be delivered to <user_email>
		And I should have <User count> new user


	Examples: Successful registrations
| user_full_name  | user_email            | user_password      | user_password_confirmation | message                                                                                                                | Receive Email?   | User count |
| "Emiliano Coppo"   | "emiliano@bytelion.com" | "mySecretPassword" | "mySecretPassword"         | A message with a confirmation link has been sent to your email address. Please open the link to activate your account. | receive an email | 1          |

| "Some Anonymous"   | "anon@anon.com"			   | "anonUser123"   		| "anonUser123"         		 | A message with a confirmation link has been sent to your email address. Please open the link to activate your account. | receive an email | 1          |

		Scenario Outline: User registration page
			And I fill in "user_full_name" field with <user_full_name>
			And I fill in "user_email" field with <user_email>
			And I fill in "user_password" field with <user_password>
			And I fill in "user_password_confirmation" field with <user_password_confirmation>
			And I press the "Sign up" button
			And I should see "<message>"
			And 0 email should be delivered to <user_email>
			And I should have <User count> new user

		Examples: Failed registrations
| user_full_name  | user_email            | user_password      | user_password_confirmation | message                                          | User count |
| ""              | "bismark64@gmail.com" | "mySecretPassword" | "mySecretPassword"         | Full name can't be blank                        | 0          |

| "Example User"          | "example@example.com" | "example5555555"   | "example6666666"           | Password confirmation doesn't match Password              |  0          |


	@oauth
	Scenario Outline: OAuth2 registration
		And I press the "<Provider Link>" link and allow the required permissions
		Then I should be redirected to the new registration page
		When I fill in "user_email" field with "<user_email>"
		When I fill in "user_password" field with "<user_password>"
		When I fill in "user_password_confirmation" field with "<user_password_confirmation>"
		When I press the "Sign up" button
		Then I should see "<Message>"
		And 1 email should be delivered to <user_email>
		And I should have <User count> new user

	Examples:
| Provider Link | Message                                                                                                                | user_email          | user_password      | user_password_confirmation | Receive Email?   | User count |
| Facebook      | A message with a confirmation link has been sent to your email address. Please open the link to activate your account. | bismark64@gmail.com | "mySecretPassword" | "mySecretPassword"        | receive an email | 1          |
| Twitter       | A message with a confirmation link has been sent to your email address. Please open the link to activate your account. | bismark64@gmail.com | "mySecretPassword" | "mySecretPassword"        | receive an email | 1          |
| Linkedin      | A message with a confirmation link has been sent to your email address. Please open the link to activate your account. | bismark64@gmail.com | "mySecretPassword" | "mySecretPassword"        | receive an email | 1          |