# SpiralOS-Updates: Schritt für Schritt

## Das Prinzip
Es gibt drei Orte: **dein PC** (Projektordner), **GitHub** (`github.com/yepik111/SpiralOS`) und die **SpiralOS-Geräte**.
Du änderst Dateien am PC → `publish-update.bat` lädt sie signiert zu GitHub hoch → SpiralOS holt sie sich und prüft die Signatur.
Updates ersetzen nur Dateien. Neue Pakete, Kernel oder Sprachpakete brauchen ein neues ISO.

## Einmalig vorbereiten (in dieser Reihenfolge)
1. **GitHub-Repo**: auf github.com → New repository → Name `SpiralOS` → **Public** → erstellen.
2. **Programme installieren**: Git für Windows (git-scm.com) und Gpg4win (gpg4win.org).
3. **Update-Schlüssel erzeugen** (BEVOR du das ISO baust): `tools\make-update-key.bat` ausführen, Passphrase wählen.
   Der öffentliche Schlüssel landet im Projekt und kommt ins ISO. Den geheimen Schlüssel sicherst du mit
   `gpg --armor --export-secret-keys "SpiralOS Updates" > geheim.asc` an einem sicheren Ort. Ohne ihn kannst du keine Updates mehr signieren.
4. **ISO bauen** (`build.bat`, oder GitHub baut es, siehe unten). Darin liegt Version `1.0.0`.
5. In GitHub: Settings → Password and authentication → 2FA aktivieren.

## Ein Update veröffentlichen
1. Datei unter `live\config\includes.chroot\...` ändern (z. B. `usr\local\bin\spiralos-notes`).
2. `publish-update.bat` doppelklicken.
3. **Versionsnummer** (immer höher: `1.0.1`, `1.0.2` …), **Kurzbeschreibung** und **Kanal** (`stable` oder `beta`) eingeben.
4. Bei „ISO bauen lassen?“ meist `n`. Mit `j` baut GitHub zusätzlich ein neues ISO.
5. Beim ersten Mal öffnet Git ein Browserfenster zum GitHub-Login. Am Ende steht „Update … veröffentlicht“.
   Das Skript legt außerdem `MANIFEST.sha256` (Prüfsummen) und `MANIFEST.sha256.asc` (Signatur) und einen Eintrag in `CHANGELOG.md` an.

## Auf SpiralOS aktualisieren
- Terminal: `spiralos-selfupdate check` → `spiralos-selfupdate install`.
- Oder: Systemzentrum → Wartung → „SpiralOS-Update“. Beim Login erscheint auch ein Hinweis.
- Vor jedem Update wird automatisch ein Snapshot erstellt. Zurück: `spiralos-selfupdate rollback` oder `spiralos-snapshot restore latest`.
- „Was ist neu“: `spiralos-selfupdate changelog`.
- Beta-Kanal testen: `sudo spiralos-selfupdate channel beta` (zurück mit `stable`).

## Was beim Update geprüft wird
Signatur des Manifests (mit deinem Schlüssel), Prüfsumme jeder Datei, keine zusätzlichen Dateien, Versionsnummer passt,
Syntax aller Skripte. Bei einem Fehler wird nichts installiert und der Absturz-Bildschirm „Update fehlgeschlagen“ erscheint.

## ISO von GitHub bauen lassen (spart Platz auf C:)
GitHub → Reiter **Actions** → „ISO bauen“ → **Run workflow**. Nach ca. 1–2 Stunden: Lauf öffnen → Artefakt **SpiralOS-ISO** herunterladen
(enthält ISO, Prüfsumme, `build.log`, `missing-packages.txt`). Das Repo muss öffentlich sein, dann ist es kostenlos.

## Zusätzliche Dinge beim Update ausführen
Eine Datei `update.sh` im Hauptordner des Repos läuft nach dem Kopieren als root (z. B. `apt-get install -y htop`). Hinweis: Sie ist nicht Teil
des signierten Manifests, benutze sie daher nur, wenn du dem Repo vertraust, und lege sie lieber unter `rootfs/` als Skript ab.

## Fehlersuche
| Meldung | Lösung |
|---|---|
| GitHub nicht erreichbar | Kein Internet, Repo nicht öffentlich oder `VERSION` fehlt im Branch. |
| SpiralOS ist aktuell | Versionsnummer auf GitHub ist nicht höher als `spiralos-selfupdate version`. |
| Signatur ungültig | Manifest wurde nicht (oder mit anderem Schlüssel) signiert. `publish-update.bat` mit installiertem GnuPG benutzen. |
| rootfs/ fehlt | `publish-update.bat` nicht benutzt oder Push fehlgeschlagen. |
| Update abgebrochen: Fehler in <Datei> | Syntaxfehler in dieser Datei. Korrigieren und neu veröffentlichen. |
| Git-Login-Fehler | Im Browser bei GitHub anmelden oder ein Personal Access Token benutzen. |
| System kaputt nach Update | `spiralos-emergency` (Punkt 4 oder 15) oder `spiralos-selfupdate rollback`. |
