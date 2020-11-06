@echo off
SetLocal EnableDelayedExpansion

set StandPCPath=C:\Users\STAND\Documents\SimpleScada2\Projects\Stend_v8\User files\My Scripts\
set WorkPCPath=C:\SCADA\Projects\Stend_v8\User files\My scripts\

set ScriptPath=%~dp0

if "%WorkPCPath%" == "%ScriptPath%" (CALL :RunScript superCrack.exe)
if "%StandPCPath%" == "%ScriptPath%" (CALL :RunScript superCrackW.exe)

EXIT /B 0

:RunScript
set EXEC_CMD=%~1
wmic process where (name="%EXEC_CMD%") get commandline | findstr /i %EXEC_CMD%> NUL
if errorlevel 1 (
    start "superCrack" "%~dp0%EXEC_CMD%"
) else (
    @echo not starting %EXEC_CMD%: already running.
)




