@echo off
SETLOCAL ENABLEDELAYEDEXPANSION
SET LinkName=Cygwin64 Terminal
SET Esc_LinkDest=%%HOMEDRIVE%%%%HOMEPATH%%\Desktop\!LinkName!.lnk
SET Esc_LinkTarget=%~dp0bin\mintty.exe
SET Esc_LinkArguments= -i /Cygwin-Terminal.ico -
SET Esc_IconLocation=%~dp0Cygwin-Terminal.ico
SET cSctVBS=CreateShortcut.vbs
SET LOG=".\%~N0_runtime.log"
((
  echo Set oWS = WScript.CreateObject^("WScript.Shell"^) 
  echo sLinkFile = oWS.ExpandEnvironmentStrings^("!Esc_LinkDest!"^)
  echo Set oLink = oWS.CreateShortcut^(sLinkFile^) 
  echo oLink.TargetPath = oWS.ExpandEnvironmentStrings^("!Esc_LinkTarget!"^)
  echo oLink.Arguments = oWS.ExpandEnvironmentStrings^("!Esc_LinkArguments!"^)
  echo oLink.IconLocation = oWS.ExpandEnvironmentStrings^("!Esc_IconLocation!"^)
  echo oLink.Save
)1>!cSctVBS!
cscript //nologo .\!cSctVBS!
DEL !cSctVBS! /f /q
)1>>!LOG! 2>>&1
DEL !LOG!