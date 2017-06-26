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

	;$params=buildParamArray($params); -- Decode Parmes

	$class=win_buildClassFromParams($params)

	$handle=WinGetHandle($class);

	if (@error<>0) Then
		SendJSONResponse("Window/Find :: "&$class,"Failed","Window not located.","",$sSocket)
		Return
	EndIf

	$title = WinGetTitle($handle)

	$json="'handle':'"&$handle&"','title':'"&$title&"'"
	SendJSONResponse("Window/Find :: "&$class,"OK","",$json,$sSocket)


EndFunc


; ----- Flash window

func WF_window_flash($params, $sSocket)

	;$params=buildParamArray($params); -- Decode Parmes

	$handle=0
	$class=""

	$handle = win_getHWND($params)

	if (@error==-1 or $handle==0) Then
		$class=win_buildClassFromParams($params)
		$handle=WinGetHandle($class)
	EndIf


	if (not WinExists($handle)) Then
		SendJSONResponse("Window/Flash :: "&$class& "/ Handle: "&$handle,"Failed","Window not located.","",$sSocket)
		Return
	EndIf

	WinFlash(HWnd($handle))

	$json=""
	SendJSONResponse("Window/Flash :: "&$class& "/ Handle: "&$handle,"OK","Window Flashed.",$json,$sSocket)


EndFunc

; ----- Move Window

func WF_window_move($params, $sSocket)

	;$params=buildParamArray($params); -- Decode Parmes

	$handle=0
	$class=""

	$handle = win_getHWND($params)

	if (@error==-1 or $handle==0) Then
		$class=win_buildClassFromParams($params)
		$handle=WinGetHandle($class)
	EndIf


	if (not WinExists($handle)) Then
		SendJSONResponse("Window/Move :: "&$class& "/ Handle: "&$handle,"Failed","Window not located.","",$sSocket)
		Return
	EndIf

	$winX=Number(GetParamFromArray($params,"left"))
	$winY=Number(GetParamFromArray($params,"top"))
	$winW=Number(GetParamFromArray($params,"width"))
	$winH=Number(GetParamFromArray($params,"height"))

	if ($winX<0 or $winX>@DesktopWidth-1) Then
		SendJSONResponse("Window/Move :: "&$class& "/ Handle: "&$handle,"Failed","Window cannot moved outside of desktop [x].","",$sSocket)
		Return
	EndIf

	if ($winY<0 or $winY>@DesktopHeight-1) Then
		SendJSONResponse("Window/Move :: "&$class& "/ Handle: "&$handle,"Failed","Window cannot moved outside of desktop [y].","",$sSocket)
		Return
	EndIf

	if ($winW<10 or $winH<10) then
		WinMove(HWnd($handle),"",$winX,$winY)

		$json="'x':'"&$winX&"', 'y':'"&$winY&"'"
		SendJSONResponse("Window/Move :: "&$class& "/ Handle: "&$handle,"OK","Window Moved.",$json,$sSocket)
	Else
		WinMove(HWnd($handle),"",$winX,$winY,$winW,$winH)

		$json="'x':'"&$winX&"', 'y':'"&$winY&"', 'w':'"&$winW&"', 'h':'"&$winH&"'"
		SendJSONResponse("Window/Move :: "&$class& "/ Handle: "&$handle,"OK","Window Resized.",$json,$sSocket)
	endif





EndFunc

func WF_window_size($params, $sSocket)

	;$params=buildParamArray($params); -- Decode Parmes

	$handle=0
	$class=""

	$handle = win_getHWND($params)

	if (@error==-1 or $handle==0) Then
		$class=win_buildClassFromParams($params)
		$handle=WinGetHandle($class)
	EndIf


	if (not WinExists($handle)) Then
		SendJSONResponse("Window/Move :: "&$class& "/ Handle: "&$handle,"Failed","Window not located.","",$sSocket)
		Return
	EndIf

	$winPOs=WinGetPos(HWnd($handle))

	$winX=$winPos[0]
	$winY=$winPos[1]
	$winW=Number(GetParamFromArray($params,"width"))
	$winH=Number(GetParamFromArray($params,"height"))

	if ($winW<10 or $winH<10) then
		SendJSONResponse("Window/MSize :: "&$class& "/ Handle: "&$handle,"Failed","Window cannot sized smaller than 10px x 10px.","",$sSocket)
		Return
	Else
		WinMove(HWnd($handle),"",$winX,$winY,$winW,$winH)

		$json="'x':'"&$winX&"', 'y':'"&$winY&"', 'w':'"&$winW&"', 'h':'"&$winH&"'"
		SendJSONResponse("Window/Move :: "&$class& "/ Handle: "&$handle,"OK","Window Resized.",$json,$sSocket)
	endif





EndFunc


