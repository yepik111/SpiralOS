#!/usr/bin/env python3
"""Erzeugt das SpiralOS-Klangthema (kurze, weiche Toene)."""
import wave, struct, math, os
SR=22050
def render(notes):
    total=max(s+d for f,s,d in notes); buf=[0.0]*int(SR*(total+0.05))
    for f,s,d in notes:
        n=int(SR*d); o=int(SR*s)
        for i in range(n):
            e=math.exp(-5*i/n)*min(1,i/150)*min(1,(n-i)/150)
            buf[o+i]+=0.35*e*(math.sin(2*math.pi*f*i/SR)+0.25*math.sin(4*math.pi*f*i/SR))
    return buf
T={"service-login":[(523,0,.22),(659,.14,.22),(784,.28,.4)],"service-logout":[(784,0,.22),(659,.14,.22),(523,.28,.4)],
"message-new-instant":[(1319,0,.12),(1760,.1,.2)],"dialog-warning":[(440,0,.16),(440,.2,.16)],"dialog-error":[(247,0,.2),(196,.18,.3)],
"power-plug":[(523,0,.12),(784,.1,.2)],"power-unplug":[(784,0,.12),(523,.1,.2)],"bell":[(880,0,.3)],"audio-volume-change":[(1000,0,.05)],
"complete":[(523,0,.12),(659,.09,.12),(784,.18,.12),(1047,.27,.3)]}
d="live/config/includes.chroot/usr/share/sounds/SpiralOS/stereo/"; os.makedirs(d,exist_ok=True)
for n,notes in T.items():
    b=render(notes); w=wave.open(d+n+".wav","wb"); w.setnchannels(1); w.setsampwidth(2); w.setframerate(SR)
    w.writeframes(b"".join(struct.pack("<h",int(max(-1,min(1,x))*30000)) for x in b)); w.close()
open(d+"../index.theme","w").write("[Sound Theme]\nName=SpiralOS\nComment=SpiralOS sounds\nDirectories=stereo\nInherits=freedesktop\n\n[stereo]\nOutputProfile=stereo\n")
print(len(T),"Klaenge")
