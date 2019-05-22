#cs ----------------------------------------------------------------------------

 Author:         Mark Marshall

 Script Function:
	seWINium Driver : Control Funcitons

#ce ----------------------------------------------------------------------------


#cs ----------------------------------------------------------------------------
	Helper Functions
#ce ----------------------------------------------------------------------------

func ctrl_getClassFromParams($params,$class)
	$value=GetParamFromArray($params,StringLower($class))
	if (@error<>0) Then
		return ""
	EndIf

	return StringUpper($class)&":"&$value&";"

EndFunc

func ctrl_buildClassFromParams($params)

	$class="["

	$class&=ctrl_getClassFromParams($params,"name")
	$class&=ctrl_getClassFromParams($params,"text")
	$class&=ctrl_getClassFromParams($params,"class")
	$class&=ctrl_getClassFromParams($params,"classnn")
	$class&=ctrl_getClassFromParams($params,"regexpclass")
	$class&=ctrl_getClassFromParams($params,"x")
	$class&=ctrl_getClassFromParams($params,"y")
	$class&=ctrl_getClassFromParams($params,"w")
	$class&=ctrl_getClassFromParams($params,"h")
	$class&=ctrl_getClassFromParams($params,"instance")

	$class&="]"

	return $class;

EndFunc

func ctrl_getPropsJson($handle,$ctrl)

	$loc = ControlGetPos($Handle,"",$ctrl)


	$json="'ctrlID':'"&$ctrl&"'"
	$json &= ",'width':"&$loc[2]&", 'height':"&$loc[3];
	$json &= ",'X':"&$loc[0]&", 'Y':"&$loc[1];

	$json&= ",'text':'" & URIEncode(ControlGetText($Handle,"",$ctrl)) &"'" ;

	$json&= ",'visible':" &Bool2String(ControlCommand($Handle,"",$ctrl,"IsVisible"));
	$json&= ",'enabled':" &Bool2String(ControlCommand($Handle,"",$ctrl,"IsEnabled"));
	$json&= ",'className':'" &_WinAPI_GetClassName($ctrl) &"'"



	return $json
EndFunc


func ctrl_getID($params)

	$handle = GetParamFromArray($params,"ctrlid")
	if (@error==0) Then
		$hwnd= HWnd($handle)
		if (@error=1) Then
			SetError(-1,0,0)
		EndIf
		return $hwnd
	EndIf

	SetError(-2,0,0)

Endfunc


#cs ----------------------------------------------------------------------------
	Driver Funcitons
#ce ----------------------------------------------------------------------------

; ----- Locate a control

func WF_control_find($params, $sSocket)

	;$params=buildParamArray($params); -- Decode Parmes

	$class=ctrl_buildClassFromParams($params)

	$winHandle=win_getHWND($params);

	if (@error<>0) Then
		SendJSONResponse("Control/Find :: "&$class,"Failed","Window not located.","",$sSocket)
		Return
	EndIf

	$cttl = ControlGetHandle ($winHandle,"",$class)

	if (@error<>0) Then
		SendJSONResponse("Control/Find :: "&$class,"Failed","control not located.","",$sSocket)
		Return
	EndIf


	$json=ctrl_getPropsJson($winHandle, $cttl)


	SendJSONResponse("Control/Find :: "&$class,"OK","",$json,$sSocket)


EndFunc

; ----- Get COntrol With Focus

func WF_control_focus($params, $sSocket)

	;$params=buildParamArray($params); -- Decode Parmes

	$class=ctrl_buildClassFromParams($params)

	$winHandle=win_getHWND($params);;

	if (@error<>0) Then
		SendJSONResponse("Control/Focus :: "&$class,"Failed","Window not located.","",$sSocket)
		Return
	EndIf

	$cttl = ControlGetFocus($winHandle,"")

	if (@error<>0) Then
		SendJSONResponse("Control/Focus :: "&$class,"Failed","control not located.","",$sSocket)
		Return
	EndIf


	$json=ctrl_getPropsJson($winHandle, $cttl)


	SendJSONResponse("Control/Focus :: ","OK","",$json,$sSocket)

EndFunc

func WF_control_update($params, $sSocket)

	;$params=buildParamArray($params); -- Decode Parmes


	$winHandle=win_getHWND($params);

	if (@error<>0) Then
		SendJSONResponse("Control/Update :: "+$winHandle,"Failed","Window not located.","",$sSocket)
		Return
	EndIf

	$cttl = ctrl_getID ($params);;

	if (@error<>0) Then
		SendJSONResponse("Control/Update ::"+$cttl,"Failed","control not located.","",$sSocket)
		Return
	EndIf


	$json=ctrl_getPropsJson($winHandle, $cttl)


	SendJSONResponse("Control/Update ::","OK","",$json,$sSocket)


EndFunc

