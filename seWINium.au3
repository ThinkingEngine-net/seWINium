#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Res_Description=seWINium Test Driver
#AutoIt3Wrapper_Res_Fileversion=0.0.0.38
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=(c) 2017 logic-worx.com
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 Author:         Mark Marshall

 Script Function:
	Windows GUI Test Driver (HTP Driven)

#ce ----------------------------------------------------------------------------

; --- Init

WriteLineToConsole("seWINium Windows GUI Test Driver")

Dim $IP = "127.0.0.1" ; only on local host
Dim $Port = 8777 ; the listening port

;--- Read Secuity Key (Passphrase)

Global $gSecKey=""

$gSecKey=RegRead("HKEY_CURRENT_USER\software\logic-worx\sewinium","key");

if (@error<>0) Then
	$gSecKey=""
EndIf

;--- Process Command Line

if ($CmdLine[0]>0) Then
	for $n =1 to $CmdLine[0]
		$cmd = StringLower($CmdLine[$n])

		if ($cmd="-help" or $cmd="-h") Then
			WriteLineToConsole("seWINium driver help.")
			WriteLineToConsole("Version "&FileGetVersion(@ScriptFullPath)&" (AutoIt "&@AutoItVersion&").")
			WriteLineToConsole("   -h | -help :: Show this help")
			WriteLineToConsole("   -port=[port] :: Set the port that will be used.  Default is 8777.")
			WriteLineToConsole("   -key=[passphrase] | Sets the passphase that will be required to accept commands.")
			WriteLineToConsole("   -keygen :: Gerate a passphrase that will be required to accept commands.")
			WriteLineToConsole("   -keyshow :: Show the currently set passphrase that will be required to accept commands.")
			Exit 0
		elseif (StringInStr($cmd,"-port=")==1) Then
			$Port=Number(stringmid($cmd,7))
		elseif ($cmd="-keyshow") Then
			WriteLineToConsole("The key (PassPhrase) is '"&$gSecKey&"'.")
		elseif ($cmd="-keygen") Then
			$gSecKey=uuid();
			RegWrite("HKEY_CURRENT_USER\software\logic-worx\sewinium","key","REG_SZ",$gSecKey );
			WriteLineToConsole("The key (PassPhrase) has been set to '"&$gSecKey&"'.")
		elseif (StringInStr($cmd,"-key=")==1) Then
			$gSecKey=stringmid($cmd,6);
			RegWrite("HKEY_CURRENT_USER\software\logic-worx\sewinium","key","REG_SZ",$gSecKey );
			WriteLineToConsole("The key (PassPhrase) has been set to '"&$gSecKey&"'.")
		EndIf

	Next

EndIf

WriteLineToConsole("Starting to create server..")

Dim $sRootDir = @ScriptDir & "\www\" ; The absolute path to the root directory of the server.



Dim $Max_Users = 15

Dim $Socket[$Max_Users]
Dim $Buffer[$Max_Users]
$Socket[0] = -1

TCPStartup()

$MainSocket = TCPListen($IP,$Port) ;create main listening socket
If @error Then
    WriteLineToConsole("Unable to create a socket on port " & $Port & ". Shutting Down...")
    Exit
EndIf
WriteLineToConsole("Listening on "&$IP&":"&$Port)


