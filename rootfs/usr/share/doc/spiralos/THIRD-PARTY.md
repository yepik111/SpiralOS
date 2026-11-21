# Verwendete Software von Dritten

SpiralOS ist eine Debian-12-Distribution (wie Ubuntu, Mint oder Kali). Es wurde selbst geschrieben: die `spiralos-*`-Programme und -Befehle, `execdotece`,
Updater, Crash-Bildschirme, Editor, Bildbetrachter, Archiv-Manager, Schriften „Spiral Sans“ und „Spiral Mono“, Symbol-Set, Klangthema, Bootanimation, Theme „SpiralOS“, Logo, Startseite, Konfiguration und Build-Skripte. Alles andere stammt von anderen Projekten
und steht unter deren Lizenzen (keine Rechtsberatung; prüfe die Lizenztexte unter `/usr/share/doc/<paket>/copyright`).

| Komponente | Lizenz (Auszug) |
|---|---|
| Linux-Kernel | GPL-2.0 |
| Debian-Basis, GNU-Werkzeuge, live-build | GPL und weitere |
| Xfce, GTK | GPL / LGPL |
| Firefox ESR, LibreOffice, Thunderbird | MPL-2.0 u. a. |
| VLC | GPL / LGPL |
| Calamares (Installer) | GPL-3.0+ |
| Wine | LGPL-2.1+ |
| OpenSSH | BSD |
| Python | PSF |
| Inter, Noto (Schriften) | SIL OFL 1.1 |
| Papirus (Symbole, als Rückfallebene) | GPL-3.0 |
| firejail, fail2ban, ufw | GPL |

Nicht vorinstalliert und mit eigenen Bedingungen: Steam (`spiralos-pack gaming`), Claude Code (`spiralos-claude`, Nutzungsbedingungen von Anthropic, Konto nötig),
NVIDIA-Treiber (`spiralos-pack nvidia`). Der Quellcode aller Debian-Pakete liegt im Debian-Archiv (deb-src), die SpiralOS-Skripte liegen offen im Projekt.
