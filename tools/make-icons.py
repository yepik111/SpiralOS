#!/usr/bin/env python3
"""Erzeugt das SpiralOS-Icon-Set (SVG) fuer alle SpiralOS-Programme."""
import math, os
BL,RD,BG="#3b82f6","#ef4444","#242c3b"
def spiral(cx,cy,r0,r1,turns,a,b):
    pts=[(cx+(r0+(r1-r0)*t)*math.cos(turns*2*math.pi*t),cy+(r0+(r1-r0)*t)*math.sin(turns*2*math.pi*t)) for t in [i/80 for i in range(int(a*80),int(b*80)+1)]]
    return "M"+" L".join("%.1f %.1f"%p for p in pts)
def S(d,c=BL): return f'<path d="{d}" stroke="{c}"/>'
G={
"spiralos-center":S(spiral(32,32,3,20,2.4,0,.72))+S(spiral(32,32,3,20,2.4,.72,1),RD),
"spiralos-welcome":S(spiral(32,32,3,20,2.4,0,.72))+S(spiral(32,32,3,20,2.4,.72,1),RD),
"spiralos-settings":S("M16 22H48M16 32H48M16 42H48")+f'<circle cx="26" cy="22" r="4" fill="{BG}" stroke="{RD}"/><circle cx="38" cy="32" r="4" fill="{BG}" stroke="{RD}"/><circle cx="30" cy="42" r="4" fill="{BG}" stroke="{RD}"/>',
"spiralos-store":S("M18 28h28v18a4 4 0 0 1-4 4H22a4 4 0 0 1-4-4z")+S("M26 28v-4a6 6 0 0 1 12 0v4",RD),
"spiralos-search":f'<circle cx="28" cy="28" r="10" stroke="{BL}"/>'+S("M36 36L46 46",RD),
"spiralos-shot":S("M18 26V18h8M38 18h8v8M46 38v8h-8M26 46h-8v-8")+f'<circle cx="32" cy="32" r="5" stroke="{RD}"/>',
"spiralos-pass":f'<circle cx="24" cy="32" r="7" stroke="{BL}"/>'+S("M31 32H48")+S("M42 32v6M47 32v4",RD),
"spiralos-backupplan":S("M44 32a12 12 0 1 1-4-9M40 17v7h7")+S("M32 26v6l4 3",RD),
"spiralos-monitor":f'<rect x="14" y="18" width="36" height="26" rx="4" stroke="{BL}"/>'+S("M18 38l7-8 6 4 7-10 8 4",RD),
"spiralos-notes":f'<rect x="20" y="14" width="24" height="36" rx="4" stroke="{BL}"/>'+S("M26 24h12M26 31h12M26 38h7",RD),
"spiralos-calc":f'<rect x="18" y="14" width="28" height="36" rx="4" stroke="{BL}"/><rect x="22" y="18" width="20" height="7" stroke="{RD}"/>'+"".join(f'<circle cx="{x}" cy="{y}" r="2" fill="{BL}" stroke="none"/>' for x in (25,32,39) for y in (33,41)),
"spiralos-edit":S("M20 44l2-8 18-18 6 6-18 18z")+S("M36 22l6 6",RD),
"spiralos-view":f'<rect x="14" y="18" width="36" height="28" rx="4" stroke="{BL}"/><circle cx="25" cy="28" r="3" stroke="{RD}"/>'+S("M16 44l12-11 8 7 6-5 6 7"),
"spiralos-archive":f'<rect x="16" y="20" width="32" height="28" rx="4" stroke="{BL}"/>'+S("M16 28H48")+S("M32 28v6M32 38v6",RD),
"spiralos-power":S("M32 16v14",RD)+S("M23 22a14 14 0 1 0 18 0"),
"spiralos-install":S("M32 16v20M24 29l8 8 8-8")+S("M18 42v4h28v-4",RD),
"spiralos-docs":S("M32 20C26 16 20 16 16 18v28c4-2 10-2 16 2 6-4 12-4 16-2V18c-4-2-10-2-16 2z")+S("M32 20v28",RD),
"spiralos-hardware":f'<rect x="22" y="22" width="20" height="20" rx="3" stroke="{BL}"/><rect x="28" y="28" width="8" height="8" stroke="{RD}"/>'+S("M28 16v6M36 16v6M28 42v6M36 42v6M16 28h6M16 36h6M42 28h6M42 36h6"),
"spiralos-emergency":f'<circle cx="32" cy="32" r="16" stroke="{BL}"/>'+S("M32 24v10",RD)+f'<circle cx="32" cy="40" r="1.5" fill="{RD}" stroke="{RD}"/>',
"spiralos-update":S("M46 30A14 14 0 0 0 22 20M22 14v7h7")+S("M18 34A14 14 0 0 0 42 44M42 50v-7h-7",RD),
}
def svg(body): return f'<svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 64 64"><rect x="4" y="4" width="56" height="56" rx="14" fill="{BG}"/><g fill="none" stroke-width="4" stroke-linecap="round" stroke-linejoin="round">{body}</g></svg>\n'
base="live/config/includes.chroot/usr/share/icons/"
for d in ("SpiralOS/scalable/apps","hicolor/scalable/apps"):
    os.makedirs(base+d,exist_ok=True)
    for n,b in G.items(): open(f"{base}{d}/{n}.svg","w").write(svg(b))
open(base+"SpiralOS/index.theme","w").write("[Icon Theme]\nName=SpiralOS\nComment=SpiralOS icons\nInherits=Papirus-Dark,Adwaita,hicolor\nDirectories=scalable/apps\n\n[scalable/apps]\nSize=64\nMinSize=16\nMaxSize=512\nType=Scalable\nContext=Applications\n")
open(base+"../pixmaps/spiralos.svg","w") if os.path.isdir(base+"../pixmaps") else None
print(len(G),"Icons")