While 1
    Sleep(10)

    $NewSocket = TCPAccept($MainSocket)
    If $NewSocket >= 0 Then
        For $x = 0 to UBound($Socket)-1
            If $Socket[$x] = -1 Then
                $Socket[$x] = $NewSocket ;store the new socket
                ExitLoop
            EndIf
        Next
    EndIf


    For $x = 0 to UBound($Socket)-1 ; loop to receive data from all sockets
        If $Socket[$x] = -1 Then ContinueLoop
        $NewData = TCPRecv($Socket[$x],1024)
        If @error Then
            $Socket[$x] = -1
            ContinueLoop
        ElseIf $NewData Then ; data received
            $Buffer[$x] &= $NewData ;store it in the buffer
            If StringInStr(StringStripCR($Buffer[$x]),@LF&@LF) Then
                $FirstLine = StringLeft($Buffer[$x],StringInStr($Buffer[$x],@LF))
                $RequestType = StringLeft($FirstLine,StringInStr($FirstLine," ")-1)
                If $RequestType = "GET" Then
                    $Request = StringTrimRight(StringTrimLeft($FirstLine,4),11)
					;SendJSONResponse($request, "OK","No Action Taken","x=1",$Socket[$x]);
					;SendError(500, "Command not supported.", $Socket[$x]);
                    ;WriteLineToConsole("Rcvd Request: "&$Request);
					ExecutCommand($request,$Socket[$x])
                ElseIf $RequestType = "POST" Then
					SendError(500, "POST not supported.", $Socket[$x]);
                EndIf
                $Buffer[$x] = ""
                TCPCloseSocket($Socket[$x])
                $Socket[$x] = -1
            EndIf
        EndIf
    Next
WEnd

Func WriteLineToConsole($message)
	ConsoleWrite($message&@CRLF);
EndFunc

Func SendJSONResponse($command,$status, $message,$rawJSON,$sSocket)

	if ($rawJSON=="") Then
		$rawJSON="'placeholder':''";
	EndIf

	$JSON = "{ 'status': '"&$status&"', 'message': '"&$message&"', 'command': '"&$command&"', 'data': {"&$rawJSON&"}}"
	$JSON=StringReplace($JSON,"'",'"')

    $iLen = StringLen($JSON)
    $sPacket = Binary("HTTP/1.1 200 OK" & @CRLF & _
    "Server: seWINium Driver/1.0 (" & @OSVersion & ") " & @AutoItVersion & @CRLF & _
    "Connection: close" & @CRLF & _
    "Content-Lenght: " & $iLen & @CRLF & _
    "Content-Type: application/json" & @CRLF & _
    @CRLF & _
    $JSON)
    $sSplit = StringSplit($sPacket,"")
    $sPacket = ""
    For $i = 1 to $sSplit[0]
        If Asc($sSplit[$i]) <> 0 Then ; Just make sure we don't send any null bytes, because they show up as ???? in your browser.
            $sPacket = $sPacket & $sSplit[$i]
        EndIf
    Next
    TCPSend($sSocket,$sPacket)
EndFunc

Func SendHTML($sHTML,$sSocket)
    $iLen = StringLen($sHTML)
    $sPacket = Binary("HTTP/1.1 200 OK" & @CRLF & _
    "Server: seWINium Driver/1.0 (" & @OSVersion & ") " & @AutoItVersion & @CRLF & _
    "Connection: close" & @CRLF & _
    "Content-Lenght: " & $iLen & @CRLF & _
    "Content-Type: text/html" & @CRLF & _
    @CRLF & _
    $sHTML)
    $sSplit = StringSplit($sPacket,"")
    $sPacket = ""
    For $i = 1 to $sSplit[0]
        If Asc($sSplit[$i]) <> 0 Then ; Just make sure we don't send any null bytes, because they show up as ???? in your browser.
            $sPacket = $sPacket & $sSplit[$i]
        EndIf
    Next
    TCPSend($sSocket,$sPacket)
EndFunc

Func SendFile($sAddress, $sType, $sSocket)
    $File = FileOpen($sAddress,16)
    $sImgBuffer = FileRead($File)
    FileClose($File)

    $Packet = Binary("HTTP/1.1 200 OK" & @CRLF & _
    "Server: seWINium Driver/1.0 (" & @OSVersion & ") " & @AutoItVersion & @CRLF & _
    "Connection: close" & @CRLF & _
    "Content-Type: " & $sType & @CRLF & _
    @CRLF)
    TCPSend($sSocket,$Packet)

    While BinaryLen($sImgbuffer) ;LarryDaLooza's idea to send in chunks to reduce stress on the application
        $a = TCPSend($sSocket,$sImgbuffer)
        $sImgbuffer = BinaryMid($sImgbuffer,$a+1,BinaryLen($sImgbuffer)-$a)
    WEnd

    $Packet = Binary(@CRLF & _
    @CRLF)
    TCPSend($sSocket,$Packet)
    TCPCloseSocket($sSocket)
