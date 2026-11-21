@echo off
rem In den Ordner kopieren, in dem die heruntergeladenen .part-Dateien liegen, und dort ausfuehren.
cd /d "%~dp0"
if not exist SpiralOS-1.0-amd64.iso.part00 goto nop
copy /b SpiralOS-1.0-amd64.iso.part* SpiralOS-1.0-amd64.iso
certutil -hashfile SpiralOS-1.0-amd64.iso SHA256
echo Vergleiche den Wert mit der Datei .sha256 aus dem Release.
pause
exit /b 0
:nop
echo Lege diese Datei in den Ordner mit SpiralOS-1.0-amd64.iso.part00, part01 usw. und starte sie erneut.
pause
exit /b 1
