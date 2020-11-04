#include <Constants.au3>
#include <GUIConstantsEx.au3>
#include <Timers.au3>
#include <AutoItConstants.au3>

Global $PathApp1 = "C:\Program Files\Cogent\Cogent DataHub\"
Global $NameApp1 = "CogentDataHub.exe"
Global $PathApp2 = "C:\Program Files (x86)\Simple-Scada 2\"
Global $NameApp2 = "Server.exe"

Global $App1Window = "no valid license"
Global $App2Window = "Время вышло"

Global $TimeApp1 = 0.5 ; in min
Global $Timer1 ; close after run delay

Global $aMes = ""
Global $App1isRun = false
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

   While 1
	  GUICtrlCreateLabel($aMes, 30, 10)
	  Switch GUIGetMsg()
	  Case $GUI_EVENT_CLOSE, $idOK
		 $aMes = "Close app.."
		 Sleep(1000)
		 ExitLoop
	  EndSwitch

	  if ($App1isRun) Then
		 if WinExists($App1Window) then
			CloseWind($App1Window)
		 EndIf
		 if WinExists($App2Window) then
			CloseWind($App2Window)
		 EndIf
		 $aMes = "Start count down timer to restart..."
		 Sleep(1000)
		 If @error Or $Timer1 = 0 Then ContinueLoop
		 Else
		 $aMes = "Running app now..."
		 $App1isRun = RunApps($PathApp1, $NameApp1)
		 RunApps($PathApp2, $NameApp2)
		 $Timer1 = _Timer_SetTimer($hGUI, $TimeApp1*60000, "_Close")
	  EndIf
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
	  _Timer_KillTimer($hGUI, $Timer1)
	  $aMes = "Running app..."
	  Run($Path&$name)
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