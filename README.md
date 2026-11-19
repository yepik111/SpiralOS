# SpiralOS 1.0 (Helix)

Installierbare Linux-Distribution auf Debian-12-Basis. Nur das Noetigste ist vorinstalliert:
Xfce-Desktop mit Taskleiste, Firefox, Dateimanager (Thunar), Terminal, Texteditor, NetworkManager (WLAN/LAN),
OpenSSH-Server/-Client, Calamares-Installer, Audio, gaengige WLAN-Firmware, UEFI- und BIOS-Boot.

## Speicher
- ISO: ca. 5-7 GB (Limit 10 GB, Build warnt sonst).
- Build: alle Arbeitsdaten liegen in einem Image mit hartem Limit von 20 GB (`IMG_GB`), Gesamtbedarf unter 30 GB.
- Auf C: bleibt nur Docker selbst (ca. 0,5 GB). `build.bat` fragt nach dem Zielordner, z.B. `E:\SpiralOS` auf dem USB-Stick
  (mind. 32 GB frei, exFAT/NTFS). Das Arbeits-Image wird nach dem Build geloescht.

## ISO bauen
- Windows: Docker Desktop (WSL2) installieren, `build.bat` starten, Zielordner angeben.
- Linux: `sudo OUT=/pfad/zum/stick USE_IMAGE=1 ./build.sh`

## Starten und Speichern
- USB-Stick mit Rufus (DD-Modus) oder balenaEtcher beschreiben, davon booten. Login: `spiral` / `live`.
- Installation: Calamares starten und als Ziel beliebige Platte waehlen (auch einen USB-Stick).
- Daten im Live-Betrieb behalten: auf dem Stick eine ext4-Partition mit dem Namen `persistence` anlegen
  (GParted) und darin eine Datei `persistence.conf` mit dem Inhalt `/ union` erstellen.

## Nachinstallieren
- `spiralos-pack` zeigt Pakete: buero, medien, entwicklung, netzwerk, spiele, virtualisierung.
- `spiralos-pack buero` oder beliebige apt-Pakete: `spiralos-pack htop git`.

## execdotece
`execdotece <pfad>` macht eine .exe (oder .msi) ausfuehrbar und startet sie ueber Wine, z.B. `execdotece ~/Downloads/setup.exe`.
Beim ersten Mal wird Wine (ca. 1 GB) nachinstalliert und .exe-Dateien werden systemweit ausfuehrbar registriert
(danach geht auch `./programm.exe`). `execdotece --setup` richtet nur die Unterstuetzung ein.
Hinweis: Wine ist kein Windows. Viele Programme laufen, manche nicht.

## SSH
Server laeuft ab Start (Port 22, kein Root-Login), Host-Keys werden pro System neu erzeugt.
`ssh benutzer@<ip>` (IP mit `ip a`).

## Anpassen
Pakete: `live/config/package-lists/`, Dienste/Branding: `live/config/hooks/live/`,
Dateien im System: `live/config/includes.chroot/`, Boot-Parameter: `live/auto/config`.

## Hinweis
Der Build wurde nicht getestet. Fehlt ein Paketname in Debian 12, bricht `lb build` mit dem Namen ab; Zeile entfernen.

## Eigene SpiralOS-Software (selbst geschrieben)
Kernel, Treiber, Desktop-Grundlage und Browser stammen von anderen Projekten (Linux, Debian, Xfce, Firefox).
Alles darueber wurde fuer SpiralOS selbst geschrieben (Python/Shell, siehe `live/config/includes.chroot/usr/local/bin/`):
- Programme: `spiralos-center` (Systemzentrum), `spiralos-monitor`, `spiralos-notes`, `spiralos-calc`, `spiralos-welcome`
- Befehle: `spiralos-info`, `-doctor`, `-update`, `-clean`, `-backup`, `-pack`, `-ssh`, `-firewall`, `-net`, `-help`, `execdotece`
- Ersteinrichtung (`spiralos-firstlogin`), eigenes Hintergrundbild, Bash-Voreinstellungen, Starter im Menue
Zusaetzlich vorinstalliert: LibreOffice, VLC, GParted, Git, Compiler, Bildbetrachter, PDF-Leser.

