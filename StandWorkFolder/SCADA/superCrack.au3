#include <Constants.au3>
#include <GUIConstantsEx.au3>
#include <Timers.au3>
#include <AutoItConstants.au3>

Global $PathApp1 = "C:\Program Files\Cogent\Cogent DataHub\CogentDataHub.exe"
Global $NameApp1 = "CogentDataHub"
Global $PathApp2 = "C:\Users\STAND\Documents\Simple-Scada2\Server.exe"
Global $NameApp2 = "Server"

Global $App1Window = "no valid license"
Global $App2Window = "Время вышло"

Global $TimeApp1 = 2 ; in sec
Global $TimeApp2 = 3 ; in sec
Global $Timer1 ; reset start popup
Global $Timer2 ; close after run delay

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
   GUICtrlCreateLabel(String($aMes), 30, 10)
   $App1isRun = RunApps($PathApp1, $NameApp1)
   $Timer1 = _Timer_SetTimer($hGUI, 200, "_Update")


   Sleep(100)

   While 1
	  GUICtrlCreateLabel($aMes, 30, 10)
	  Switch GUIGetMsg()
	  Case $GUI_EVENT_CLOSE, $idOK
		 $aMes = "Close app.."
		 Sleep(1000)
		 ExitLoop
	  EndSwitch

	  if ($App1isRun) Then
		 $aMes = "Start count down timer to restart..."
		 If @error Or $Timer2 = 0 Then ContinueLoop
		 _Timer_KillTimer($hGUI, $Timer1)
		 Sleep(100)
		 Else
		 $aMes = "Running app now..."
		 $App1isRun = RunApps($PathApp1, $NameApp1)
		 _Timer_KillTimer($hGUI, $Timer2)
		 Sleep(1000)
		 $App1isRun = RunApps($PathApp1, $NameApp1)
		 $Timer1 = _Timer_SetTimer($hGUI, 200, "_Update")
		 If @error Or $Timer1 = 0 Then ContinueLoop
	  EndIf
   WEnd
   GUIDelete($hGUI)
EndFunc

Func _Update($hWnd, $iMsg, $iIDTimer, $iTime)
   #forceref $hWnd, $iMsg, $iIDTimer, $iTime
   if WinExists($App1Window) then
	  CloseWind($App1Window)
   EndIf
EndFunc

Func _Close($hWnd, $iMsg, $iIDTimer, $iTime)
   CloseApps($NameApp1)
   $App1isRun = False
EndFunc

Func RunApps($Path, $name)
   if (ProcessExists($name&".exe")) Then
	  $aMes = "App is run!"
	  Sleep(100)
	  $Timer2 = _Timer_SetTimer($hGUI, 30000, "_Close")
	  return True
   Else
	  $aMes = "Running app..."
	  Run($Path)
	  WinWait($name, "", 5)
	  Sleep(100)
	  return False
   EndIf
EndFunc

Func CloseApps($name)
   ProcessClose($name&".exe")
EndFunc

Func CloseWind($appname)
   Local $hWnd = WinWait($appname, "", 5)
   WinClose($hWnd)
EndFunc