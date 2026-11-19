#!/bin/bash
# Selbsttest: prueft Syntax und Konsistenz des ganzen Projekts (laeuft auch automatisch auf GitHub)
cd "$(dirname "$0")/.." || exit 1
I=live/config/includes.chroot; B=$I/usr/local/bin; PASS=0; FAIL=0
ok() { PASS=$((PASS+1)); }; bad() { FAIL=$((FAIL+1)); echo "FEHLER: $*"; }
for f in "$B"/*; do [ -f "$f" ] || continue
  case "$(head -n1 "$f")" in
    *python*) python3 -m py_compile "$f" 2>/dev/null && ok || bad "Python-Syntax: $f" ;;
    *sh*) sh -n "$f" 2>/dev/null && ok || bad "Shell-Syntax: $f" ;;
    *) bad "keine Shebang-Zeile: $f" ;;
  esac
done
find . -name __pycache__ -type d -prune -exec rm -rf {} + 2>/dev/null
for f in live/config/hooks/live/*; do sh -n "$f" 2>/dev/null && ok || bad "Hook-Syntax: $f"; done
bash -n build.sh && ok || bad "build.sh"
bash -n "$I/etc/bash_completion.d/spiralos" && ok || bad "bash_completion"
if python3 - <<'PY'
import sys; sys.path.insert(0,"live/config/includes.chroot/usr/local/lib/spiralos")
import i18n
sys.exit(0 if all(len(v)==len(i18n.EN) for v in i18n.T.values()) else 1)
PY
then ok; else bad "i18n.py: Textlaengen je Sprache stimmen nicht"; fi
awk -F'\t' 'NF!=15{exit 1}' $I/usr/local/lib/spiralos/msgs.tsv && ok || bad "msgs.tsv: Spaltenanzahl"
for L in live/config/package-lists/*.chroot; do
  if grep -vE '^(#|$)' "$L" | grep -qE '[[:space:]]'; then bad "Leerzeichen in Paketliste: $L"; else ok; fi
  D=$(grep -vE '^(#|$)' "$L" | sort | uniq -d); [ -z "$D" ] && ok || bad "doppelte Pakete in $L: $D"
done
for f in $I/usr/share/applications/*.desktop; do
  c=$(grep -m1 '^Exec=' "$f" | sed 's/^Exec=//' | awk '{print $1}')
  case "$c" in sh|firefox-esr|xfce4-terminal|xflock4|thunar) ok ;; *) [ -f "$B/$c" ] && ok || bad "Starter ohne Programm: $f -> $c" ;; esac
done
for r in $(grep -ohE 'spiralos-[a-z]+' "$B/spiralos-center" "$B/spiralos-welcome" "$B/spiralos-help" | sort -u); do
  [ -f "$B/$r" ] || echo "$r" | grep -qE '^spiralos-(live|ssh|autoclean|firewall|postinstall|eventd)$' || bad "Verweis auf fehlendes Programm: $r"
done
for y in .github/workflows/*.yml tools/*.yml; do python3 -c "import yaml,sys;yaml.safe_load(open('$y'))" 2>/dev/null && ok || bad "YAML: $y"; done
for f in *.bat tools/*.bat; do grep -q $'\r' "$f" && ok || bad "kein Windows-Zeilenende (CRLF): $f"; done
if grep -rIil 'debian\|ubuntu' "$I" --exclude-dir=doc --exclude-dir=man >/tmp/brand.$$ 2>/dev/null && [ -s /tmp/brand.$$ ]; then bad "Fremde Markennamen in der Oberflaeche: $(tr '\n' ' ' </tmp/brand.$$)"; else ok; fi
for f in $I/usr/share/icons/SpiralOS/scalable/apps/*.svg; do grep -q '<svg' "$f" && ok || bad "Icon: $f"; done
echo "Selbsttest: $PASS bestanden, $FAIL Fehler"
[ "$FAIL" = 0 ]
