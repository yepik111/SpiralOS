# SpiralOS Fehlersuche

| Problem | Lösung |
|---|---|
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
