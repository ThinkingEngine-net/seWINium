Feature: Testing [Move Window] Functions

Scenario: Verify [Move Window] is working by moving NotePad.
	Given I go to "http://127.0.0.1:8777/window/move?key=unit-test-12345&class=Notepad&left=100&top=150"
	Then the property "status" in the JSON matches "OK"
	And the property "x" in the JSON matches "100"
	And the property "y" in the JSON matches "150"

Scenario: Verify [Move Window] is working by moving NotePad.
	Given I go to "http://127.0.0.1:8777/window/move?key=unit-test-12345&class=Notepad&left=100&top=150&height=400&width=400"
	Then the property "status" in the JSON matches "OK"
	And the property "x" in the JSON matches "100"
	And the property "y" in the JSON matches "150"
	And the property "h" in the JSON matches "400"
	And the property "w" in the JSON matches "400"


Scenario: Verify [Move Window] fails if out of desktop (too low x).
	Given I go to "http://127.0.0.1:8777/window/move?key=unit-test-12345&class=Notepad&left=-1&top=150"
	Then the property "status" in the JSON matches "Failed"

Scenario: Verify [Move Window] fails if out of desktop (too low y).
	Given I go to "http://127.0.0.1:8777/window/move?key=unit-test-12345&class=Notepad&left=100&top=-1"
	Then the property "status" in the JSON matches "Failed"

Scenario: Verify [Size Window] is working by sizing NotePad.
	Given I go to "http://127.0.0.1:8777/window/size?key=unit-test-12345&class=Notepad&height=300&width=300"
	Then the property "status" in the JSON matches "OK"
	And the property "h" in the JSON matches "300"
	And the property "w" in the JSON matches "300"

Scenario: Verify [size Window] fails if <10px (too low).
	Given I go to "http://127.0.0.1:8777/window/size?key=unit-test-12345&class=Notepad&height=1&width=1"
	Then the property "status" in the JSON matches "Failed"

