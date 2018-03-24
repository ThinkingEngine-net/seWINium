Feature: Testing Registry Reading Function

Scenario: Fail because of missing registry key.
	Given I go to "http://127.0.0.1:8777/registry/read?key=unit-test-12345"
	Then the property "status" in the JSON matches "Failed"
	And the property "message" in the JSON matches "Registry key is invalid."

Scenario: Fail because of missing registry value.
	Given I go to "http://127.0.0.1:8777/registry/read?key=unit-test-12345&regkey=dummykey"
	Then the property "status" in the JSON matches "Failed"
	And the property "message" in the JSON matches "Registry value is invalid."

Scenario: Fail because of registry key does not exist.
	Given I go to "http://127.0.0.1:8777/registry/read?key=unit-test-12345&regkey=dummykey&regvalue=dummyvalue"
	Then the property "status" in the JSON matches "Failed"
	And the property "message" in the JSON matches "Registry key [dummykey] is not found."

Scenario: Fail because of registry value does not exist.
	Given I go to "http://127.0.0.1:8777/registry/read?key=unit-test-12345&regkey=HKEY_CURRENT_USER%5CSoftware%5CMicrosoft%5CWindows%5CCurrentVersion%5CWindowsUpdate&regvalue=dummyvalue"
	Then the property "status" in the JSON matches "Failed"
	And the property "message" in the JSON matches "Registry Value [dummyvalue] not fouund in [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\WindowsUpdate]."

Scenario: Verify Registry Read is working.
	Given I go to "http://127.0.0.1:8777/registry/read?key=unit-test-12345&regkey=HKEY_CURRENT_USER%5CSoftware%5CMicrosoft%5CWindows%5CCurrentVersion%5CWindowsUpdate&regvalue=LastAutoAppUpdateSearchSuccessTime"
	Then the property "status" in the JSON matches "OK"
	And the property "message" in the JSON matches "Read registry Value [LastAutoAppUpdateSearchSuccessTime] in [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\WindowsUpdate]."
	And the property "type" in the JSON matches "String"