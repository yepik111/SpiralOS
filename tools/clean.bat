@echo off
cd /d "%~dp0\.."
echo Dieses Skript loescht die Arbeitskopien github-iso und github-repo in diesem Projektordner (nicht dein Projekt selbst).
set "GO=n"
set /p "GO=Fortfahren? j/n [n]: "
if /i not "%GO%"=="j" exit /b 0
if exist github-iso rmdir /s /q github-iso
if exist github-repo rmdir /s /q github-repo
echo Fertig.
pause
