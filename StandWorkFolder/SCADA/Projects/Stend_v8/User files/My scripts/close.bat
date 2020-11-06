@echo off
SETLOCAL EnableDelayedExpansion

set StandPCPath=C:\Users\STAND\Documents\SimpleScada2\Projects\Stend_v8\User files\My Scripts\
set WorkPCPath=C:\SCADA\Projects\Stend_v8\User files\My scripts\
set ProgramStandPC=superCrackW.exe
set ProgramWorkPC=superCrack.exe

set ScriptPath=%~dp0
set ScriptName=%~nx0

echo.ScriptPath is: %ScriptPath%
echo.WorkPCPath is: %WorkPCPath%

if "%WorkPCPath%" == "%ScriptPath%" (CALL :CloseScript %ProgramWorkPC%)
if "%StandPCPath%" == "%ScriptPath%" (CALL :CloseScript %ProgramStandPC%)

pause 

:CloseScript
set EXEC_CMD=%~1
echo.CloseApp is: %~1
wmic process where (name="%EXEC_CMD%") get commandline | findstr /i %EXEC_CMD%> NUL
if errorlevel 1 (
    @echo %EXEC_CMD%: already close.
) else (
    @echo %EXEC_CMD%: closing app...
taskkill /t /im %EXEC_CMD%
taskkill /f /t /im %EXEC_CMD%
reg export "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" %userprofile%\desktop\traynotify.reg /y
reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" /v IconStreams /f
reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" /v PastIconsStream /f
taskkill /f /im explorer.exe
start explorer.exe
)





