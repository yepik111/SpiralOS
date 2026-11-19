#!/bin/bash
# Selbsttest: prueft Syntax und Konsistenz des ganzen Projekts
# Laeuft lokal und automatisch auf GitHub Actions.

cd "$(dirname "$0")/.." || exit 1

shopt -s nullglob

I=live/config/includes.chroot
B=$I/usr/local/bin

PASS=0
FAIL=0

ok() {
    PASS=$((PASS + 1))
}

bad() {
    FAIL=$((FAIL + 1))
    echo "FEHLER: $*"
}

# --------------------------------------------------
# 1. Syntax aller Programme
# --------------------------------------------------

for f in "$B"/*; do
    [ -f "$f" ] || continue

    case "$(head -n1 "$f")" in
        *python*)
            python3 -m py_compile "$f" 2>/dev/null \
                && ok \
                || bad "Python-Syntax: $f"
            ;;
        *sh*)
            sh -n "$f" 2>/dev/null \
                && ok \
                || bad "Shell-Syntax: $f"
            ;;
        *)
            bad "Keine Shebang-Zeile: $f"
            ;;
    esac
done

# Python-Cache entfernen
find . -name __pycache__ -type d -prune -exec rm -rf {} 2>/dev/null

# --------------------------------------------------
# 2. Hooks pruefen
# --------------------------------------------------

for f in live/config/hooks/live/*; do
    [ -f "$f" ] || continue

    sh -n "$f" 2>/dev/null \
        && ok \
        || bad "Hook-Syntax: $f"
done

# --------------------------------------------------
# 3. Build-Skripte pruefen
# --------------------------------------------------

bash -n build.sh \
    && ok \
    || bad "build.sh"

bash -n "$I/etc/bash_completion.d/spiralos" \
    && ok \
    || bad "bash_completion"

# --------------------------------------------------
# 4. i18n pruefen
# --------------------------------------------------

if python3 - <<'PY'
import sys

sys.path.insert(
    0,
    "live/config/includes.chroot/usr/local/lib/spiralos"
)

import i18n

sys.exit(
    0 if all(
        len(v) == len(i18n.EN)
        for v in i18n.T.values()
    )
    else 1
)
PY
then
    ok
else
    bad "i18n.py: Textlaengen je Sprache stimmen nicht"
fi

# --------------------------------------------------
# 5. Nachrichten-Datei pruefen
# --------------------------------------------------

awk -F'\t' 'NF != 15 { exit 1 }' \
    "$I/usr/local/lib/spiralos/msgs.tsv" \
    && ok \
    || bad "msgs.tsv: Spaltenanzahl"

# --------------------------------------------------
# 6. Paketlisten pruefen
# --------------------------------------------------

for L in live/config/package-lists/*.chroot; do
    [ -f "$L" ] || continue

    if grep -vE '^(#|$)' "$L" | grep -qE '[[:space:]]'; then
        bad "Leerzeichen in Paketliste: $L"
    else
        ok
    fi

    D=$(grep -vE '^(#|$)' "$L" | sort | uniq -d)

    if [ -z "$D" ]; then
        ok
    else
        bad "Doppelte Pakete in $L: $D"
    fi
done

# --------------------------------------------------
# 7. Desktop-Starter pruefen
# --------------------------------------------------

for f in "$I"/usr/share/applications/*.desktop; do
    [ -f "$f" ] || continue

    c=$(grep -m1 '^Exec=' "$f" |
        sed 's/^Exec=//' |
        awk '{print $1}')

    case "$c" in
        sh|firefox-esr|xfce4-terminal|xflock4|thunar)
            ok
            ;;
        *)
            if [ -f "$B/$c" ]; then
                ok
            else
                bad "Starter ohne Programm: $f -> $c"
            fi
            ;;
    esac
done

# --------------------------------------------------
# 8. Programm-Verweise pruefen
# --------------------------------------------------

for r in $(
    grep -ohE 'spiralos-[a-z]+' \
        "$B/spiralos-center" \
        "$B/spiralos-welcome" \
        "$B/spiralos-help" 2>/dev/null |
        sort -u
); do

    if [ -f "$B/$r" ]; then
        ok
    else
        echo "$r" |
            grep -qE '^spiralos-(live|ssh|autoclean|firewall|postinstall|eventd)$' \
            || bad "Verweis auf fehlendes Programm: $r"
    fi
done

# --------------------------------------------------
# 9. YAML-Dateien pruefen
# --------------------------------------------------

for y in .github/workflows/*.yml tools/*.yml; do
    [ -f "$y" ] || continue

    python3 -c '
import yaml
import sys

yaml.safe_load(open(sys.argv[1]))
' "$y" 2>/dev/null \
        && ok \
        || bad "YAML: $y"
done

# --------------------------------------------------
# 10. Windows-Dateien auf CRLF pruefen
# --------------------------------------------------

BAT_FILES=( *.bat tools/*.bat )

if [ "${#BAT_FILES[@]}" -eq 0 ]; then
    bad "Keine .bat-Dateien gefunden"
else
    for f in "${BAT_FILES[@]}"; do

        if python3 - "$f" <<'PY'
import sys

path = sys.argv[1]

with open(path, "rb") as file:
    data = file.read()

# CRLF muss vorhanden sein.
if b"\r\n" not in data:
    sys.exit(1)

# Keine einzelnen LF oder CR erlauben.
cleaned = data.replace(b"\r\n", b"")

if b"\n" in cleaned or b"\r" in cleaned:
    sys.exit(1)

sys.exit(0)
PY
        then
            ok
        else
            bad "Kein korrektes Windows-Zeilenende (CRLF): $f"
        fi

    done
fi

# --------------------------------------------------
# 11. Fremde Markennamen pruefen
# --------------------------------------------------

if grep -rIil 'debian\|ubuntu' "$I" \
    --exclude-dir=doc \
    --exclude-dir=man \
    >/tmp/brand.$$ 2>/dev/null \
    && [ -s /tmp/brand.$$ ]; then

    bad "Fremde Markennamen in der Oberflaeche: $(tr '\n' ' ' </tmp/brand.$$)"

else
    ok
fi

rm -f /tmp/brand.$$

# --------------------------------------------------
# 12. SVG-Icons pruefen
# --------------------------------------------------

for f in "$I"/usr/share/icons/SpiralOS/scalable/apps/*.svg; do
    [ -f "$f" ] || continue

    grep -q '<svg' "$f" \
        && ok \
        || bad "Icon: $f"
done

# --------------------------------------------------
# Ergebnis
# --------------------------------------------------

echo
echo "======================================"
echo " SpiralOS Selbsttest"
echo "======================================"
echo "Bestanden: $PASS"
echo "Fehler:    $FAIL"
echo "======================================"

if [ "$FAIL" -eq 0 ]; then
    echo "Alles OK!"
    exit 0
else
    echo "Selbsttest fehlgeschlagen!"
    exit 1
fi