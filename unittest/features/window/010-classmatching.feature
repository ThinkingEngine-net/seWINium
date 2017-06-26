Feature: Testing Basic Widnow GUI Control Class matching by usnign window find.

Scenario: Verify [absolute title] is working.
	Given I go to "http://127.0.0.1:8777/window/find?key=unit-test-12345&title=Untitled%20-%20Notepad"
	Then the property "status" in the JSON matches "OK"
	And the property "title" in the JSON matches "Untitled - Notepad"

Scenario: Verify [active window] is working.
	Given I go to "http://127.0.0.1:8777/window/find?key=unit-test-12345&active=true"
	Then the property "status" in the JSON matches "OK"

Scenario: Verify [last window] is working.
	Given I go to "http://127.0.0.1:8777/window/find?key=unit-test-12345&last=true"
	Then the property "status" in the JSON matches "OK"

Scenario: Verify [window class] is working.
	Given I go to "http://127.0.0.1:8777/window/find?key=unit-test-12345&class=Notepad"
	Then the property "status" in the JSON matches "OK"
	And the property "title" in the JSON matches "Untitled - Notepad"

Scenario: Verify [window postion] is working.
	Given I go to "http://127.0.0.1:8777/window/move?key=unit-test-12345&class=Notepad&left=100&top=100"
	Then the property "status" in the JSON matches "OK"
	Given I go to "http://127.0.0.1:8777/window/find?key=unit-test-12345&x=100&y=100"
	Then the property "status" in the JSON matches "OK"
	And the property "title" in the JSON matches "Untitled - Notepad"

Scenario: Verify [window size] is working.
	Given I go to "http://127.0.0.1:8777/window/move?key=unit-test-12345&class=Notepad&left=100&top=100&height=400&width=400"
	Then the property "status" in the JSON matches "OK"
	Given I go to "http://127.0.0.1:8777/window/find?key=unit-test-12345&w=400&h=400"
	Then the property "status" in the JSON matches "OK"
	And the property "title" in the JSON matches "Untitled - Notepad"

Scenario: Verify [instance] is working by failure.
	Given I go to "http://127.0.0.1:8777/window/find?key=unit-test-12345&title=Untitled%20-%20Notepad&instance=2"
	Then the property "status" in the JSON matches "Failed"

Scenario: Verify [RegEx Title] is working.
	Given I go to "http://127.0.0.1:8777/window/find?key=unit-test-12345&regexptitle=Untitled.*Notepad"
	Then the property "status" in the JSON matches "OK"
	And the property "title" in the JSON matches "Untitled - Notepad"

Scenario: Verify [RegEx Class] is working.
	Given I go to "http://127.0.0.1:8777/window/find?key=unit-test-12345&regexpclass=Not..ad"
	Then the property "status" in the JSON matches "OK"
	And the property "title" in the JSON matches "Untitled - Notepad"

