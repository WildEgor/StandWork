@echo off

:: Notification Area Cleaner
:: Created by Digital Citizen
:: Distributed by www.digitalcitizen.life
:: WARNING! This utility restarts your shell (Explorer.exe) and clears your notification area icon cache

taskkill /im explorer.exe /f
reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" /v IconStreams /f
reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" /v PastIconsStream /f
start "Shell Restarter" /d "%systemroot%" /i /normal explorer.exe