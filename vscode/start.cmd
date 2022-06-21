@echo off
cd /d %~dp0
call:set_absolute_path USERPROFILE .\.portable\User
call:set_absolute_path APPDATA .\.portable\User\AppData\Roaming
call:set_absolute_path mingwbin .\.portable\mingw64\bin
set path=%mingwbin%;%path%
start Code.exe %1
exit

:set_absolute_path
for /f %%p in ("%2") do (set %1=%%~fp)
goto:eof 