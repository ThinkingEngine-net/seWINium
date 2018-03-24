#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         Mark Marshall

 Script Function:
	File Location and Management functions

#ce ----------------------------------------------------------------------------

#include <APIShellExConstants.au3>
#include <WinAPIShellEx.au3>


; ------ Proces Path
func FilesResolvePath($path)

	$newpath = StringLower($path)

	; -- process special folder
	; -- See https://www.autoitscript.com/autoit3/docs/macros/Directory.htm

	if (StringLeft($newpath,1)=="@") Then // Macro Path
		$macroEndsAt = StringInStr($newpath,"\")
		if ($macroEndsAt>3) Then ; Must have at least on character
			$macro=StringLeft($path, $macroEndsAt-1)

			if (@macro=="@sewinium") Then
				$newpath=@ScriptDir&StringMid($newpath,$macroEndsAt) ;Use executing Path

			ElseIf (IsDeclared($macro)==1) then
				$path = Eval($macro) ; Process Var

				$newpath=$path&StringMid($newpath,$macroEndsAt) ; Ammend Path

			EndIf
		EndIf
	EndIf


	return $newPath


EndFunc
