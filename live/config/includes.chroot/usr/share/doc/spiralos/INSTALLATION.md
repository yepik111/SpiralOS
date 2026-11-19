# SpiralOS installieren

## Voraussetzungen
- 64-Bit-PC (x86-64), mindestens 2 GB RAM (empfohlen 4 GB), mindestens 25 GB freier Platz (empfohlen 40 GB).
- Ein USB-Stick (8 GB oder mehr) oder eine virtuelle Maschine (VirtualBox, VMware, QEMU).
- Optional: Internet (für Updates; die Installation geht auch ohne).

## 1. Starten
- **VM:** Neue Linux-VM ("Other Linux 64-bit"), 4 GB RAM, 30 GB Platte, EFI an, ISO als CD einlegen.
- **USB-Stick:** ISO mit Rufus (DD-Modus) oder balenaEtcher schreiben und vom Stick starten (Bootmenü meist F12, F10 oder Esc).
- Im Live-System meldest du dich mit dem Benutzer `spiral` an und setzt beim ersten Start ein eigenes Passwort.

## 2. Vorbereiten
- Öffne „SpiralOS installieren (Assistent)“ im Startmenü. Er prüft RAM, Festplatte, UEFI/BIOS, Internet und Secure Boot.
- **Sichere wichtige Daten.** Der Installer kann komplette Festplatten löschen.
- Notebook: Netzteil anschließen.

## 3. Installer
Klicke im Assistenten auf „Installer starten“ (oder auf das Installer-Symbol). Die Schritte:
1. **Sprache und Ort**, danach **Tastatur**.
2. **Partitionierung:**
   - *Festplatte löschen*: einfachste Variante, löscht alles auf der gewählten Platte.
   - *Neben anderem System installieren (Dual-Boot)*: nur nach Datensicherung; Windows vorher defragmentieren und BitLocker-Schlüssel sichern.
   - *Verschlüsseln*: aktiviere „Festplatte verschlüsseln“ und wähle ein starkes Passwort. Ohne Passwort sind die Daten nicht lesbar, auch nicht für dich.
3. **Benutzer:** Name, Rechnername, Passwort. Der Benutzer darf `sudo` verwenden.
4. **Zusammenfassung** prüfen und installieren. Das dauert etwa 10 bis 30 Minuten.
5. Neustart, ISO/Stick entfernen.

## 4. Nach der Installation
- Beim ersten Start legt SpiralOS automatisch einen Wiederherstellungspunkt („fresh install“) an und schaltet die Live-Einstellungen ab.
- Der Willkommens-Assistent fragt nach Sprache, Design und Programmen.
- Aktualisieren: `spiralos-update`. Profile: `spiralos-profile list`.

## Secure Boot
Das installierte System unterstützt Secure Boot. Das Live-System kann es ausgeschaltet brauchen (BIOS/UEFI-Einstellung).

## Probleme
Siehe `spiralos-docs FEHLERSUCHE`.