## Updates ueber GitHub (Repo: github.com/yepik111/SpiralOS)
Das Repo (oeffentlich, Branch `main`) enthaelt `VERSION` und den Ordner `rootfs/` (Spiegel von `live/config/includes.chroot`).
- Update veroeffentlichen: Dateien unter `live/config/includes.chroot/` aendern, dann `publish-update.bat` starten
  (neue, hoehere Versionsnummer eingeben). Das Skript kopiert alles nach `rootfs/`, setzt `VERSION` und pusht.
- Optional `update.sh` im Repo-Hauptordner: wird nach dem Kopieren als root ausgefuehrt (z.B. `apt-get install ...`).
- Im OS: Systemzentrum > Wartung > "SpiralOS-Update" oder `spiralos-selfupdate install`.
  `spiralos-selfupdate check` prueft nur; `rollback` stellt den Stand vor dem letzten Update wieder her.
  Beim Login erscheint eine Benachrichtigung, wenn ein Update bereitliegt.
- Neues ISO ist nur noetig bei Kernel- oder Paketaenderungen. Aktiviere 2FA fuer deinen GitHub-Account: wer das Repo
  aendern kann, kann Code auf allen SpiralOS-Geraeten ausfuehren.

## Absturz-Bildschirme
`spiralos-crash test <typ>` mit: oom, disk, panic, heat, battery, app, fs, gpu.
Echte Ausloeser: `spiralos-crashwatch` (Sitzung) ueberwacht RAM, Platte, Temperatur und Akku, `spiralos-eventd` (Dienst)
liest das Kernel-Log (OOM-Kill, Segfault, Dateisystem-/GPU-Fehler). Bei einem echten Kernel-Panic ist das System selbst
abgestuerzt und kann keinen eigenen Bildschirm mehr zeigen; es startet nach 10 Sekunden automatisch neu (`panic=10`).
Logs landen in `~/crashlogs`.

## Notfallkonsole
`spiralos-emergency` (auch im Menue "SpiralOS Notfallkonsole" und als Knopf auf den Absturz-Bildschirmen): Reparatur-Menue fuer
fsck, Netzwerk-Reset, Desktop-Reset, Update-Rollback, Paketreparatur, Passwort-Reset, Fehlerlog, Textmodus, Bootloader, Root-Shell.
Im GRUB-Menue des installierten Systems startet "Recovery Mode" den Rescue-Modus; dort erscheint der Hinweis auf `spiralos-emergency`.

## Weitere Verbesserungen
ZRAM-Swap (komprimierter RAM-Swap), Sicherheits-Updates automatisch, Firewall beim ersten Start aktiv (SSH erlaubt), fail2ban fuer SSH,
gehaertetes SSH und Kernel (sysctl), SSD-TRIM, begrenzte Logs, woechentliche Bereinigung, schnellerer Start, Zeitsynchronisierung,
Bildschirmsperre, Akku-Optimierung (TLP), Bluetooth, deutsche Locale/Tastatur, Update-Sicherheitspruefung (kaputte Skripte werden nicht installiert).
Details zu Updates: `ANLEITUNG-UPDATE.md`.

## Sprachen
14 Sprachen: Englisch, Deutsch, Spanisch, Franzoesisch, Portugiesisch (BR), Russisch, Chinesisch (vereinfacht), Japanisch,
Arabisch, Hindi, Tuerkisch, Italienisch, Polnisch, Koreanisch.
- Installer (Calamares) und Anmeldebildschirm bieten die Sprachauswahl an. Firefox und LibreOffice sind in allen Sprachen vorhanden.
- Umstellen im laufenden System: Systemzentrum > Tab "Language" oder `spiralos-language <code>` (z.B. `ja`), danach neu anmelden.
- Eigene Programme (Systemzentrum, Monitor, Notizen, Willkommen, Absturz-Bildschirme) sind in 12 Sprachen uebersetzt
  (`live/config/includes.chroot/usr/local/lib/spiralos/i18n.py`); Arabisch und Hindi fallen dort auf Englisch zurueck, weil Tk
  diese Schriften nicht korrekt darstellt (Firefox, LibreOffice und der restliche Desktop funktionieren).
- Chinesisch/Japanisch/Koreanisch: Eingabemethode (ibus) wird automatisch eingerichtet.
- Terminal-Befehle (`spiralos-*`) geben ihre Meldungen weiterhin auf Deutsch/Englisch aus.
- Standardsprache des Live-Systems: Deutsch (`live/auto/config`, Parameter `locales=` und `keyboard-layouts=`).

