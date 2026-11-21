#!/usr/bin/env python3
"""Erzeugt Man-Pages (man spiralos-<befehl>) und docs/COMMANDS.md aus den Kommentaren der Skripte."""
import os, re, glob, datetime
B="live/config/includes.chroot/usr/local/bin/"; M="live/config/includes.chroot/usr/share/man/man1/"; os.makedirs(M,exist_ok=True)
rows=[]
for p in sorted(x for x in glob.glob(B+"*") if os.path.isfile(x)):
    n=os.path.basename(p); s=open(p,encoding="utf-8").read(); L=s.splitlines()
    c=next((l.lstrip("# ").strip() for l in L[1:8] if l.startswith("#") and not l.startswith("#!")),"")
    if c.startswith(n): syn,_,desc=c.partition(":"); syn=syn.strip(); desc=desc.strip() or c
    else:
        u=re.search(r'Usage: ([^"\n\']+)',s); syn=u.group(1).strip() if u else n; desc=c or "SpiralOS-Programm"
    rows.append((n,syn,desc))
    esc=lambda x:x.replace("\\","\\\\").replace("-","\\-")
    open(M+n+".1","w",encoding="utf-8").write(f'''.TH {n.upper()} 1 "{datetime.date.today():%Y-%m-%d}" "SpiralOS 1.0" "SpiralOS-Befehle"
.SH NAME
{esc(n)} \\- {esc(desc)}
.SH SYNOPSIS
.B {esc(syn)}
.SH DESCRIPTION
{esc(desc)}
.PP
Weitere Befehle: spiralos\\-help. Handbuecher: spiralos\\-docs.
.SH SEE ALSO
spiralos(7)
''')
open("live/config/includes.chroot/usr/share/man/man7/spiralos.7","w",encoding="utf-8").write('.TH SPIRALOS 7 "" "SpiralOS 1.0" "SpiralOS"\n.SH NAME\nspiralos \\- Uebersicht der SpiralOS-Befehle\n.SH DESCRIPTION\n'+"\n.br\n".join(f"{n.replace('-','\\-')}: {d.replace('-','\\-')}" for n,_,d in rows)+"\n")
md="# SpiralOS-Befehle\n\nAutomatisch erzeugt (`python3 tools/make-man.py`). Zu jedem Befehl gibt es `man <befehl>`.\n\n| Befehl | Aufruf | Beschreibung |\n|---|---|---|\n"+"".join("| `%s` | `%s` | %s |\n"%(n,s.replace("|","\\|"),d.replace("|","\\|")) for n,s,d in rows)
os.makedirs("docs",exist_ok=True); open("docs/COMMANDS.md","w",encoding="utf-8").write(md)
os.makedirs("live/config/includes.chroot/usr/share/doc/spiralos",exist_ok=True); open("live/config/includes.chroot/usr/share/doc/spiralos/COMMANDS.md","w",encoding="utf-8").write(md)
print(len(rows),"Man-Pages + COMMANDS.md erzeugt")
