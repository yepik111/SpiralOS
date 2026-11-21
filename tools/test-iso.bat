@echo off
rem Startet das ISO im QEMU-Fenster (QEMU fuer Windows: https://www.qemu.org/download/#windows)
set ISO=%1
if "%ISO%"=="" set ISO=out\SpiralOS-1.0-amd64.iso
qemu-system-x86_64.exe -m 4096 -cdrom "%ISO%" -boot d
