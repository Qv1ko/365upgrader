@echo off

echo .----.  .-. .----..-..-----..-..-.      .-.      .--. .-.               .-.              
echo `--  ; .'.' : .--': :`-. .-': :; :      : :     : .--': :               : :.-.           
echo  .' ' .' '. `. `. : :  : :  :    :.-..-.: `-.   : :   : `-.  .--.  .--. : `'.' .--. .--. 
echo  _`,`.: .; :.-`, :: :  : :  : :: :: :; :' .; :  : :__ : .. :' '_.''  ..': . `.' '_.': ..'
echo `.__.'`.__.'`.__.':_;  :_;  :_;:_;`.__.'`.__.'  `.__.':_;:_;`.__.'`.__.':_;:_;`.__.':_;  
echo.
echo.

set filename=check.txt

rem Microphone tester
start https://mictests.com

rem Headset tester
start https://music.youtube.com

rem Keyboard tester
start https://en.key-test.ru

rem Mouse tester
start https://cpstest.org/mouse-test

if exist %filename% del %filename%

:MicrophoneCheck
echo.
set /P m=Is the microphone working properly[Y/N]? 
if /I "%m%" EQU "Y" (
    echo [+] Microphone >> %filename%
    goto HeadsetCheck
) else if /I "%m%" EQU "N" (
    echo [!] Microphone >> %filename%
    goto HeadsetCheck
) else (
	echo.
    echo [!] Invalid input. Please enter Y or N.
    goto MicrophoneCheck
)

:HeadsetCheck
echo.
set /P h=Is the headset working properly[Y/N]? 
if /I "%h%" EQU "Y" (
    echo [+] Headset >> %filename%
    goto KeyboardCheck
) else if /I "%h%" EQU "N" (
    echo [!] Headset >> %filename%
    goto KeyboardCheck
) else (
	echo.
    echo [!] Invalid input. Please enter Y or N.
    goto HeadsetCheck
)

:KeyboardCheck
echo.
set /P k=Is the keyboard working properly[Y/N]? 
if /I "%k%" EQU "Y" (
    echo [+] Keyboard >> %filename%
    goto MouseCheck
) else if /I "%k%" EQU "N" (
    echo [!] Keyboard >> %filename%
    goto MouseCheck
) else (
	echo.
    echo [!] Invalid input. Please enter Y or N.
    goto KeyboardCheck
)

:MouseCheck
echo.
set /P r=Is the mouse working properly[Y/N]? 
if /I "%r%" EQU "Y" (
    echo [+] Mouse >> %filename%
) else if /I "%r%" EQU "N" (
    echo [!] Mouse >> %filename%
) else (
	echo.
    echo [!] Invalid input. Please enter Y or N.
    goto MouseCheck
)

rem Delete command history
	doskey /listsize=0

echo.
echo [+] Log saved in the folder %cd%\%filename%

timeout /t 3 /nobreak > nul
exit