EndFunc

Func SendError($errCode, $sHTML, $sSocket)
     $iLen = StringLen($sHTML)
    $sPacket = Binary("HTTP/1.1 "&$errCode&" OK" & @CRLF & _
    "Server: seWINium Driver/1.0 (" & @OSVersion & ") " & @AutoItVersion & @CRLF & _
    "Connection: close" & @CRLF & _
    "Content-Lenght: " & $iLen & @CRLF & _
    "Content-Type: text/html" & @CRLF & _
    @CRLF & _
    $sHTML)
    $sSplit = StringSplit($sPacket,"")
    $sPacket = ""
    For $i = 1 to $sSplit[0]
        If Asc($sSplit[$i]) <> 0 Then ; Just make sure we don't send any null bytes, because they show up as ???? in your browser.
            $sPacket = $sPacket & $sSplit[$i]
        EndIf
    Next
    TCPSend($sSocket,$sPacket)
EndFunc

Func _Get_Post($s_Buffer)
    Local $s_Temp_Post,$s_Post_Data
    Local $Temp, $s_Struct, $s_Len

    ;Get the lenght of the data in the POST
    $s_Temp_Post = StringTrimLeft($s_Buffer,StringInStr($s_Buffer,'Content-Length:'))
    $s_Len = StringTrimLeft($s_Temp_Post,StringInStr($s_Temp_Post,': '))

    ;Create the base struck
    $s_Post_Data = StringSplit(StringRight($s_Buffer,$s_Len),'&')
    For $t = 1 To $s_Post_Data[0]
        $Temp = StringSplit($s_Post_Data[$t],'=')
        $s_Struct &= 'char ' & $Temp[1] & '[' & StringLen($Temp[2])+1 & '];'
    Next
    $s_Temp_Post = DllStructCreate($s_Struct)

    ;add the data to the struck
    For $t = 1 To $s_Post_Data[0]
        $Temp = StringSplit($s_Post_Data[$t],'=')
        DllStructSetData($s_Temp_Post,$Temp[1],$Temp[2])
    Next

    Return $s_Temp_Post
EndFunc

func ExecutCommand($command, $sSocket)
	; --- Seprate command and parameters.
	$cmdEle = StringSplit($command,"?")
	$func=$cmdEle[1]
	$param=""
	if (UBound($cmdEle)==3) Then
		$param=$cmdEle[2]
	EndIf

	if (StringLen($func)<2) Then
		SendError(500, "You must specific a command.", $Socket[$x]);
		return
	EndIf

	; --- Validate Key

	$params=buildParamArray($param);
	$key=GetParamFromArray($params,"key");

	if (@error<>0 or $key<> $gSecKey) Then
		SendError(500, "You must specific the correct key (passphrase) as a parameter.", $Socket[$x]);
		return
	EndIf


	; --- Call command

	$func="WF"&StringLower(StringReplace($func,"/","_")); Map to funciton name and sub paths
	$func=$func&"($params,"&$sSocket&")"


	WriteLineToConsole("------------------------")
	WriteLineToConsole("Command: "&$func)



	$return=Execute($func)
	if (@error <>0) Then
		SendError(500, "Command Not supported.", $Socket[$x]);
		return
	EndIf
EndFunc

