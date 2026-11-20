# Schonmodus für SD-Karten und SSDs

SpiralOS schreibt im Normalbetrieb **keine Protokolle auf die Platte**. Auf die Platte kommt nur bei einem Absturz ein Bericht.

## Was der Schonmodus macht (`spiralos-flash on`, auf installierten Systemen automatisch)
- Systemprotokoll (journal) nur im RAM, `/var/log`, `/tmp` und `/var/tmp` liegen im RAM.
- Dateisystem mit `noatime` und längerem Schreibintervall (`commit=30`).
- Kein Swap auf der Platte (komprimierter Swap im RAM bleibt).
- Caches und Sitzungsprotokoll im RAM, Firefox ohne Festplatten-Cache und mit seltenem Sitzungsspeicher.
- Hintergrund-Aufgaben, die schreiben (Protokoll-Rotation, Man-Pages-Cache, Paket-Datenbank-Sicherung, Dateisystem-Scrubs), sind aus. Paketlisten-Updates laufen wöchentlich statt täglich.

## Wann trotzdem geschrieben wird
- **Absturzbericht** (Speicher voll, Dienst-Fehler, Dateisystem-/Grafik-/Treiberfehler, Platten-Defekt, Überhitzung, Akku): `/var/lib/spiralos/crashlogs`, höchstens 20 Berichte, mindestens 60 Sekunden Abstand pro Typ.
- Wenn du Programme installierst oder aktualisierst, schreibt das System natürlich (Pakete, Snapshot vor Updates).
- Deine eigenen Dateien und was Programme wie der Browser speichern (Lesezeichen, Verlauf).

## Grenzen
- **Kernel-Panic oder Stromausfall:** Das System ist sofort tot, der RAM-Inhalt ist weg. Ein Bericht entsteht nur, wenn die Hardware den Absturz selbst festhält (UEFI-Speicher „pstore“). Das kann nicht jedes Gerät.
- Mit `commit=30` können bei Stromausfall bis zu 30 Sekunden Änderungen verloren gehen.
- Nicht null Schreibzugriffe: Das Dateisystem-Journal, die Systemuhr und Programmdaten schreiben weiter, nur viel seltener.

## Befehle
`spiralos-flash status` zeigt, ob der Modus aktiv ist, was im RAM liegt und **wie viel seit dem Start auf die Platte geschrieben wurde**. `spiralos-flash off` stellt den Normalbetrieb wieder her (Neustart nötig). Berichte ansehen: `ls /var/lib/spiralos/crashlogs`.
