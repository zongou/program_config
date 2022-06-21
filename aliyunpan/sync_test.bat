@echo off

set localDir="D:\mirrors\sync_test"
set remoteDir="/mirrors/sync_test"

rem [upload|download|sync] (default: upload)
set syncMode=upload

rem [1 ~ 10] (default: 0)
set downloadParallel=10

rem [1 ~ 10] (0 follows config file) (default: 0)
set uploadParallel=10

rem recommands：[1024 ~ 10240] (unit: KB) (default: 1024)
set downloadBlockSize=1024

rem recommands：[1024 ~ 10240] (unit: KB) (default: 10240)
set uploadBlockSize=10240

aliyunpan sync start ^
-ldir %localDir% ^
-pdir %remoteDir% ^
-mode %syncMode% ^
-dp %downloadParallel% ^
-up %uploadParallel% ^
-dbs %downloadBlockSize% ^
-ubs %uploadBlockSize%
