```bash
#!/bin/bash
# SpiralOS ISO bauen (Debian live-build).
# Als root auf Debian/Ubuntu oder im Docker-Container.

set -euo pipefail

SRC="${SRC:-$(cd "$(dirname "$0")" && pwd)}"
OUT="${OUT:-$SRC/out}"
USE_IMAGE="${USE_IMAGE:-0}"
IMG_GB="${IMG_GB:-20}"

# Root pruefen
if [ "$(id -u)" != 0 ]; then
    echo "Bitte als root starten (sudo ./build.sh)"
    exit 1
fi

# Ausgabe vorbereiten
mkdir -p "$OUT"
exec > >(tee -a "$OUT/build.log") 2>&1

echo "== SpiralOS-Build $(date) =="

# --------------------------------------------------
# System aktualisieren
# --------------------------------------------------

export DEBIAN_FRONTEND=noninteractive

apt-get update

apt-get install -y --no-install-recommends \
    live-build \
    debootstrap \
    squashfs-tools \
    xorriso \
    mtools \
    dosfstools \
    e2fsprogs \
    ca-certificates

# --------------------------------------------------
# Arbeitsverzeichnis
# --------------------------------------------------

W=/tmp/spiralos-build

rm -rf "$W"
mkdir -p "$W"

IMG=""

# --------------------------------------------------
# Optionales ext4-Build-Image
# --------------------------------------------------

if [ "$USE_IMAGE" = "1" ]; then

    IMG="$OUT/spiralos-work.img"

    rm -f "$IMG"

    truncate -s "${IMG_GB}G" "$IMG"
    mkfs.ext4 -q -F "$IMG"

    if mount -o loop "$IMG" "$W"; then

        trap '
            cd /
            sync
            umount -l "$W" 2>/dev/null || true
            rm -f "$IMG"
        ' EXIT

    else

        echo "WARNUNG: Loop-Mount nicht moeglich."
        echo "Baue ohne Image weiter."
        rm -f "$IMG"

    fi
fi

# --------------------------------------------------
# Dateien kopieren
# --------------------------------------------------

cp -r "$SRC/live/." "$W/"

cd "$W"

# --------------------------------------------------
# CRLF-Zeilenenden entfernen
# --------------------------------------------------

find . -type f \
    \( \
        -path './auto/*' \
        -o -name '*.hook.*' \
        -o -name '*.list.*' \
        -o -name '*.conf' \
        -o -name '*.service' \
        -o -path './config/includes.chroot/usr/local/bin/*' \
    \) \
    -exec sed -i 's/\r$//' {} +

# --------------------------------------------------
# Skripte ausfuehrbar machen
# --------------------------------------------------

for f in auto/* config/hooks/live/* \
    config/includes.chroot/usr/local/bin/*; do

    [ -f "$f" ] || continue
    chmod +x "$f"

done

# --------------------------------------------------
# Update-Schluessel pruefen
# --------------------------------------------------

if [ ! -f config/includes.chroot/usr/share/spiralos/update-key.gpg ]; then

    echo "HINWEIS: kein Update-Schluessel"
    echo "(tools/make-update-key)"
    echo "Updates werden ungeprueft installiert."

fi

# --------------------------------------------------
# Paketnamen pruefen
# --------------------------------------------------

# KEINE eigene Debian-Quelle anlegen!
# Die Quellen des Debian-Containers sind bereits konfiguriert.
# Ein zweiter Eintrag verursacht den Signed-By-Konflikt.

MISSING=""

shopt -s nullglob

PACKAGE_LISTS=(config/package-lists/*.chroot)

for L in "${PACKAGE_LISTS[@]}"; do

    [ -f "$L" ] || continue

    TMP="$L.tmp"

    while IFS= read -r p || [ -n "$p" ]; do

        case "$p" in
            ""|\#*)
                echo "$p" >> "$TMP"
                continue
                ;;
        esac

        if apt-cache show "$p" >/dev/null 2>&1; then

            echo "$p" >> "$TMP"

        else

            echo "WARNUNG: Paket '$p' nicht gefunden."
            echo "Paket wird uebersprungen."

            MISSING="$MISSING $p"

        fi

    done < "$L"

    mv "$TMP" "$L"

done

# --------------------------------------------------
# Fehlende Pakete speichern
# --------------------------------------------------

echo "$MISSING" > "$OUT/missing-packages.txt"

if [ "$(echo "$MISSING" | wc -w)" -gt 15 ]; then

    echo "FEHLER: Zu viele Pakete nicht gefunden!"
    echo "Vermutlich kein Internet oder Debian-Mirror-Problem."
    echo "Build abgebrochen."

    exit 1

fi

# --------------------------------------------------
# live-build bereinigen
# --------------------------------------------------

lb clean --purge || true

# --------------------------------------------------
# live-build konfigurieren
# --------------------------------------------------

lb config

# --------------------------------------------------
# ISO bauen
# --------------------------------------------------

lb build

# --------------------------------------------------
# ISO suchen
# --------------------------------------------------

ISO=""

for f in *.iso; do

    [ -f "$f" ] || continue
    ISO="$f"
    break

done

if [ -z "$ISO" ]; then

    echo "FEHLER: Keine ISO-Datei erzeugt!"
    exit 1

fi

# --------------------------------------------------
# ISO kopieren
# --------------------------------------------------

cp "$ISO" "$OUT/SpiralOS-1.0-amd64.iso"

# --------------------------------------------------
# SHA256
# --------------------------------------------------

(
    cd "$OUT"

    sha256sum SpiralOS-1.0-amd64.iso \
        > SpiralOS-1.0-amd64.iso.sha256
)

# --------------------------------------------------
# Groesse berechnen
# --------------------------------------------------

MB=$(du -m "$OUT/SpiralOS-1.0-amd64.iso" | cut -f1)

# --------------------------------------------------
# Fertig
# --------------------------------------------------

echo
echo "======================================"
echo " SpiralOS Build abgeschlossen"
echo "======================================"

echo "ISO: $OUT/SpiralOS-1.0-amd64.iso"
echo "Groesse: ${MB} MB"
echo "SHA256: $OUT/SpiralOS-1.0-amd64.iso.sha256"

if [ "$MB" -le 10240 ]; then
    echo "ISO-Groesse: OK"
else
    echo "WARNUNG: ISO groesser als 10 GB."
fi

echo "======================================"
echo " BUILD ERFOLGREICH"
echo "======================================"
```
