# Gemeinsame GTK-Hilfen fuer SpiralOS-Programme (volle Unicode-/RTL-Unterstuetzung)
import gi, subprocess, threading, os, sys
gi.require_version("Gtk","3.0")
from gi.repository import Gtk, GLib, Gdk
sys.path.insert(0,"/usr/local/lib/spiralos")
from i18n import t, L
_css=Gtk.CssProvider()
_css.load_from_data(b"button{padding:6px 14px;border-radius:6px} entry{padding:6px 8px;border-radius:6px} notebook tab{padding:8px 16px}")
Gtk.StyleContext.add_provider_for_screen(Gdk.Screen.get_default(),_css,Gtk.STYLE_PROVIDER_PRIORITY_FALLBACK)
def t2(en,de): return de if L=="de" else en
def win(title,w=700,h=500):
    x=Gtk.Window(title=title,window_position=Gtk.WindowPosition.CENTER); x.set_default_size(w,h); x.connect("destroy",Gtk.main_quit); return x
def button(label,cb):
    b=Gtk.Button(label=label); b.connect("clicked",lambda _b:cb()); return b
def msg(parent,text):
    d=Gtk.MessageDialog(transient_for=parent,message_type=Gtk.MessageType.INFO,buttons=Gtk.ButtonsType.OK,text=text); d.run(); d.destroy()
def ask_text(parent,title,label,secret=False):
    d=Gtk.Dialog(title=title,transient_for=parent); d.add_buttons("OK",1,"Cancel",0)
    e=Gtk.Entry(visibility=not secret); b=d.get_content_area(); b.pack_start(Gtk.Label(label=label),False,False,6); b.pack_start(e,False,False,6)
    e.set_activates_default(True); d.set_default_response(1); d.show_all(); r=d.run(); v=e.get_text(); d.destroy(); return v if r==1 else None
class Out(Gtk.ScrolledWindow):
    def __init__(s,h=160):
        super().__init__(); s.tv=Gtk.TextView(editable=False,monospace=True); s.add(s.tv); s.set_size_request(-1,h)
    def put(s,txt,clear=False):
        b=s.tv.get_buffer()
        if clear: b.set_text("")
        b.insert(b.get_end_iter(),txt); return False
    def run(s,cmd):
        s.put("$ "+cmd+"\n",True)
        def w():
            p=subprocess.Popen(cmd,shell=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True)
            for l in p.stdout: GLib.idle_add(s.put,l)
        threading.Thread(target=w,daemon=True).start()
def sh(cmd): return subprocess.run(cmd,shell=True,capture_output=True,text=True).stdout
def run_app(w): w.show_all(); Gtk.main()
