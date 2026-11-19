if [ "$(id -u)" = 0 ] && systemctl is-active -q rescue.target 2>/dev/null; then
  echo "SpiralOS Notfallmodus: starte das Reparatur-Menue mit: spiralos-emergency"
fi
