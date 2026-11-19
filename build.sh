```bash
#!/bin/bash
# SpiralOS ISO bauen (Debian live-build).
# Als root auf Debian/Ubuntu oder im Docker-Container.

set -euo pipefail

SRC="${SRC:-$(cd "$(dirname "$0")" && pwd)}"
OUT="${OUT:-$SRC/out}"
USE_IMAGE="${USE_IMAGE:-0}"   # 1 = Arbeitsdaten in ext4-Image unter $OUT
IMG_GB="${IMG_GB:-20}"        # harte Obergrenze der Arbeitsdaten in GB

[ "$(id -u)" = 0 ] || {
    echo "Bitte als root starten (sudo ./build.sh)"
    exit 1
}

mkdir -p "$OUT"

exec > >(tee -a "$OUT/build.log") 2>&1

echo "== SpiralOS-Build $(date) =="

# --------------------------------------------------
# System aktualisieren und Build-Abhaengigkeiten
# installieren
# --------------------------------------------------

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
# Optional: Build in einem ext4-Image
# --------------------------------------------------

if [ "$USE_IMAGE" = 1 ]; then

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
        echo "Baue ohne Image (belegt Platz im Docker-Speicher)."

        rm -f "$IMG"

    fi

fi

# --------------------------------------------------
# SpiralOS-Dateien kopieren
# --------------------------------------------------

cp -r "$SRC/live/." "$W/"

cd "$W"

# Windows-Zeilenenden entfernen
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

# Skripte ausfuehrbar machen
chmod +x auto/* config/hooks/live/* \
    config/includes.chroot/usr/local/bin/*

# --------------------------------------------------
# Update-Schluessel
# --------------------------------------------------

if [ ! -f config/includes.chroot/usr/share/spiralos/update-key.gpg ]; then
    echo "HINWEIS: kein Update-Schluessel"
    echo "(tools/make-update-key)"
    echo "Updates werden ungeprueft installiert."
fi

# --------------------------------------------------
# Paketnamen pruefen
# --------------------------------------------------

# WICHTIG:
# apt-get update wurde bereits oben ausgefuehrt.
# Keine zweite Debian-Quelle anlegen!
# Dadurch wird der Signed-By-Konflikt vermieden.

MISSING=""

for L in config/package-lists/*.chroot; do

    [ -f "$L" ] || continue

    while read -r p; do

        case "$p" in
            ''|\#*)
                continue
                ;;
        esac

        if ! apt-cache show "$p" >/dev/null 2>&1; then

            echo "WARNUNG: Paket '$p' nicht gefunden."
            echo "Paket wird uebersprungen."

            MISSING="$MISSING $p"

            grep -vxF -- "$p" "$L" > "$L.tmp" || true

            mv "$L.tmp" "$L"

        fi

    done < "$L"

done

# Fehlende Pakete protokollieren
echo "$MISSING" > "$OUT/missing-packages.txt"

# Bei zu vielen fehlenden Paketen abbrechen
if [ "$(echo "$MISSING" | wc -w)" -gt 15 ]; then

    echo "FEHLER: Zu viele Pakete nicht gefunden!"
    echo "Vermutlich kein Internet oder Debian-Mirror nicht erreichbar."
    echo "Build abgebrochen."

    exit 1

fi

# --------------------------------------------------
# live-build vorbereiten
# --------------------------------------------------

lb clean --purge || true

lb config

# --------------------------------------------------
# ISO bauen
# --------------------------------------------------

lb build

# --------------------------------------------------
# ISO finden und kopieren
# --------------------------------------------------

ISO=$(ls -1 *.iso | head -n1)

cp "$ISO" "$OUT/SpiralOS-1.0-amd64.iso"

# --------------------------------------------------
# SHA256 erstellen
# --------------------------------------------------

(
    cd "$OUT"

    sha256sum SpiralOS-1.0-amd64.iso \
        > SpiralOS-1.0-amd64.iso.sha256
)

# --------------------------------------------------
# Dateigroesse anzeigen
# --------------------------------------------------

MB=$(du -m "$OUT/SpiralOS-1.0-amd64.iso" | cut -f1)

echo
echo "======================================"
echo " SpiralOS Build abgeschlossen"
echo "======================================"

echo "ISO: $OUT/SpiralOS-1.0-amd64.iso"
echo "Groesse: ${MB} MB"

if [ "$MB" -le 10240 ]; then
    echo "ISO-Groesse: OK"
else
    echo "WARNUNG: ISO ist groesser als 10 GB."
fi

echo "SHA256: $OUT/SpiralOS-1.0-amd64.iso.sha256"

echo "======================================"
echo "Fertig!"
```
