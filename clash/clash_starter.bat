@echo off
set profile=openit.yaml
start %~dp0\clash-windows-amd64-v3.exe -d %~dp0 -f %~dp0\%profile%