## Neu in dieser Version
- **Build abgesichert:** `build.sh` prueft alle Paketnamen vor dem Bau und ueberspringt fehlende (Liste in `out/missing-packages.txt`), Log in `out/build.log`.
  Test: `tools/test-iso.sh` (QEMU) oder `tools/test-iso.bat`.
- **GitHub baut das ISO** (`.github/workflows/build-iso.yml`), siehe ANLEITUNG-UPDATE.md.
- **Branding:** eigenes Logo (Spirale), Bootmenue/Installer/GRUB heissen SpiralOS, eigener Plymouth-Bootbildschirm.
- **Live-Passwort:** beim ersten Start im Live-System wird ein eigenes Passwort verlangt; SSH-Passwort-Login bleibt bis dahin aus.
- **Design:** GTK-Theme "SpiralOS" (flach, dunkel), Einstellungen-App, Willkommens-Assistent (Sprache, Design, Programme).
- **Programme:** Software-Center (APT und Flatpak), Dateisuche, Screenshot, Passwort-Manager (AES-256 via OpenSSL), Backup-Planer.
- **execdotece:** eigene Wine-Umgebungen (`--prefix`), `--winetricks`, Dateipruefung, verstaendliche Fehler.
- **Gaming:** `spiralos-pack gaming` (Steam mit Proton, Lutris, GameMode).
- **Sicherheit:** Festplattenverschluesselung (LUKS) im Installer, Secure-Boot-Pakete (shim/signed GRUB) fuer das installierte System,
  automatische Snapshots vor Updates und Paketaenderungen, signierte Updates (GPG).
- **Updater:** Kanaele stable/beta, Changelog, Signaturpruefung.
- **USB:** `spiralos-persist` legt die Speicher-Partition auf dem Stick automatisch an.
- **Hardware:** `spiralos-hardware` (NVIDIA, WLAN-Firmware, Fingerabdruck, Drucker).
- **Sprachen:** Meldungen der Terminal-Befehle in 14 Sprachen, eigene Programme (GTK) inkl. Arabisch und Hindi; Monitor, Notizen und Rechner (Tk)
  bleiben bei Arabisch/Hindi Englisch. Die neuen Programme (Einstellungen, Software-Center, Passwoerter u.a.) sind auf Deutsch/Englisch.
- **Absturz-Bildschirme:** 11 Typen (neu: Netzwerk, Update, Treiber) mit Knopf "Bericht speichern".
- **Hinweis Secure Boot:** Das installierte System soll damit booten; das Live-ISO selbst kann Secure Boot deaktiviert brauchen.

## Startmenue
Das Panel oben enthaelt das Startmenue (Whisker-Menue mit Suche, Kategorien und Favoriten; bei Problemen bleibt das klassische
Anwendungsmenue). Alle SpiralOS-Programme sind dort unter System, Einstellungen und Zubehoer zu finden.

## Aussehen (clean)
Eine Farbpalette (dunkles Blaugrau, ein blauer Akzent), keine Verlaeufe, keine Schatten-Effekte, einheitliche Rundungen und Abstaende,
Schrift Inter, Papirus-Symbole, schlanke Titelleisten ohne Menue-Knopf (nur Minimieren, Maximieren, Schliessen), duenne Leiste oben,
aufgeraeumter Desktop ohne Symbole, ruhiger Anmeldebildschirm, Terminal ohne Menueleiste und Scrollbalken, kurze Favoritenliste im Startmenue.
Alles wird beim ersten Login gesetzt und ist in den Einstellungen aenderbar.

## Claude
- **Claude Code** (Anthropics KI-Programmierassistent fuer das Terminal) ist als optionales Paket integriert, nicht vorinstalliert:
  `sudo spiralos-pack claude` (curl, git, ripgrep) und danach als normaler Benutzer `spiralos-claude install`. Das nutzt den offiziellen Installer
  von Anthropic (`curl -fsSL https://claude.ai/install.sh | bash`, kein Node.js noetig). Danach startet `spiralos-claude` (oder das Startmenue-Symbol
  "Claude Code") Claude Code; beim ersten Start meldest du dich im Browser mit deinem Claude-Konto an. `spiralos-claude doctor` prueft die Installation.
  Voraussetzungen laut Anthropic: Debian 10+, 4 GB RAM, Internet, Claude-Konto. Aktuelles: docs.claude.com (Claude Code).
