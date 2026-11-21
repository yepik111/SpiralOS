import sys,zlib,struct,math
S=256; px=bytearray(S*S*4)
def dot(x,y,r,c):
    for j in range(int(y-r),int(y+r)+1):
        for i in range(int(x-r),int(x+r)+1):
            if 0<=i<S and 0<=j<S and (i-x)**2+(j-y)**2<=r*r: k=(j*S+i)*4; px[k:k+4]=bytes(c)
n=2400
for s in range(n):
    t=s/n; th=t*6*math.pi; rad=6+(S/2-14)*t
    dot(S/2+rad*math.cos(th),S/2+rad*math.sin(th),4,(59,130,246,255) if t<0.7 else (239,68,68,255))
raw=b"".join(b"\x00"+bytes(px[j*S*4:(j+1)*S*4]) for j in range(S))
def ch(t,d): return struct.pack(">I",len(d))+t+d+struct.pack(">I",zlib.crc32(t+d)&0xffffffff)
open(sys.argv[1],"wb").write(b"\x89PNG\r\n\x1a\n"+ch(b"IHDR",struct.pack(">IIBBBBB",S,S,8,6,0,0,0))+ch(b"IDAT",zlib.compress(raw,9))+ch(b"IEND",b""))
