@echo off                           
:loop                             
start "Server" "C:\Program Files (x86)\Simple-Scada 2\Server.exe"
timeout /t 20 /nobreak >null           
taskkill /t /im Server.exe
taskkill /f /t /im Server.exe
taskkill /im explorer.exe /f
reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" /v IconStreams /f
reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" /v PastIconsStream /f
start "Shell Restarter" /d "%systemroot%" /i /normal explorer.exe   
timeout /t 5 >null          
goto loop 

