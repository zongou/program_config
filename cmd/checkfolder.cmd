@echo off
if not exist %CD%\.virtualbox (
	echo "not exists"
	echo "making dir"
	mkdir tmpdir
	)else (
	echo "exists
	)
pause