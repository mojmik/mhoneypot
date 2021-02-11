rem @echo off
for /f "delims== tokens=1,2" %%G in (%~dp0settings.txt) do set %%G=%%H

SETLOCAL EnableDelayedExpansion
rem edit settings.txt for following variables
rem set localpath=C:\it\mhoneypot\
set logfile=%mprgpath%log.txt
set srcpath=%localpath%src\
set n=0
set mbody=Zprava user:%username% pc:%computername% ransomware alert!

@echo --- >> %logfile%   
@echo %DATE% %TIME% project ransomware honeypot >> %logfile%

set mconfig=%localpath%files.cfg

if not exist %mconfig% ( 
 goto mend
)
 
set /p mfiles=<%mconfig%
if "%mfiles%" equ "" ( 
 goto mend
)

for %%a in (!mfiles!) do (
   set vector[!n!]=%%a
   set /A n+=1
)

for /L %%i in (0,1,6) do (   
   set mfn=%srcpath%!vector[%%i]!
   
   if not exist "!mfn!.checksum" (
    CertUtil -hashfile !mfn! MD5 > !mfn!.checksum
	@echo !mfn! neexistuje prvotni checksum file, generuju  >> %logfile%
   ) else (	
	   rem periodicky porovnavat checksums
	   CertUtil -hashfile !mfn! MD5 > !mfn!.checksum2

	   fc /b !mfn!.checksum !mfn!.checksum2 >nul
	   if not !errorlevel! == 0 (		 		
		 @echo !mfn! POZOR! zmena >> %logfile%  
		 CALL "%maction%" "ransomware alert" "%mbody%"
	   ) else (
	     @echo !mfn! zadna zmena >> %logfile%  
	   )
	   
	   
	   
   )
)

goto mend


:mend
@echo on