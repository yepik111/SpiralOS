#!/bin/bash
# SpiralOS ISO bauen (Debian live-build). Als root auf Debian/Ubuntu oder im Docker-Container.
set -euo pipefail
SRC="${SRC:-$(cd "$(dirname "$0")" && pwd)}"
OUT="${OUT:-$SRC/out}"
USE_IMAGE="${USE_IMAGE:-0}"   # 1 = Arbeitsdaten in ext4-Image unter $OUT (Windows/Docker)
IMG_GB="${IMG_GB:-20}"        # harte Obergrenze der Arbeitsdaten in GB
[ "$(id -u)" = 0 ] || { echo "Bitte als root starten (sudo ./build.sh)"; exit 1; }
mkdir -p "$OUT"
exec > >(tee -a "$OUT/build.log") 2>&1
echo "== SpiralOS-Build $(date) =="
apt-get update
apt-get install -y --no-install-recommends live-build debootstrap squashfs-tools xorriso mtools dosfstools e2fsprogs ca-certificates gnupg apt-utils xz-utils bzip2 cpio file zstd rsync syslinux syslinux-common isolinux grub-pc-bin grub-efi-amd64-bin
W=/tmp/spiralos-build
rm -rf "$W"; mkdir -p "$W"
IMG=""
if [ "$USE_IMAGE" = 1 ]; then
  IMG="$OUT/spiralos-work.img"
  rm -f "$IMG"; truncate -s "${IMG_GB}G" "$IMG"; mkfs.ext4 -q -F "$IMG"
  if mount -o loop "$IMG" "$W"; then
    trap 'cd /; sync; umount -l "$W" 2>/dev/null || true; rm -f "$IMG"' EXIT
  else
    echo "WARNUNG: Loop-Mount nicht moeglich, baue ohne Image (belegt Platz im Docker-Speicher)."; rm -f "$IMG"
  fi
fi
cp -r "$SRC/live/." "$W/"
cd "$W"
find . -type f \( -path './auto/*' -o -name '*.hook.*' -o -name '*.list.*' -o -name '*.conf' -o -name '*.service' -o -path './config/includes.chroot/usr/local/bin/*' \) -exec sed -i 's/\r$//' {} +
chmod +x auto/* config/hooks/live/* config/includes.chroot/usr/local/bin/*
[ -f config/includes.chroot/usr/share/spiralos/update-key.gpg ] || echo "HINWEIS: kein Update-Schluessel (tools/make-update-key) - Updates werden ungeprueft installiert."
# Paketnamen pruefen, fehlende automatisch ueberspringen
# Vorhandene Paketquelle um contrib/non-free erweitern (keine zweite, doppelte Quelle anlegen: das gaebe einen Signed-By-Konflikt)
if [ -f /etc/apt/sources.list.d/debian.sources ]; then
  sed -i 's/^Components:.*/Components: main contrib non-free non-free-firmware/' /etc/apt/sources.list.d/debian.sources
elif [ -f /etc/apt/sources.list ]; then
  sed -i -E 's/^(deb[^#]* bookworm[^ ]* )main( .*)?$/\1main contrib non-free non-free-firmware/' /etc/apt/sources.list
fi
apt-get update
MISSING=""
# "Installierbar" heisst: es gibt eine Version, die man holen kann (nicht nur ein Verweis aus anderen Paketen)
has_candidate() { local c; c=$(apt-cache policy "$1" 2>/dev/null | awk '/Candidate:/{print $2; exit}'); [ -n "$c" ] && [ "$c" != "(none)" ]; }
for L in config/package-lists/*.chroot; do
  while read -r p; do
    case "$p" in ''|\#*) continue ;; esac
    if ! has_candidate "$p"; then
      echo "WARNUNG: Paket '$p' nicht gefunden, wird uebersprungen."; MISSING="$MISSING $p"
      grep -vxF -- "$p" "$L" > "$L.tmp" && mv "$L.tmp" "$L"
    fi
  done < "$L"
done
echo "$MISSING" > "$OUT/missing-packages.txt"
if [ "$(echo $MISSING | wc -w)" -gt 15 ]; then echo "FEHLER: zu viele Pakete nicht gefunden - vermutlich kein Internet oder Debian-Mirror nicht erreichbar. Build abgebrochen."; exit 1; fi
# Vorab pruefen, ob die ganze Paketauswahl zusammen installierbar ist (findet Konflikte in Sekunden statt nach 20 Minuten)
ALL=$(cat config/package-lists/*.chroot | grep -vE '^(#|$)' | sort -u | tr '\n' ' ')
echo "Pruefe, ob die Paketauswahl zusammen installierbar ist ..."
if ! apt-get -s install $ALL > /tmp/sim.log 2>&1; then echo "FEHLER: Paketauswahl ist nicht installierbar:"; tail -n 40 /tmp/sim.log; exit 1; fi
echo "Paketauswahl ok."
lb clean --purge || true
lb config
lb build
ISO=$(ls -1 *.iso | head -n1)
cp "$ISO" "$OUT/SpiralOS-1.0-amd64.iso"
( cd "$OUT" && sha256sum SpiralOS-1.0-amd64.iso > SpiralOS-1.0-amd64.iso.sha256 )
MB=$(du -m "$OUT/SpiralOS-1.0-amd64.iso" | cut -f1)
echo "Fertig: $OUT/SpiralOS-1.0-amd64.iso (${MB} MB)"
[ "$MB" -le 10240 ] || echo "WARNUNG: ISO ist groesser als 10 GB."
