@echo OFF
cl /nologo /LD /O2 CallbackHandlers.c -o llhttp_ffi.dll /link /DEF:llhttp_ffi.def
cl /nologo /O2 TestLinkedList.c -o test.exe /link

REM Some optional cleanup to save disk space
if exist *.obj del *.obj
if exist *.exp del *.exp
if exist *.lib del *.lib