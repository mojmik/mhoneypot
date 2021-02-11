@echo off
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

set byPass=0

rem set mtaskname=mHoneyTask
for /f "delims== tokens=1,2" %%G in (settings.txt) do set %%G=%%H

if "%1" == "del" (
 schtasks.exe /end /tn %mtaskname%
 schtasks.exe /Delete /f /tn %mtaskname%
 goto mByPass
)


schtasks /query /TN "%mtaskname%" >NUL 2>&1
if %errorlevel% EQU 0 set byPass=1

if %byPass% == 1 goto :mByPass

schtasks.exe /end /tn %mtaskname%
schtasks.exe /Delete /f /tn %mtaskname%
schtasks /create /tn %mtaskname% /tr "%localpath%hpot.bat" /SC MINUTE /MO 30 /f /ru "NT AUTHORITY\NETWORKSERVICE"
schtasks.exe /Run /tn %mtaskname%

:mByPass
@echo on
exit