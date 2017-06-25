#cs ----------------------------------------------------------------------------

 Author:         Mark Marshall

 Script Function:
	seWINium Driver : Windows Funcitons

#ce ----------------------------------------------------------------------------


#cs ----------------------------------------------------------------------------
	Helper Functions
#ce ----------------------------------------------------------------------------

func win_getClassFromParams($params,$class)
	$value=GetParamFromArray($params,StringLower($class))
	if (@error<>0) Then
		return ""
	EndIf

	if (StringLower($class)=="active") Then
		return "ACTIVE;"
	EndIf

	if (StringLower($class)=="last") Then
		return "LAST;"
	EndIf

	return StringUpper($class)&":"&$value&";"

EndFunc

func win_buildClassFromParams($params)

	$class="["

	$class&=win_getClassFromParams($params,"title")
	$class&=win_getClassFromParams($params,"active")
	$class&=win_getClassFromParams($params,"last")
	$class&=win_getClassFromParams($params,"class")
	$class&=win_getClassFromParams($params,"regexptitle")
	$class&=win_getClassFromParams($params,"regexpclass")
	$class&=win_getClassFromParams($params,"x")
	$class&=win_getClassFromParams($params,"y")
	$class&=win_getClassFromParams($params,"w")
	$class&=win_getClassFromParams($params,"h")
	$class&=win_getClassFromParams($params,"instance")

	$class&="]"

	return $class;

EndFunc

func win_getHWND($params)

	$handle = GetParamFromArray($params,"handle")
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

; ----- Locate a window

func WF_window_find($params, $sSocket)

	$params=buildParamArray($params); -- Decode Parmes

	$class=win_buildClassFromParams($params)

	$handle=WinGetHandle($class);

	if (@error<>0) Then
		SendJSONResponse("Window/Flash :: "&$class,"Failed","Window not located.","",$sSocket)
		Return
	EndIf

	$title = WinGetTitle($handle)

	$json="'handle':'"&$handle&"','Title':'"&$title&"'"
	SendJSONResponse("Window/Flash :: "&$class,"OK","",$json,$sSocket)


EndFunc


; ----- Locate a window

func WF_window_flash($params, $sSocket)

	$params=buildParamArray($params); -- Decode Parmes

	$handle=0
	$class=""

	$handle = win_getHWND($params)

	if (@error==-1) Then
		$class=win_buildClassFromParams($params)
		$handle=WinGetTitle($class)
	EndIf


	if (not WinExists($handle)) Then
		SendJSONResponse("Window/Flash :: "&$class& "/ Handle: "&$handle,"Failed","Window not located.","",$sSocket)
		Return
	EndIf

	WinFlash(HWnd($handle))

	$json=""
	SendJSONResponse("Window/Find :: "&$class& "/ Handle: "&$handle,"OK","Window Flashed.",$json,$sSocket)


EndFunc

