@echo off
where gpg >nul 2>nul || (echo GnuPG fehlt: Gpg4win installieren - https://www.gpg4win.org & pause & exit /b 1)
gpg --quick-generate-key "SpiralOS Updates" ed25519 sign never
if not exist live\config\includes.chroot\usr\share\spiralos mkdir live\config\includes.chroot\usr\share\spiralos
gpg --yes --output live\config\includes.chroot\usr\share\spiralos\update-key.gpg --export "SpiralOS Updates"
echo.
echo Fertig. Der oeffentliche Schluessel liegt jetzt im Projekt. ISO NEU BAUEN, damit er im System ist.
echo Sichere deinen geheimen Schluessel: gpg --armor --export-secret-keys "SpiralOS Updates" ^> geheim.asc
pause
