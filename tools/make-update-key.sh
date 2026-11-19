#!/bin/sh
cd "$(dirname "$0")/.." || exit 1
gpg --quick-generate-key "SpiralOS Updates" ed25519 sign never
mkdir -p live/config/includes.chroot/usr/share/spiralos
gpg --yes --output live/config/includes.chroot/usr/share/spiralos/update-key.gpg --export "SpiralOS Updates"
echo "Fertig. ISO neu bauen. Geheimen Schluessel sichern: gpg --armor --export-secret-keys 'SpiralOS Updates' > geheim.asc"
