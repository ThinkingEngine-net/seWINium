#cs ----------------------------------------------------------------------------

 Author:         Mark Marshall

 Script Function:
	seWINium Driver : INI Funcitons

#ce ----------------------------------------------------------------------------


#cs ----------------------------------------------------------------------------
	Helper Functions
#ce ----------------------------------------------------------------------------


func ini_has_section($file, $section)

	Local $aArray = IniReadSectionNames($file)

	if (@error) Then
		return false
	EndIf

	For $i = 1 To $aArray[0]
		if (StringLower($aArray[$i])==StringLower($section)) Then

			return true

		EndIf
	Next

	return False

EndFunc







#cs ----------------------------------------------------------------------------
	Driver Functions
#ce ----------------------------------------------------------------------------

; ----- Read Ini Key

func WF_ini_read($params, $sSocket)

	$file = GetParamFromArray($params,"ini")
	if (@error<>0) Then
		SendJSONResponse("ini/read","Failed","ini filename is invalid.","",$sSocket)
		Return
	EndIf

	$section = GetParamFromArray($params,"section")
	if (@error<>0) Then
		SendJSONResponse("ini/read","Failed","section is invalid.","",$sSocket)
		Return
	EndIf

	$key = GetParamFromArray($params,"inikey")
	if (@error<>0) Then
		SendJSONResponse("ini/read","Failed","inikey is invalid.","",$sSocket)
		Return
	EndIf


	if (not FileExists($file)) Then
		SendJSONResponse("ini/read","Failed","Ini file does not exist.","",$sSocket)
		Return
	EndIf


	if (not ini_has_section($file, $section)) Then
		SendJSONResponse("ini/read","Failed","Ini section does not exist.","",$sSocket)
		Return
	EndIf

	$data = iniRead($file,$section,$key, "$$$-%%--NotFound--%%-$$$")


	if ($data=="$$$-%%--NotFound--%%-$$$") Then
		SendJSONResponse("ini/read","Failed","Ini file does not have key.","",$sSocket)
		Return
	EndIf


	$Type=VarGetType($data)
	$sData=""&$data

	SendJSONResponse("ini/read","OK","Read ini key ["&$key&"] in ["&$section&"].","'type':'"&$Type&"', 'value':'"&$sData&"'",$sSocket)

EndFunc
