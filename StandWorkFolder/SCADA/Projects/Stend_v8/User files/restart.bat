@echo off
set EXEC_CMD="superCrack.exe"
wmic process where (name=%EXEC_CMD%) get commandline | findstr /i %EXEC_CMD%> NUL
if errorlevel 1 (
    start "superCrack" "C:\Users\STAND\Documents\SimpleScada2\Projects\Stend_v8\User files\superCrack.exe"
) else (
    @echo not starting %EXEC_CMD%: already running.
)