- **Claude (Web)**: Startmenue-Eintrag, oeffnet claude.ai in Firefox.
- Auch im Systemzentrum (Programme) und im Willkommens-Assistenten waehlbar.

## Schrift "Spiral Sans"
Eigene Schrift (Regular und Bold), erzeugt mit `python3 tools/make-font.py` (nur fontTools noetig): Strichschrift mit runden Enden, Latein
inkl. Umlauten, ß, gaengigen Akzenten, Ziffern und Satzzeichen. Sie ist Standard fuer Oberflaeche, Titelleisten und Anmeldebildschirm
(Inter dient als Ersatz fuer fehlende Zeichen); wechselbar unter Einstellungen > Design > Schrift. Zeichen ausserhalb von Latein (z.B. Chinesisch,
Arabisch, Hindi) stammen weiter aus den Noto-Schriften.

## Hinweise fuer Windows (build.bat)
- Docker Desktop vor dem Start laufen lassen. USB-Stick vor Docker einstecken (sonst `wsl --shutdown` und Docker neu starten).
- Ziel exFAT oder NTFS mit mind. 32 GB frei. Ein USB-Stick ist langsam: der Build dauert dort laenger; eine externe SSD ist deutlich schneller.
- `build.bat` bricht bei FAT32, fehlendem/gestopptem Docker oder ungueltigem Zielordner mit einer Erklaerung ab und prueft den freien Platz.

## ISO auf GitHub bauen: make-iso-github.bat
Doppelklick auf `make-iso-github.bat`: laedt das Projekt in den Branch `iso` deines Repos `yepik111/SpiralOS`, setzt einen Tag
(`v-iso-<Name>`) und startet damit den ISO-Bau auf GitHub Actions. Nach ca. 1 bis 2 Stunden erscheint unter *Releases* das ISO in Teilen
(`.part00`, `.part01` ...; GitHub erlaubt max. 2 GB pro Datei) samt Pruefsumme und Build-Log. Teile in einen Ordner laden und `tools\join-iso.bat`
dort ausfuehren. Der Branch `iso` ist getrennt von `main`/`beta`, die Update-Kanaele bleiben unberuehrt. Das Repo muss oeffentlich sein.

## Weitere Befehle und Hintergrundfunktionen
- Befehle: `spiralos-disk`, `-services`, `-users`, `-timezone`, `-host`, `-battery`, `-speedtest`, `-weather`, `-timer`, `-sync`, `-usb`, `-share`,
  `-sandbox` (firejail), `-log`, `-reset user`, `spiralos-doctor fix`. Alles auch im Systemzentrum unter "Tools".
- Unsichtbar: Gesundheitscheck nach dem Login (fehlgeschlagene Dienste, volle Platte, Neustart noetig, Updates), Akku-Warnung bei 15 %,
  stuendliche SMART-Pruefung der Festplatten (bei Fehler Absturz-Bildschirm), Tipp des Tages im Terminal, Hinweis bei unbekannten Befehlen,
  Tab-Vervollstaendigung fuer alle spiralos-Befehle.
- Power-Menue mit Strg+Alt+Entf; Tastenkuerzel: Druck = Screenshot, Super+T = Terminal, Super+E = Dateien, Super+L = Sperren.

## Hinweis zu versteckten Ordnern
`make-iso-github.bat` und `publish-update.bat` benutzen `tools\build-iso.yml` (sichtbar) und legen `.github\workflows` im Repo selbst an.
Sie brechen mit einer Erklaerung ab, wenn Git deinen Namen nicht kennt oder die Datei fehlt, und pruefen am Ende, ob der Tag auf GitHub angekommen ist.

## Dokumentation und Werkzeuge
- `docs/`: INSTALLATION, BENUTZERHANDBUCH, FEHLERSUCHE, THIRD-PARTY, ENTWICKLER, COMMANDS (im System: `spiralos-docs`, `man spiralos-<befehl>`).
- `tools/selftest.sh` prueft das ganze Projekt (laeuft auch automatisch auf GitHub bei jedem Upload und vor jedem ISO-Bau).
- `tools/make-man.py` erzeugt Man-Pages, `tools/clean.bat` raeumt die Arbeitskopien auf, `tools/join-iso.bat` setzt ISO-Teile zusammen.
- Neu im System: Installationsassistent mit PC-Check, Nach-der-Installation-Dienst, Profile (`spiralos-profile`).
