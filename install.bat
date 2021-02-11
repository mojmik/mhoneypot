@echo off
set mtaskname=
set localpath=
set maction=
set ipath=%cd%

echo 'name of the task running mhoneypot- choose whatever name2 > settings.txt
set /p mtaskname="task name (press enter for default mHoneyTask): "
if "%mtaskname%" == "" set mtaskname=mHoneyTask
echo mtaskname=%mtaskname%>> settings.txt
echo 'main program path>> settings.txt
echo mprgpath=%ipath%\>> settings.txt
echo 'path of honeypot files>> settings.txt
set /p localpath="path to protected files (press enter for default c:\mik\mh\): "
if "%localpath%" == "" set localpath=c:\mik\mh
IF NOT "%localpath:~-1%"=="\" SET "localpath=%localpath%\"
set localpath2=%localpath:~0,-1%
echo localpath=%localpath%>> settings.txt
echo 'action to be taken in case of ransomware alert>> settings.txt
set defaultaction=action.bat
set /p maction="action file (press enter for default %defaultaction%): "
if "%maction%" == "" set maction=%defaultaction%
echo maction=%localpath%%maction%>> settings.txt
robocopy "%ipath%" "%localpath2%" /e 
CALL %localpath%mhoneytask.bat
exit