Feature: User Registration
	
	User registration includes two sides:
	The form-based registration where the user has to manually fill out all the required fields.
	The Oauth registration, where we get some user data via Twitter or Google servicies and then we request the user to check out its data.
	In both cases we require activate the account through an email.

	In order to use CakeFundraising
	As a new User
	I want to register in the site

	Background:
		Given that I am not registered
		When I go to get started page
		And I click on the "Start Now" link

	Scenario Outline: User registration page
		And I fill in the "user_full_name" field with <full_name>
		And I fill in the "user_email" field with <email>
		And I fill in the "user_password" field with <password>
		And I fill in the "user_password_confirmation" field with <password_confirmation>
		And I press the "Sign up" button
		Then I should see "<message>"
		And I should have <user_count> new user

	Examples: Successful registrations
	| full_name  			| email            			| password      		| password_confirmation 	| message                                                                                                                | user_count |
	| Emiliano Coppo  | emiliano@bytelion.com | mySecretPassword	| mySecretPassword        | A message with a confirmation link has been sent to your email address. Please open the link to activate your account. | 1         	|
	| Some Anonymous  | anon@anon.com			   	| anonUser123   		| anonUser123         		| A message with a confirmation link has been sent to your email address. Please open the link to activate your account. | 1         	|

	Examples: Failed registrations
	| full_name  		| email            		| password      		| password_confirmation | message																			| user_count |
	|               | bismark64@gmail.com | mySecretPassword 	| mySecretPassword      | can't be blank                  						| 0          |
	| Example User  | example@example.com | example5555555   	| example6666666				| Password confirmationdoesn't match Password	| 0          |


	@oauth
	Scenario Outline: OAuth2 registration
		And I press the "<provider_link>" link and allow the required permissions
		Then I should be taken to the user registration page
		When I fill in the "user_email" field with <email>
		When I fill in the "user_password" field with <password>
		When I fill in the "user_password_confirmation" field with <password_confirmation>
		When I press the "Sign up" button
		Then I should see "<message>"
		And 1 email should be delivered to <email>
		And I should have <user_count> new user

	Examples:
	| provider_link | message                                                                                                                | email          		 | password  			    | password_confirmation | user_count |
	| Facebook      | A message with a confirmation link has been sent to your email address. Please open the link to activate your account. | bismark64@gmail.com | "mySecretPassword" | "mySecretPassword"   	| 1          |
	| Twitter       | A message with a confirmation link has been sent to your email address. Please open the link to activate your account. | bismark64@gmail.com | "mySecretPassword" | "mySecretPassword"   	| 1          |
	| Linkedin      | A message with a confirmation link has been sent to your email address. Please open the link to activate your account. | bismark64@gmail.com | "mySecretPassword" | "mySecretPassword"		| 1          |