@echo OFF
cl /nologo /LD /O2 /Ot LinkedList.c CallbackHandlers.c -o llhttp_ffi.dll /link /DEF:llhttp_ffi.def

REM Some optional cleanup to save disk space
if exist *.obj del *.obj
if exist *.exp del *.exp
if exist *.lib del *.lib