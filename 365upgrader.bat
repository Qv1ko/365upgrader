@echo off

setlocal enabledelayedexpansion

	rem Run as administrator
		if "%PROCESSOR_ARCHITECTURE%" equ "amd64" (
			>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
		) else (
			>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
		)

		if '%errorlevel%' neq '0' (
		    goto UACPrompt
		) else (
			goto gotAdmin
		)

		:UACPrompt
	    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
	    set params= %*
	    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"
	    "%temp%\getadmin.vbs"
	    del "%temp%\getadmin.vbs"
	    exit /b

		:gotAdmin
		pushd "%CD%"
		cd /d "%~dp0"

	rem Windows Update
		echo [+] Windows Update finished
		rem for %%W in (*.msu) do (
		rem     echo: Installing update: %%#
		rem     Wusa "%%W" /quiet /norestart
		rem )

	echo.

	rem Detect drives
		set "drives[0]= "
		set "num=0"

		for /f "tokens=2 delims==" %%a in ('wmic logicaldisk get caption /value') do (
		    set "drive=%%a"
		    set "drive=!drive:~0,-1!\"
		    set "drives[!num!]=!drive!"
		    set /a num+=1
		)

		set /a num-=1

	rem Geforce Experience
		for /R C:\ %%X in ("NVIDIA~1.EXE") do (
		    if exist "%%X" (
		        echo [#] Starting NVIDIA GeForce Experience
		        start "" "%%X"
		        goto :steam
		    )
		)

	rem Steam
		:steam

		for /l %%i in (0,1,%num%) do (
		    set "r=!drives[%%i]!"
		    echo [#]Finding Steam in !drives[%%i]! drive...
		    
		    call :searchSteam
		)

		:searchSteam
		for /R "%r%" %%X in ("steam.exe") do (
		    if exist "%%X" (
		        echo [+] Starting Steam
		        start "" "%%X"
		        goto :battlenet
		    )
		)

		goto :eof	


	rem Battle.net
		:battlenet
		for /R D:\ %%X in ("Battle.net.exe") do (
		    if exist "%%X" (
		        echo [#] Starting Battle.net
		        start "" "%%X"
		        goto :lolIni
		    )
		)

	rem League of Legends
		:lolIni
		for /R D:\ %%X in ("RiotClientServices.exe") do (
		    if exist "%%X" (
		        echo [#] Starting League of Legends
		        start "" "%%X" --launch-product=league_of_legends --launch-patchline=live
		        goto :epicIni
		    )
		)

	rem Epic Games
		:epicIni
		for /R D:\ %%X in ("EpicGamesLauncher.exe") do (
		    if exist "%%X" (
		        echo [#] Starting Epic Games
		        start "" "%%X"
		        goto :eaIni
		    )
		)

	rem EA
		:eaIni
		for /R C:\ %%X in ("EALauncher.exe") do (
		    if exist "%%X" (
		        echo [#] Starting EA
		        start "" "%%X"
		        goto :valorantIni
		    )
		)

	rem Valorant
		:valorantIni

		echo.

		echo [?] Press any key to open Valorant...
		pause > nul

		echo.

		for /R D:\ %%X in ("RiotClientServices.exe") do (
		    if exist "%%X" (
		        echo [#] Starting Valorant
		        start "" "%%X" --launch-product=valorant --launch-patchline=live
		        goto :clearIni
		    )
		)

	rem Delete temp files
		:clearIni
		del /s /f /q %temp%\*.*
		rem runas /user:Gamer "cmd /c del /s /f /q %temp%\*.*"
		rd /s /q %temp%
		md %temp% > nul

		del /s /f /q %windir%\temp\*.* > nul
		rd /s /q %windir%\temp > nul
		md %windir%\temp > nul

		explorer %temp%
		explorer %windir%\temp

	rem Clear bin
		del /s /q %systemdrive%\$Recycle.bin\*.* > nul
		rd /s /q %systemdrive%\$Recycle.bin > nul
		echo [+] System Cleared


	echo.

	rem Defragment drives
		echo [+] Defragmenting drives
		defrag /AllVolumes /B /H > nul
		defrag /AllVolumes /D /H > nul

	echo.

	echo [!] Tasks are finished, press a key to exit...
	pause > nul

endlocal
