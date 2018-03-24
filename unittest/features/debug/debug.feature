## Author: <Your Name>
## Updated : <Date>
## Applies to: <What site/version does it apply to?>

Feature: Debug Features

Scenario: Verify [window has text] is working by searching for About Notepad
	Given I go to "http://127.0.0.1:8777/window/hastext?key=unit-test-12345&text=About%20Notepad&title=sampletext.txt%20-%20Notepad"
	Then the property "status" in the JSON matches "OK"
	And the property "title" in the JSON matches "sampletext.txt - Notepad"

Scenario: Verify I can retrieve the window text
	Given I go to "http://127.0.0.1:8777/window/gettext?key=unit-test-12345&title=sampletext.txt%20-%20Notepad"
	Then the property "status" in the JSON matches "OK"
	And the property "text" in the JSON contains "About+Notepad"