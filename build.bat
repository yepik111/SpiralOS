@echo off
setlocal EnableExtensions
cd /d "%~dp0"
set "SRCDIR=%cd%"
if "%SRCDIR:~-1%"=="\" goto rootdir
where docker >nul 2>nul
if errorlevel 1 goto nodocker
docker info >nul 2>nul
if errorlevel 1 goto norun
echo.
echo Wohin sollen ISO und Arbeitsdaten? Zum Beispiel F:\SpiralOS auf deinem USB-Stick oder einer externen SSD.
echo Bedarf: mindestens 32 GB frei, Dateisystem exFAT oder NTFS (nicht FAT32).
set "OUTDIR="
set /p "OUTDIR=Zielordner [Enter = %SRCDIR%\out]: "
if not defined OUTDIR set "OUTDIR=%SRCDIR%\out"
set "OUTDIR=%OUTDIR:"=%"
if "%OUTDIR:~-2%"==":\" set "OUTDIR=%OUTDIR%SpiralOS"
if "%OUTDIR:~-1%"=="\" set "OUTDIR=%OUTDIR:~0,-1%"
if not exist "%OUTDIR%" mkdir "%OUTDIR%"
if not exist "%OUTDIR%" goto badpath
set "FS="
set "FREE="
if "%OUTDIR:~1,1%"==":" (
  for /f "delims=" %%F in ('powershell -NoProfile -Command "([IO.DriveInfo]'%OUTDIR:~0,1%').DriveFormat"') do set "FS=%%F"
  for /f "delims=" %%F in ('powershell -NoProfile -Command "[math]::Floor(([IO.DriveInfo]'%OUTDIR:~0,1%').AvailableFreeSpace/1GB)"') do set "FREE=%%F"
)
echo Ziel: %OUTDIR%  (Dateisystem: %FS%, frei: %FREE% GB)
if /i "%FS%"=="FAT32" goto fat32
if not defined FREE goto start
if %FREE% LSS 32 goto lowspace
goto start
:lowspace
echo WARNUNG: nur %FREE% GB frei, empfohlen sind 32 GB.
set "GO=n"
set /p "GO=Trotzdem fortfahren? j/n [n]: "
if /i not "%GO%"=="j" exit /b 1
:start
echo.
echo Build startet. Das dauert 1 bis 3 Stunden, auf einem USB-Stick eher laenger. PC nicht ausschalten oder in den Ruhezustand schicken.
docker run --rm --privileged -e SRC=/src -e OUT=/out -e USE_IMAGE=1 -e IMG_GB=20 -v "%SRCDIR%":/src -v "%OUTDIR%":/out debian:bookworm bash -c "tr -d '\r' < /src/build.sh > /tmp/b.sh; bash /tmp/b.sh"
if errorlevel 1 goto failed
echo.
echo Fertig. ISO und Protokolle liegen in: %OUTDIR%
echo Pruefe missing-packages.txt in diesem Ordner.
pause
exit /b 0
:failed
echo.
echo BUILD FEHLGESCHLAGEN. Schick mir die letzten 50 Zeilen von: %OUTDIR%\build.log
pause
exit /b 1
:rootdir
echo Bitte lege den Projektordner nicht direkt in das Hauptverzeichnis eines Laufwerks (z.B. C:\), sondern in einen Unterordner wie C:\SpiralOS.
pause
exit /b 1
:nodocker
echo Docker Desktop fehlt: https://www.docker.com/products/docker-desktop
pause
exit /b 1
:norun
echo Docker Desktop laeuft nicht. Starte es und warte, bis es bereit ist, dann dieses Skript erneut starten.
pause
exit /b 1
:badpath
echo Der Zielordner konnte nicht angelegt werden: %OUTDIR%
echo Ist der USB-Stick eingesteckt? Stecke ihn VOR dem Start von Docker Desktop ein, sonst sieht Docker das Laufwerk evtl. nicht (Abhilfe: in der Eingabeaufforderung "wsl --shutdown", dann Docker neu starten).
pause
exit /b 1
:fat32
echo Das Ziel ist FAT32. Das geht nicht (Dateien ueber 4 GB). Formatiere den Stick als exFAT oder waehle ein anderes Laufwerk.
pause
exit /b 1
