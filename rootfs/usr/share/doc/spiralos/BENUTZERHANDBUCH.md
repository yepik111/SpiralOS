# SpiralOS Benutzerhandbuch

## Desktop
- Panel oben, Startmenü „SpiralOS“ (mit Suche). Der Desktop selbst ist leer und ruhig.
- Tastenkürzel: **Strg+Alt+Entf** Power-Menü, **Druck** Screenshot, **Super+T** Terminal, **Super+E** Dateien, **Super+L** sperren.

## Programme
Systemzentrum (alles an einem Ort), Einstellungen, Software-Center (APT und Flatpak), Dateisuche, Screenshot, Passwort-Manager (verschlüsselt), Backup-Planer,
Monitor, Notizen, Rechner. Firefox, LibreOffice, VLC, GParted und der Dateimanager sind vorinstalliert.

## Programme nachinstallieren
- Grafisch: Software-Center.
- Terminal: `spiralos-pack <name>` (Packs: buero, medien, entwicklung, netzwerk, spiele, gaming, virtualisierung, drucker, fingerabdruck, nvidia, firmware, claude).
- Beliebige Pakete: `spiralos-pack htop`.
- Windows-Programme: `execdotece datei.exe` (läuft über Wine, nicht alles funktioniert).

## Profile
`spiralos-profile list` zeigt: standard, developer, gaming, privacy, minimal. Mit `spiralos-profile apply <name>` stellst du das System darauf ein.

## Updates und Sicherheit
- `spiralos-update` aktualisiert System-Pakete und SpiralOS. `spiralos-selfupdate check|install|rollback|changelog|channel`.
- Vor Updates und Paketänderungen entstehen automatisch Snapshots: `spiralos-snapshot list|restore latest`.
- Firewall standardmäßig an (`spiralos-firewall`), SSH mit `spiralos-ssh on|off`, fail2ban schützt SSH.
- Verschlüsselung der Festplatte: im Installer wählbar. Passwörter: `spiralos-pass`.
- Programme isoliert starten: `spiralos-sandbox <programm>`.

## Daten sichern
`spiralos-backup create ~ ~/Backups`, automatisch mit dem Backup-Planer, oder `spiralos-sync <quelle> <ziel>` (rsync, auch zu anderen Rechnern per SSH).
USB-Laufwerke sicher entfernen: `spiralos-usb eject /dev/sdb1`.

## Sprachen
`spiralos-language <code>` (en de es fr pt ru zh ja ar hi tr it pl ko) oder Systemzentrum → Language, danach neu anmelden.

## Claude
`sudo spiralos-pack claude`, dann `spiralos-claude install` und `spiralos-claude` (Claude-Konto nötig). „Claude (Web)“ öffnet claude.ai.

## Hilfe
`spiralos-help`, `man spiralos-<befehl>`, `spiralos-docs list`, `spiralos-doctor` (und `fix`), `spiralos-emergency` (Reparaturmenü).

## Eigene Programme
Editor (`spiralos-edit`), Bilder (`spiralos-view`) und Archive (`spiralos-archive`) öffnen Textdateien, Bilder und Archive per Doppelklick.
Anmeldeklang: `spiralos-sound on|off|test`. Das Symbol-Set, die Klänge, die Schriften „Spiral Sans“ und „Spiral Mono“ und der Bootbildschirm sind eigene Werke.
Falls ein eigenes Programm Probleme macht, funktionieren die klassischen Programme weiter im Terminal: `mousepad`, `ristretto`, `file-roller`.
