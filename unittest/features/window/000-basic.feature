Feature: Testing Basic Window GUI Control Functions

Scenario: Verify [find window] is working by searching for NotePad.
	Given I go to "http://127.0.0.1:8777/window/find?key=unit-test-12345&title=Untitled%20-%20Notepad"
	Then the property "status" in the JSON matches "OK"
	And the property "title" in the JSON matches "Untitled - Notepad"

Scenario: Verify [Wait for window to Exist] is working.
	Given I go to "http://127.0.0.1:8777/window/wait?key=unit-test-12345&title=Untitled%20-%20Notepad&timeout=2"
	Then the property "status" in the JSON matches "OK"
	And the property "message" in the JSON matches "Window exists."

Scenario: Verify [flash window] is working by searching for NotePad.
	Given I go to "http://127.0.0.1:8777/window/flash?key=unit-test-12345&title=Untitled%20-%20Notepad"
	Then the property "status" in the JSON matches "OK"
	And the property "message" in the JSON matches "Window Flashed."

Scenario: Verify [Mimimize All Windows] is working.
	Given I go to "http://127.0.0.1:8777/window/MinimizeAll?key=unit-test-12345"
	Then the property "status" in the JSON matches "OK"
	And the property "message" in the JSON matches "All Windows Minimised."

Scenario: Verify [Undo Mimimize All Windows] is working.
	Given I go to "http://127.0.0.1:8777/window/UndoMinimizeAll?key=unit-test-12345"
	Then the property "status" in the JSON matches "OK"
	And the property "message" in the JSON matches "Attempted to reverese last [All Windows Minimised]."

Scenario: Verify [Mimimize Window] is working.
	Given I go to "http://127.0.0.1:8777/window/minimize?key=unit-test-12345&title=Untitled%20-%20Notepad"
	Then the property "status" in the JSON matches "OK"
	And the property "message" in the JSON matches "Window Minmized"

Scenario: Verify [Maximize Window] is working.
	Given I go to "http://127.0.0.1:8777/window/maximize?key=unit-test-12345&title=Untitled%20-%20Notepad"
	Then the property "status" in the JSON matches "OK"
	And the property "message" in the JSON matches "Window Maximized"

Scenario: Verify [Hide Window] is working.
	Given I go to "http://127.0.0.1:8777/window/hide?key=unit-test-12345&title=Untitled%20-%20Notepad"
	Then the property "status" in the JSON matches "OK"
	And the property "message" in the JSON matches "Window hidden"

Scenario: Verify [Show Window] is working.
	Given I go to "http://127.0.0.1:8777/window/show?key=unit-test-12345&title=Untitled%20-%20Notepad"
	Then the property "status" in the JSON matches "OK"
	And the property "message" in the JSON matches "Window shown"

Scenario: Verify [Restore Window] is working.
	Given I go to "http://127.0.0.1:8777/window/restore?key=unit-test-12345&title=Untitled%20-%20Notepad"
	Then the property "status" in the JSON matches "OK"
	And the property "message" in the JSON matches "Window restored"

Scenario: Verify [Activate Window] is working.
	Given I go to "http://127.0.0.1:8777/window/activate?key=unit-test-12345&title=Untitled%20-%20Notepad"
	Then the property "status" in the JSON matches "OK"
	And the property "message" in the JSON matches "Window activated"

	Scenario: Verify [Wait for window to be active] is working.
	Given I go to "http://127.0.0.1:8777/window/waitactive?key=unit-test-12345&title=Untitled%20-%20Notepad&timeout=2"
	Then the property "status" in the JSON matches "OK"
	And the property "message" in the JSON matches "Window Active."