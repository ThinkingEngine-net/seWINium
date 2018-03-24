#cs ----------------------------------------------------------------------------

 Author:         Mark Marshall

 Script Function:
	seWINium Driver : INI Funcitons

#ce ----------------------------------------------------------------------------


#cs ----------------------------------------------------------------------------
	Helper Functions
#ce ----------------------------------------------------------------------------









#cs ----------------------------------------------------------------------------
	Driver Functions
#ce ----------------------------------------------------------------------------

; ----- Locate a window

func WF_registry_read($params, $sSocket)

	$file = GetParamFromArray($params,"ini")
	if (@error<>0) Then
		SendJSONResponse("registry/read","Failed","Registry key is invalid.","",$sSocket)
		Return
	EndIf

	$key = GetParamFromArray($params,"key")
	if (@error<>0) Then
		SendJSONResponse("registry/read","Failed","Registry key is invalid.","",$sSocket)
		Return
	EndIf


	$val = GetParamFromArray($params,"inivalue")
	if (@error<>0) Then
		SendJSONResponse("registry/read","Failed","Registry value is invalid.","",$sSocket)
		Return
	EndIf


	$data = RegRead($key, $val)

	$err=@error

	if ($err==1 or $err==2) Then
		SendJSONResponse("registry/read","Failed","Registry key ["&$key&"] is not found.","",$sSocket)
		Return
	EndIf

	if ($err==3) Then
		SendJSONResponse("registry/read","Failed","Remote access to ["&$key&"] failed.","",$sSocket)
		Return
	EndIf

	if ($err==-1) Then
		SendJSONResponse("registry/read","Failed","Registry Value ["&$val&"] not fouund in ["&$key&"].","",$sSocket)
		Return
	EndIf

	if ($err==-2) Then
		SendJSONResponse("registry/read","Failed","Type not supported for registry Value ["&$val&"] not fouund in ["&$key&"].","",$sSocket)
		Return
	EndIf

	$Type=VarGetType($data)
	$sData=""&$data

	SendJSONResponse("registry/read","OK","Read registry Value ["&$val&"] in ["&$key&"].","'type':'"&$Type&"', 'value':'"&$sData&"'",$sSocket)

EndFunc
