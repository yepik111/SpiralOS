# SpiralOS-Befehle

Automatisch erzeugt (`python3 tools/make-man.py`). Zu jedem Befehl gibt es `man <befehl>`.

| Befehl | Aufruf | Beschreibung |
|---|---|---|
| `execdotece` | `execdotece [--prefix NAME] [--winetricks "verb ..."] <datei.exe\|.msi> [argumente]` | execdotece [--prefix NAME] [--winetricks "verb ..."] <datei.exe\|.msi> [argumente] |
| `spiralos-archive` | `spiralos-archive [archiv]` | Archive ansehen, entpacken und erstellen (zip, tar, 7z) |
| `spiralos-backup` | `spiralos-backup create <quelle> <zielordner> \| list <zielordner> \| restore <archiv> <zielordner>` | spiralos-backup create <quelle> <zielordner> \| list <zielordner> \| restore <archiv> <zielordner> |
| `spiralos-backupplan` | `spiralos-backupplan` | SpiralOS-Programm |
| `spiralos-battery` | `spiralos-battery` | SpiralOS-Programm |
| `spiralos-calc` | `spiralos-calc` | SpiralOS-Programm |
| `spiralos-center` | `spiralos-center` | SpiralOS-Programm |
| `spiralos-claude` | `spiralos-claude` | Claude Code fuer SpiralOS: spiralos-claude [install\|doctor\|web\|<claude-argumente>] |
| `spiralos-clean` | `spiralos-clean` | SpiralOS-Programm |
| `spiralos-crash` | `spiralos-crash <typ> [detail]  \|  spiralos-crash test <typ>` | spiralos-crash <typ> [detail]  \|  spiralos-crash test <typ> |
| `spiralos-crashwatch` | `spiralos-crashwatch` | Ueberwacht das System und zeigt Absturz-Bildschirme (laeuft in der Sitzung) |
| `spiralos-disk` | `spiralos-disk [pfad]` | Belegung, groesste Ordner, Festplatten-Gesundheit |
| `spiralos-docs` | `spiralos-docs [list\|<name>]` | Handbuecher lesen (INSTALLATION, BENUTZERHANDBUCH, FEHLERSUCHE, THIRD-PARTY, COMMANDS) |
| `spiralos-doctor` | `spiralos-doctor` | SpiralOS-Programm |
| `spiralos-edit` | `spiralos-edit [datei ...]` | Texteditor mit Tabs, Suchen/Ersetzen und Zoom |
| `spiralos-emergency` | `spiralos-emergency` | SpiralOS Notfallkonsole: Reparatur-Menue |
| `spiralos-eventd` | `spiralos-eventd` | Root-Dienst: liest das Kernel-Log und meldet Ereignisse an die Sitzung |
| `spiralos-firewall` | `spiralos-firewall` | SpiralOS-Programm |
| `spiralos-firstlogin` | `spiralos-firstlogin` | SpiralOS-Programm |
| `spiralos-hardware` | `spiralos-hardware` | Hardware-Assistent: erkennt Geraete und bietet Treiber/Pakete an |
| `spiralos-healthcheck` | `spiralos-healthcheck` | Unsichtbarer Gesundheitscheck kurz nach dem Login: meldet Probleme per Benachrichtigung |
| `spiralos-help` | `spiralos-help` | SpiralOS-Programm |
| `spiralos-host` | `spiralos-host show \| set <name>` | spiralos-host show \| set <name> |
| `spiralos-info` | `spiralos-info` | SpiralOS-Programm |
| `spiralos-install` | `spiralos-install` | Installationsassistent: PC-Check, Hinweise, Start des Installers (Calamares) |
| `spiralos-install-check` | `spiralos-install-check` | prueft den PC, bevor SpiralOS installiert wird |
| `spiralos-language` | `spiralos-language <code>` | Systemsprache und Tastatur umstellen |
| `spiralos-log` | `spiralos-log errors\|boot\|today\|live\|service <name>` | spiralos-log errors\|boot\|today\|live\|service <name> |
| `spiralos-loginsound` | `spiralos-loginsound` | SpiralOS-Programm |
| `spiralos-monitor` | `spiralos-monitor` | SpiralOS-Programm |
| `spiralos-net` | `spiralos-net` | SpiralOS-Programm |
| `spiralos-notes` | `spiralos-notes` | SpiralOS-Programm |
| `spiralos-pack` | `spiralos-pack` | Optionale Programmpakete nachinstallieren: spiralos-pack <name> \| spiralos-pack <apt-paket> ... |
| `spiralos-pass` | `spiralos-pass` | Passwort-Manager: Daten als JSON, verschluesselt mit AES-256 (OpenSSL, PBKDF2), Master-Passwort |
| `spiralos-persist` | `spiralos-persist` | Legt auf dem USB-Stick, von dem SpiralOS laeuft, eine Speicher-Partition ("persistence") an |
| `spiralos-postinstall` | `spiralos-postinstall` | Laeuft einmalig nach der Installation (Dienst spiralos-postinstall.service) |
| `spiralos-power` | `spiralos-power` | SpiralOS-Programm |
| `spiralos-profile` | `spiralos-profile list\|show\|apply <standard\|developer\|gaming\|privacy\|minimal>` | spiralos-profile list\|show\|apply <standard\|developer\|gaming\|privacy\|minimal> |
| `spiralos-quickshot` | `spiralos-quickshot` | SpiralOS-Programm |
| `spiralos-reset` | `spiralos-reset user` | Oberflaeche (Desktop-Einstellungen) zuruecksetzen, Dateien bleiben |
| `spiralos-sandbox` | `spiralos-sandbox [--online] <programm>` | startet ein Programm isoliert (temporaeres Home, ohne Netzwerk) |
| `spiralos-search` | `spiralos-search` | SpiralOS-Programm |
| `spiralos-selfupdate` | `spiralos-selfupdate check\|install\|rollback\|version\|channel [stable\|beta]\|changelog` | SpiralOS-Updater (GitHub): check \| install \| rollback \| version \| channel [stable\|beta] \| changelog |
| `spiralos-services` | `spiralos-services list\|failed\|status\|start\|stop\|restart\|enable\|disable [dienst]` | spiralos-services list\|failed\|status\|start\|stop\|restart\|enable\|disable [dienst] |
| `spiralos-setpass` | `spiralos-setpass` | Beim ersten Start im Live-System: eigenes Passwort statt "live" setzen und SSH-Passwort-Login freigeben |
| `spiralos-settings` | `spiralos-settings` | SpiralOS-Programm |
| `spiralos-share` | `spiralos-share <ordner\|datei> [port]` | gibt Dateien im lokalen Netzwerk per Browser frei (Strg+C beendet) |
| `spiralos-shot` | `spiralos-shot` | SpiralOS-Programm |
| `spiralos-snapshot` | `spiralos-snapshot create [notiz] \| auto \| list \| restore <name\|latest> \| delete <name>` | spiralos-snapshot create [notiz] \| auto \| list \| restore <name\|latest> \| delete <name> |
| `spiralos-sound` | `spiralos-sound on\|off\|test` | Anmeldeklang und Systemklaenge |
| `spiralos-speedtest` | `spiralos-speedtest` | SpiralOS-Programm |
| `spiralos-ssh` | `spiralos-ssh` | SSH-Verwaltung |
| `spiralos-store` | `spiralos-store` | SpiralOS-Programm |
| `spiralos-sync` | `spiralos-sync <quelle> <ziel> [rsync-optionen]   (lokal oder user@host` | /pfad). Tipp: erst mit -n (Testlauf) |
| `spiralos-timer` | `spiralos-timer <dauer wie bei sleep` | 90, 5m, 2h> [text] |
| `spiralos-timezone` | `spiralos-timezone show\|list\|set <Zone>\|ntp on\|off` | spiralos-timezone show\|list\|set <Zone>\|ntp on\|off |
| `spiralos-tip` | `spiralos-tip` | SpiralOS-Programm |
| `spiralos-update` | `spiralos-update` | SpiralOS-Programm |
| `spiralos-updatecheck` | `spiralos-updatecheck` | SpiralOS-Programm |
| `spiralos-usb` | `spiralos-usb list \| eject <partition, z.B. /dev/sdb1>` | spiralos-usb list \| eject <partition, z.B. /dev/sdb1> |
| `spiralos-users` | `spiralos-users list\|add\|remove\|passwd\|sudo\|nosudo <name>` | spiralos-users list\|add\|remove\|passwd\|sudo\|nosudo <name> |
| `spiralos-view` | `spiralos-view [bild]` | Bildbetrachter (vor/zurueck, zoom, drehen, in den Papierkorb) |
| `spiralos-weather` | `spiralos-weather [ort]  (nutzt wttr.in)` | spiralos-weather [ort]  (nutzt wttr.in) |
| `spiralos-welcome` | `spiralos-welcome` | SpiralOS-Programm |
