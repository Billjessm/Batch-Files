@echo off
title Get IP Address

echo Your IPV4 Address is:

set "params=%*"

cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

where /q pwsh.exe 

if ERRORLEVEL 1 (

	goto POWERSHELL

)else (

	start /b /w "powershell" CMD /C pwsh.exe -Command "(Get-NetIPAddress -AddressFamily IPV4 -InterfaceAlias Ethernet).IPAddress"

)

:POWERSHELL

where /q powershell.exe 

if ERRORLEVEL 1 (

	goto COMMANDPROMPT

)else (

	start /b /w "powershell" CMD /C powershell.exe -Command "(Get-NetIPAddress -AddressFamily IPV4 -InterfaceAlias Ethernet).IPAddress"

)

where /q cmd.exe

if ERRORLEVEL 1 (

	goto ERRORSPRESENT

)else (

	start /b /w "command_prompt" CMD /C cmd.exe "(Get-NetIPAddress -AddressFamily IPV4 -InterfaceAlias Ethernet).IPAddress"

)

:ERRORSPRESENT

echo.
echo #################################
echo ### ERROR MUST SET UP EITHER  ###
echo ### POWERSHELL 7, POWERSHELL, ###
echo ### OR COMMAND PROMPT         ###
echo #################################
echo.

pause
exit 
