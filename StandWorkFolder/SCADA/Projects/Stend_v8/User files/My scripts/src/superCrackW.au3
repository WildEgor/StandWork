#include <Constants.au3>
#include <GUIConstantsEx.au3>
#include <Timers.au3>
#include <AutoItConstants.au3>

;Global $PathApp1 = "C:\Program Files\Cogent\Cogent DataHub\"
;Global $NameApp1 = "CogentDataHub.exe"
;Global $PathApp2 = "C:\Program Files (x86)\Simple-Scada 2\"
;Global $NameApp2 = "Server.exe"

Global $PathApp1 = "C:\Program Files\SimpleScada2\"
Global $NameApp1 = "Client.exe"
Global $PathApp2 = "C:\Program Files\SimpleScada2\"
Global $NameApp2 = "Server.exe"

Global $App1Window = "no valid license"
Global $App1WindowEnd = "Cogent DataHub"
Global $App2Window = "Simple-Scada Server"
Global $App2WindowEnd = "Время вышло"

;Global $App1Window = "no valid license"
;Global $App1WindowEnd = "Cogent DataHub"
;Global $App2Window = "Simple-Scada Server"
;Global $App2WindowEnd = "Время вышло"

Global $TimeApp1 = 0.1 ; in min test
Global $Timer1 ; close after run

Global $aMes = ""
Global $App1isRun = false
Global $App2isRun = false
Global $hGUI

Main()

Func Main()
   ; Create a GUI with various controls.
   $hGUI = GUICreate("Example")
   Local $idOK = GUICtrlCreateButton("OK", 310, 370, 85, 25)

   ; Display the GUI.
   GUISetState(@SW_SHOW, $hGUI)

   $aMes  = "Setup start..."
   GUICtrlCreateLabel($aMes, 30, 10)

   WinSetState("Example", "", @SW_HIDE)

   While 1
	  GUICtrlCreateLabel($aMes, 30, 10)
	  Switch GUIGetMsg()
	  Case $GUI_EVENT_CLOSE, $idOK
		 $aMes = "Close app.."
		 ExitLoop
	  EndSwitch

	  if ($App1isRun or $App2isRun) Then
		 if WinExists($App1Window) then
			CloseWind($App1Window)
		 EndIf
		 if WinExists($App2Window) then
			CloseWind($App2Window)
		 EndIf
		 if WinExists($App1WindowEnd) then
			CloseWind($App1WindowEnd)
			$App1isRun = false
		 EndIf
		 if WinExists($App2WindowEnd) then
			CloseWind($App2WindowEnd)
			$App2isRun = false
		 EndIf


		 $aMes = "Start count down timer to restart..."
		 Sleep(5000)
		 $App1isRun = false;
		 $App2isRun = false;
		 ;If @error Or $Timer1 = 0 Then ContinueLoop
	  EndIf

	  if ($App1isRun = false) then
		 $aMes = "Running app1 now..."
		 $App1isRun = RunApps($PathApp1, $NameApp1)
	  EndIf

	  if ($App2isRun = false) then
		 $aMes = "Running app2 now..."
		 $App2isRun = RunApps($PathApp2, $NameApp2)
	  EndIf
		 ;$Timer1 = _Timer_SetTimer($hGUI, $TimeApp1*60000, "_Close")
   WEnd
   GUIDelete($hGUI)
EndFunc

Func _Close($hWnd, $iMsg, $iIDTimer, $iTime)
   CloseApps($NameApp1)
   CloseApps($NameApp2)
   $App1isRun = False
EndFunc

Func RunApps($Path, $name)
   if ProcessExists($name) Then
	  $aMes = "App is run!"
	  return True
   Else
	  ;_Timer_KillTimer($hGUI, $Timer1)
	  $aMes = "Running app..."
	  Run($Path&$name)
	  Sleep(2000)
	  WinWait($name, "", 5)
	  if ProcessExists($name) then
		 return True
	  Else
		 return False
	  EndIf
   EndIf
EndFunc

Func CloseApps($name)
   ProcessClose($name)
EndFunc

Func CloseWind($appname)
   Local $hWnd = WinWait($appname, "", 5)
   WinClose($hWnd)
EndFunc