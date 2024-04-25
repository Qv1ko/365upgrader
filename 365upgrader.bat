@echo off

setlocal enabledelayedexpansion

	rem Run as administrator
		if "%PROCESSOR_ARCHITECTURE%" equ "amd64" (
			>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
		) else (
			>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
		)

		if '%errorlevel%' neq '0' (
			goto UAC
		) else (
			goto gotAdmin
		)

		:UAC
		echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
		set params= %*
		echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"
		"%temp%\getadmin.vbs"
		del "%temp%\getadmin.vbs"
		exit /b

		:gotAdmin
		pushd "%CD%"
		cd /d "%~dp0"

	echo .----.  .-. .----..-..-----..-..-.      .-.     .-..-.                           .-.           
	echo `--  ; .'.' : .--': :`-. .-': :; :      : :     : :: :                           : :           
	echo  .' ' .' '. `. `. : :  : :  :    :.-..-.: `-.   : :: :.---.  .--. .--.  .--.   .-' : .--. .--. 
	echo  _`,`.: .; :.-`, :: :  : :  : :: :: :; :' .; :  : :; :: .; `' .; :: ..'' .; ; ' .; :' '_.': ..'
	echo `.__.'`.__.'`.__.':_;  :_;  :_;:_;`.__.'`.__.'  `.__.': ._.'`._. ;:_;  `.__,_;`.__.'`.__.':_;  
	echo                                                       : :    .-. :                             
	echo                                                       :_;    `._.'                             
	echo.
	echo.

	rem Upgrade Windows
		echo [#] Checking for Windows updates...
		powershell -command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned" > nul || goto :updateError
		powershell -command "Install-PackageProvider -Name NuGet -Force" > nul || goto :updateError
		powershell -command "Install-Module -Name PSWindowsUpdate -Force" > nul || goto :updateError
		powershell -command "Import-Module PSWindowsUpdate" > nul || goto :updateError
		powershell -command "Install-WindowsUpdate -MicrosoftUpdate -AcceptAll" > nul || goto :updateError
		powershell -command "Set-ExecutionPolicy -ExecutionPolicy Undefined" > nul || goto :updateError
		echo     [+] Windows update finished
		goto :endUpgradeWindows

		:updateError
		echo [-] Error trying to upgrade Windows

		:endUpgradeWindows

	echo.

	rem Drive finder
		set "drives[0]= "
		set "num=0"

		for /f "tokens=2 delims==" %%v in ('wmic logicaldisk get caption /value') do (
			set "drive=%%v"
			set "drive=!drive:~0,-1!\"
			set "drives[!num!]=!drive!"
			set /a num+=1
		)

		set /a num-=1

	rem Geforce Experience
		for /l %%n in (0,1,%num%) do (
			set "d=!drives[%%n]!"
			echo [#] Searching NVIDIA GeForce Experience in the !drives[%%n]! drive...
			call :searchGeforceExperience
		)

		:searchGeforceExperience
		for /R "%d%" %%g in (NVIDIA~1.EXE) do (
			if exist "%%g" (
				echo     [+] Starting NVIDIA GeForce Experience
				start "" "%%g"
				goto :endGeforceExperience
			)
		)
		echo [-] NVIDIA GeForce Experience was not found on %d% drive
		goto :eof

		:endGeforceExperience

	echo.

	rem Steam
		for /l %%n in (0,1,%num%) do (
			set "d=!drives[%%n]!"
			echo [#] Searching Steam in the !drives[%%n]! drive...
			call :searchSteam
		)

		:searchSteam
		for /R "%d%" %%g in (steam.exe) do (
			if exist "%%g" (
				echo     [+] Starting Steam
				start "" "%%g"
				goto :endSteam
			)
		)
		echo [-] Steam was not found on %d% drive
		goto :eof

		:endSteam

	echo.

	rem Battle.net
		for /l %%n in (0,1,%num%) do (
			set "d=!drives[%%n]!"
			echo [#] Searching Battle.net in the !drives[%%n]! drive...
			call :searchBattlenet
		)

		:searchBattlenet
		for /R "%d%" %%g in (Battle.net.exe) do (
			if exist "%%g" (
				echo     [+] Starting Battle.net
				start "" "%%g"
				goto :endBattlenet
			)
		)
		echo [-] Battle.net was not found on %d% drive
		goto :eof

		:endBattlenet

	echo.

	rem League of Legends
		for /l %%n in (0,1,%num%) do (
			set "d=!drives[%%n]!"
			echo [#] Searching League of Leguends in the !drives[%%n]! drive...
			call :searchLoL
		)

		:searchLoL
		for /R "%d%" %%g in (RiotClientServices.exe) do (
			if exist "%%g" (
				echo     [+] Starting League of Leguends
				start "" "%%g" --launch-product=league_of_legends --launch-patchline=live
				goto :endLoL
			)
		)
		echo [-] League of Leguends was not found on %d% drive
		goto :eof

		:endLoL

	echo.

	rem Epic Games
		for /l %%n in (0,1,%num%) do (
			set "d=!drives[%%n]!"
			echo [#] Searching Epic Games in the !drives[%%n]! drive...
			call :searchEpicGames
		)

		:searchEpicGames
		for /R "%d%" %%g in (EpicGamesLauncher.exe) do (
			if exist "%%g" (
				echo     [+] Starting Epic Games
				start "" "%%g"
				goto :endEpicGames
			)
		)
		echo [-] Epic Games was not found on %d% drive
		goto :eof

		:endEpicGames

	echo.

	rem EA
		for /l %%n in (0,1,%num%) do (
			set "d=!drives[%%n]!"
			echo [#] Searching EA in the !drives[%%n]! drive...
			call :searchEA
		)

		:searchEA
		for /R "%d%" %%g in (EALauncher.exe) do (
			if exist "%%g" (
				echo     [+] Starting EA
				start "" "%%g"
				goto :endEA
			)
		)
		echo [-] EA was not found on %d% drive
		goto :eof

		:endEA

	echo.

	echo [?] Press any key to open Valorant...
	pause > nul

	echo.

	rem Valorant
		for /l %%n in (0,1,%num%) do (
			set "d=!drives[%%n]!"
			echo [#] Searching Valorant in the !drives[%%n]! drive...
			call :searchValorant
		)

		:searchValorant
		for /R "%d%" %%g in (RiotClientServices.exe) do (
			if exist "%%g" (
				echo     [+] Starting Valorant
				start "" "%%g" --launch-product=valorant --launch-patchline=live
				goto :endValorant
			)
		)
		echo [-] Valorant was not found on %d% drive
		goto :eof

		:endValorant

	echo.

	rem Clean the system
		set "endCleaning="

		for /l %%n in (0,1,%num%) do (
			set "d=!drives[%%n]!"
			echo [#] Cleaning !drives[%%n]! drive...
			if %%n equ %num% (
				set endCleaning=true
			)
			call :searchClear
		)

		:searchClear
		for /R "%d%" %%g in (temp) do (
			if exist "%%g" (
				del /s /f /q "%%g\*.*" > nul 2> nul
				rd /s /q "%%g" > nul 2> nul
				md "%%g" > nul 2> nul
			)
		)
		echo     [+] Temporary files cleaned from %d% drive

		for /R "%d%" %%g in (Downloads) do (
			if exist "%%g" (
				del /s /f /q "%%g\*.*" > nul 2> nul
				rd /s /q "%%g" > nul 2> nul
				md "%%g" > nul 2> nul
			)
		)
		echo     [+] Download files cleaned from %d% drive

		rd /s /q %d%$Recycle.Bin > nul 2> nul
		echo     [+] Bin of unit %d% cleared

		if not "%endCleaning%" == "true" (
			goto :eof
		)

	echo.

	rem Optimise system boot
		echo [#] Optimising the boot system...
		defrag /AllVolumes /B /H > nul
		echo     [+] Boot optimisation completed

	echo.

	rem Defragment drives
		echo [#] Defragmenting disks...
		defrag /AllVolumes /D /H > nul
		echo     [+] Disk degragmentation completed

	echo.

	echo [?] Tasks are finished, press a key to exit...
	pause > nul

	rem Delete command history
		doskey /listsize=0

	echo.

	echo ,------.          ,--.  ,--.   
	echo :  .---',--.  ,--.`--',-'  '-. 
	echo :  `--,  \  `'  / ,--.'-.  .-' 
	echo :  `---. /  /.  \ :  :  :  :   
	echo `------''--'  '--'`--'  `--'

	timeout /t 33 /nobreak > NUL
	exit

endlocal