func WF_control_setfocus($params, $sSocket)

	;$params=buildParamArray($params); -- Decode Parmes

	$class=ctrl_buildClassFromParams($params)

	$winHandle=win_getHWND($params);;


	if (@error<>0) Then
		SendJSONResponse("Control/SetFocus :: ","Failed","Window not located.","",$sSocket)
		Return
	EndIf

	$cttl = ctrl_getID ($params);;

	if (@error<>0) Then
		SendJSONResponse("Control/SetFocus ::"+$cttl,"Failed","control not located.","",$sSocket)
		Return
	EndIf


	$ret = ControlFocus($winHandle,"", $cttl)

	if ($ret=0) Then
		SendJSONResponse("Control/SetFocus :: ","Failed","control could not be focussed.","",$sSocket)
		Return
	EndIf

	SendJSONResponse("Control/SetFocus :: ","OK","","",$sSocket)

EndFunc


func WF_control_settext($params, $sSocket)

	;$params=buildParamArray($params); -- Decode Parmes

	$class=ctrl_buildClassFromParams($params)

	$winHandle=win_getHWND($params);;


	if (@error<>0) Then
		SendJSONResponse("Control/SetText :: ","Failed","Window not located.","",$sSocket)
		Return
	EndIf

	$cttl = ctrl_getID ($params);;

	if (@error<>0) Then
		SendJSONResponse("Control/SetText ::"+$cttl,"Failed","control not located.","",$sSocket)
		Return
	EndIf

	$sTxt = GetParamFromArray($params,"text")


	if (@error<>0) Then
		SendJSONResponse("Control/SetText ::"+$cttl,"Failed","need to specify text.","",$sSocket)
		Return
	EndIf

	$ret = ControlSetText($winHandle,"", $cttl,$sTxt)

	if ($ret=0) Then
		SendJSONResponse("Control/SetText :: ","Failed","control text could not be set.","",$sSocket)
		Return
	EndIf

	SendJSONResponse("Control/SetText :: ","OK","","",$sSocket)

EndFunc

func WF_control_typekeys($params, $sSocket)

	;$params=buildParamArray($params); -- Decode Parmes

	$class=ctrl_buildClassFromParams($params)

	$winHandle=win_getHWND($params);;


	if (@error<>0) Then
		SendJSONResponse("Control/TypeKeys :: ","Failed","Window not located.","",$sSocket)
		Return
	EndIf

	$cttl = ctrl_getID ($params);;

	if (@error<>0) Then
		SendJSONResponse("Control/TypeKeys ::"+$cttl,"Failed","control not located.","",$sSocket)
		Return
	EndIf

	$sTxt = GetParamFromArray($params,"keys")


	if (@error<>0) Then
		SendJSONResponse("Control/TypeKeys ::"+$cttl,"Failed","need to specify keys to type.","",$sSocket)
		Return
	EndIf

	$ret = ControlSend($winHandle,"", $cttl,$sTxt)

	if ($ret=0) Then
		SendJSONResponse("Control/TypeKeys :: ","Failed","control typing failed.","",$sSocket)
		Return
	EndIf

	SendJSONResponse("Control/TypeKeys :: "&$class,"OK","","",$sSocket)

EndFunc

func WF_control_click($params, $sSocket)

	$winHandle=win_getHWND($params);;


	if (@error<>0) Then
		SendJSONResponse("Control/Click :: ","Failed","Window not located.","",$sSocket)
		Return
	EndIf

	$cttl = ctrl_getID ($params);;

	if (@error<>0) Then
		SendJSONResponse("Control/Click ::"+$cttl,"Failed","control not located.","",$sSocket)
		Return
	EndIf

	$butt = GetParamFromArray($params,"button")


	if (@error<>0) Then
		SendJSONResponse("Control/Click ::"+$cttl,"Failed","need to specify a mouse button.","",$sSocket)
		Return
	EndIf

	$sClicks = GetParamFromArray($params,"clicks")

	$clicks =1

	if (@error=0) Then

		$clicks=Number($sClicks)

	EndIf

	$sX = GetParamFromArray($params,"x")

	$x =-1

	if (@error=0) Then

		$x=Number($sX)

	EndIf

	$sY = GetParamFromArray($params,"y")

	$y =-1

	if (@error=0) Then

		$y=Number($sY)

	EndIf



	$ret=0

	if ($x=-1 or $y=-1) then
		$ret = ControlClick($winHandle,"", $cttl,$butt, $clicks)
	Else
		$ret = ControlClick($winHandle,"", $cttl,$butt,$clicks,$x,$y)
	EndIf


	if ($ret=0) Then
		SendJSONResponse("Control/Click :: ","Failed","control Click failed.","",$sSocket)
		Return
	EndIf

	SendJSONResponse("Control/Click :: ","OK","","",$sSocket)

EndFunc



