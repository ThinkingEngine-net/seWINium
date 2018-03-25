Feature: Testing Ini Reading Function

Scenario: Fail because of missing ini file.
	Given I go to "http://127.0.0.1:8777/ini/read?key=unit-test-12345"
	Then the property "status" in the JSON matches "Failed"
	And the property "message" in the JSON matches "ini filename is invalid."

Scenario: Fail because of missing section.
	Given I go to "http://127.0.0.1:8777/ini/read?key=unit-test-12345&ini=c%3A%5Cwindows%5Cmain.ini"
	Then the property "status" in the JSON matches "Failed"
	And the property "message" in the JSON matches "section is invalid."

Scenario: Fail because of missing ini key.
	Given I go to "http://127.0.0.1:8777/ini/read?key=unit-test-12345&ini=c%3A%5Cwindows%5Cmain.ini&section=StartupManager"
	Then the property "status" in the JSON matches "Failed"
	And the property "message" in the JSON matches "inikey is invalid."

Scenario: Fail because of ini file does not exist.
	Given I go to "http://127.0.0.1:8777/ini/read?key=unit-test-12345&ini=c%3A%5Cwindows%5Cxxmain.ini&section=StartupManager&inikey=DescLastCheckTime"
	Then the property "status" in the JSON matches "Failed"
	And the property "message" in the JSON matches "Ini file does not exist."

Scenario: Fail because section does not exist.
	Given I go to "http://127.0.0.1:8777/ini/read?key=unit-test-12345&ini=c%3A%5Cwindows%5Cmain.ini&section=StartupManagerx&inikey=DescLastCheckTime"
	Then the property "status" in the JSON matches "Failed"
	And the property "message" in the JSON matches "Ini section does not exist."

Scenario: Fail because key does not exist.
	Given I go to "http://127.0.0.1:8777/ini/read?key=unit-test-12345&ini=c%3A%5Cwindows%5Cmain.ini&section=StartupManager&inikey=xDescLastCheckTime"
	Then the property "status" in the JSON matches "Failed"
	And the property "message" in the JSON matches "Ini file does not have key."

Scenario: Verify Ini Read is working.
	Given I go to "http://127.0.0.1:8777/ini/read?key=unit-test-12345&ini=c%3A%5Cwindows%5Cmain.ini&section=StartupManager&inikey=DescLastCheckTime"
	Then the property "status" in the JSON matches "OK"
	And the property "message" in the JSON matches "Read ini key [DescLastCheckTime] in [StartupManager]."
	And the property "type" in the JSON matches "String"