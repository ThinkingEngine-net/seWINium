Feature: Testing Core Driver Functionality.

Scenario: Verify seWINium is working
	Given I go to "http://127.0.0.1:8777"
	Then I should see "You must specific a command."

Scenario: Verify command missing feedback is working
	Given I go to "http://127.0.0.1:8777/amissingcommand?key=unit-test-12345"
	Then I should see "Command Not supported."

Scenario: Verify Key/Passphrase Protection is working by failure (1)
	Given I go to "http://127.0.0.1:8777/about?key=unit-test-123456"
	Then I should see "You must specific the correct key (passphrase) as a parameter."

Scenario: Verify Key/Passphrase Protection is working by failure (2)
	Given I go to "http://127.0.0.1:8777/about?key=unit-test-1234"
	Then I should see "You must specific the correct key (passphrase) as a parameter."

Scenario: Verify [About] function is working
	Given I go to "http://127.0.0.1:8777/about?key=unit-test-12345"
	Then the property "status" in the JSON matches "OK"
	And the property "driver" in the JSON matches "seWINium Driver"

Scenario: Verify [Parameter decoding] function is working correctly
	Given I go to "http://127.0.0.1:8777/debug/paramtest?key=unit-test-12345&param1=a&param2=100"
	Then I should see "key :: unit-test-12345"
	Then I should see "param1 :: a"
	Then I should see "param2 :: 100"

Scenario: Verify [Parameter decoding and locate parameter] functions are working correctly
	Given I go to "http://127.0.0.1:8777/debug/paramtest/findwindowparam?key=unit-test-12345&param1=a&param2=100&window=found"
	Then I should see "key :: unit-test-12345"
	Then I should see "param1 :: a"
	Then I should see "param2 :: 100"
	Then I should see "The window parameter is 'found'"
