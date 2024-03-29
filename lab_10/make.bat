@echo off
: -------------------------------
: if resources exist, build them
: -------------------------------
if not exist rsrc.rc goto over1
D:\masm32\BIN\Rc.exe /v rsrc.rc
D:\masm32\BIN\Cvtres.exe /machine:ix86 rsrc.res
:over1

if exist %1.obj del main.obj
if exist %1.exe del main.exe

: -----------------------------------------
: assemble template.asm into an OBJ file
: -----------------------------------------
D:\masm32\BIN\Ml.exe /c /coff main.asm
if errorlevel 1 goto errasm

if not exist rsrc.obj goto nores

: --------------------------------------------------
: link the main OBJ file with the resource OBJ file
: --------------------------------------------------
D:\masm32\BIN\Link.exe /SUBSYSTEM:WINDOWS main.obj rsrc.obj
if errorlevel 1 goto errlink
dir main.*
goto TheEnd

:nores
: -----------------------
: link the main OBJ file
: -----------------------
D:\masm32\BIN\Link.exe /SUBSYSTEM:WINDOWS main.obj
if errorlevel 1 goto errlink
dir main.*
goto TheEnd

:errlink
: ----------------------------------------------------
: display message if there is an error during linking
: ----------------------------------------------------
echo.
echo There has been an error while linking this project.
echo.
goto TheEnd

:errasm
: -----------------------------------------------------
: display message if there is an error during assembly
: -----------------------------------------------------
echo.
echo There has been an error while assembling this project.
echo.
goto TheEnd

:TheEnd