func buildParamArray($param)


	dim $ta[1][2]
	$ta[0][0]="";
	$ta[0][1]="";
	$pos=0;

	if (StringInStr($param,"=")<1) Then
			SetError(-1,0,$ta)
	EndIf

	$params = StringSplit($param,"&");

	for $n=1 to $params[0]
		$values = StringSplit($params[$n],"=");
		if ($values[0]==2) Then
			redim $ta[$pos+1][2]

			$ta[$pos][0]=StringLower($values[1])
			$ta[$pos][1]=URIDecode($values[2])

			$pos+=1
		EndIf
	Next
	return $ta;
EndFunc

Func GetParamFromArray($params,$var)
    for $n= 0 to UBound($params)-1
		if ($params[$n][0]==$var) Then
			return $params[$n][1]
		EndIf
	Next

	SetError(-1,0,"")

EndFunc


Func URIDecode($sData)
    ; Prog@ndy
    Local $aData = StringSplit(StringReplace($sData,"+"," ",0,1),"%")
    $sData = ""
    For $i = 2 To $aData[0]
        $aData[1] &= Chr(Dec(StringLeft($aData[$i],2))) & StringTrimLeft($aData[$i],2)
    Next
    Return BinaryToString(StringToBinary($aData[1],1),4)
EndFunc



Func URIEncode($urlText)
    $url = ""
    For $i = 1 To StringLen($urlText)
        $acode = Asc(StringMid($urlText, $i, 1))
        Select
            Case ($acode >= 48 And $acode <= 57) Or _
                    ($acode >= 65 And $acode <= 90) Or _
                    ($acode >= 97 And $acode <= 122)
                $url = $url & StringMid($urlText, $i, 1)
            Case $acode = 32
                $url = $url & "+"
            Case Else
                $url = $url & "%" & Hex($acode, 2)
        EndSelect
    Next
    Return $url
EndFunc   ;==>URLEncode

Func uuid()
    Return StringFormat('%04x%04x-%04x-%04x-%04x-%04x%04x%04x', _
            Random(0, 0xffff), Random(0, 0xffff), _
            Random(0, 0xffff), _
            BitOR(Random(0, 0x0fff), 0x4000), _
            BitOR(Random(0, 0x3fff), 0x8000), _
            Random(0, 0xffff), Random(0, 0xffff), Random(0, 0xffff) _
        )
EndFunc


; *********************** Basiuc Functions *****************
;***********************************************************
;***********************************************************
;***********************************************************


; ------- Return about data (JSON)
func WF_about($params, $sSocket)

	$json="'driver':'seWINium Driver','version': '"&@AutoItVersion&"'"
	SendJSONResponse("about","OK","",$json,$sSocket)


EndFunc

;-------------- Tests Parameter Decoding (HTML) - Debuug Funciton

func WF_debug_paramtest($params, $sSocket)

	;$params=buildParamArray($params);

	$html="<body><h1>Parameter Decoding Tester</h1><p><ul>"

	for $n=0 to UBound($params)-1
		 $html&="<li>"&$params[$n][0]&" :: "&$params[$n][1]&"</li>"

	Next

	$html&="</ul></p></body>"

	SendHTML($html,$sSocket);


EndFunc

;-------------- Tests Parameter Decoding and locating (HTML) - Debuug Funciton

func WF_debug_paramtest_findwindowparam($params, $sSocket)

	;$params=buildParamArray($params);

	$html="<body><h1>Parameter Decoding Tester</h1><p><ul>"

	for $n=0 to UBound($params)-1
		 $html&="<li>"&$params[$n][0]&" :: "&$params[$n][1]&"</li>"

	Next

	$html&="</ul></p><p>"

	$win=GetParamFromArray($params,"window");
	if (@error<>0) Then
		$html&="Could not locate the window parameter!"
	Else
		$Html&="The window parameter is '"&$win&"'"
	EndIf

	$html&="</p></body>"
	SendHTML($html,$sSocket);


EndFunc

; ---------------------------- Function Librabries

#include "functions\WindowManagement.au3"
#include "functions\Registry.au3"
#include "functions\ini.au3"