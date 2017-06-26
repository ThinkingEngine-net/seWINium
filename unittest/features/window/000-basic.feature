Feature: Testing Basic Widnow GUI Control Functions

Scenario: Verify [find window] is working by searching for NotePad.
	Given I go to "http://127.0.0.1:8777/window/find?key=unit-test-12345&title=Untitled%20-%20Notepad"
	Then the property "status" in the JSON matches "OK"
	And the property "title" in the JSON matches "Untitled - Notepad"

Scenario: Verify [flash window] is working by searching for NotePad.
	Given I go to "http://127.0.0.1:8777/window/flash?key=unit-test-12345&title=Untitled%20-%20Notepad"
	Then the property "status" in the JSON matches "OK"
	And the property "message" in the JSON matches "Window Flashed."

