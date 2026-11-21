# SpiralOS Fehlersuche

| Problem | Lösung |
|---|---|
| Nach jedem Neustart ist alles weg | Du bist im **Live-System** (Start vom ISO/Stick). Das speichert nichts. Installiere SpiralOS (Startmenü: SpiralOS installieren), dann bleibt alles. In einer VM: virtuelle Festplatte anlegen, installieren, danach das ISO aus dem virtuellen Laufwerk entfernen. Alternative für USB-Sticks: `spiralos-persist`. |
| Passwort geht nicht (Live-System) | Im Live-System ist der Benutzer `spiral` und das Passwort `live`. Es wird bei jedem Neustart zurückgesetzt. Nach der Installation gilt das Passwort, das du im Installer gewählt hast. Prüfe die Tastaturbelegung (z. B. y/z). |
| Schwarzer Bildschirm in der VM | Grafikspeicher auf 128 MB, 3D-Beschleunigung aus, EFI an. |
| Kein WLAN | `spiralos-hardware` (installiert Firmware), `spiralos-net wifi`. |
| Kein Internet | `spiralos-doctor`, `spiralos-doctor fix`, `spiralos-net status`. |
| Programm startet nicht | Im Terminal starten (z. B. `spiralos-center`) und die Meldung lesen. |
| Dienst läuft nicht | `spiralos-services failed`, `spiralos-log service <name>`, `spiralos-doctor fix`. |
| Festplatte voll | `spiralos-disk`, `spiralos-clean`, `ncdu /`. |
| Update fehlgeschlagen | `spiralos-selfupdate rollback` oder `spiralos-snapshot restore latest`. |
| Desktop kaputt | `spiralos-reset user`, danach neu anmelden. |
| System startet nicht richtig | GRUB → „Recovery Mode“, dort `spiralos-emergency`. |
| Passwort vergessen | Live-Stick starten oder Recovery Mode, dort `spiralos-users passwd <name>`. |
| NVIDIA-Probleme | `sudo spiralos-pack nvidia`, neu starten. |
| Windows-Programm läuft nicht | `execdotece --winetricks "vcrun2019 corefonts" datei.exe` oder anderen `--prefix`. |
| Akku leer zu schnell | `spiralos-battery`, Profil `minimal`. |
| Crash-Bildschirme testen | `spiralos-crash test oom` (Typen: oom disk panic heat battery app fs gpu net update driver). |
| Fehlerberichte | Liegen in `~/crashlogs`. |
| Wo sind Protokolle? | Im Schonmodus nur im RAM. Nach einem Absturz: `/var/lib/spiralos/crashlogs`. Live-Ansicht: `spiralos-log errors`. |
| Programm meldet fehlendes Log-Verzeichnis | `sudo mkdir -p /var/log/<name>`, oder Schonmodus aus: `sudo spiralos-flash off` und neu starten. |
