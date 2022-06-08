@echo off
REM This script MUST be started in the Visual Studio Developer Command Prompt!

REM Make windows DLL (required to access the exports via LuaJIT FFI)
cd llhttp\release
cl /LD /O2 /I include src/api.c src/http.c src/llhttp.c -o ..\..\llhttp.dll /link /DEF:..\..\llhttp.def

REM And restore the cwd so we can run it repeatedly
cd ..
cd ..

REM Cleanup of msvc temporary files
if exist *.exp del *.exp
if exist *.lib del *.lib