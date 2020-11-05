@echo off
set EXEC_CMD="superCrackW.exe"
wmic process where (name=%EXEC_CMD%) get commandline | findstr /i %EXEC_CMD%> NUL
if errorlevel 1 (
    start "superCrack" "C:\SCADA\Projects\Stend_v8\User files\superCrackW.exe"
) else (
    @echo not starting %EXEC_CMD%: already running.
)