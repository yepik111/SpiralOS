#!/bin/bash
# Bootet das ISO headless in QEMU und prueft per Screenshot, ob etwas angezeigt wird
ISO="${1:-out/SpiralOS-1.0-amd64.iso}"
command -v qemu-system-x86_64 >/dev/null || { echo "QEMU fehlt (apt install qemu-system-x86)"; exit 1; }
rm -f /tmp/sp.ppm /tmp/sp.sock
qemu-system-x86_64 -m 4096 -cdrom "$ISO" -boot d -display none -monitor unix:/tmp/sp.sock,server,nowait ${KVM:+-enable-kvm} &
Q=$!; echo "Warte 150 s auf den Start ..."; sleep 150
python3 - <<'PY'
import socket,time
s=socket.socket(socket.AF_UNIX); s.connect("/tmp/sp.sock"); s.send(b"screendump /tmp/sp.ppm\n"); time.sleep(3)
d=open("/tmp/sp.ppm","rb").read(); body=d[d.find(b"255\n")+4:]
lit=sum(1 for b in body[::97] if b>40)/max(1,len(body[::97]))
print("Bildschirm zeigt Inhalt: %.0f%% heller Pixel"%(lit*100)); raise SystemExit(0 if lit>0.02 else 1)
PY
R=$?; kill $Q 2>/dev/null; [ $R = 0 ] && echo "TEST OK: ISO startet und zeigt ein Bild." || echo "TEST FEHLGESCHLAGEN: schwarzer Bildschirm."; exit $R
