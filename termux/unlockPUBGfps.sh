configdir="/storage/emulated/0/Android/data/com.tencent.tmgp.pubgmhd/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/Config/Android"
checkFile="[ -f $configdir/EnjoyCJZC.ini ]"

createFile(){
    echo -e  "\

[FansSwitcher]
+CVars=r.PUBGMaxSupportQualityLevel=2
+CVars=r.PUBGDeviceFPSLow=6
+CVars=r.PUBGDeviceFPSMid=6
+CVars=r.PUBGDeviceFPSHigh=6
+CVars=r.PUBGDeviceFPSHDR=6
+CVars=r.PUBGMSAASupport=1
+CVars=r.PUBGLDR=1 \
" > $configdir/EnjoyCJZC.ini
}
enable(){
    createFile
    if $checkFile;then
        echo "enabled now"
    else
        echo "enable failed"
    fi
    exit
}
disable(){
    rm $configdir/EnjoyCJZC.ini
    if $checkFile;then
        echo "disable failed"
    else
        echo "disable succeed"
    fi
    exit
}

status(){
    if $checkFile;then
        echo "status: enabled"
    else
        echo "status: disabled"
    fi
}



# main
echo "this script will enable/disable fpslock"
status
echo "type 1 to enable, typy 0 to disable"
while read -p "option:" option;do
case $option in
    "1") enable
        ;;
    "0") disable
        ;;
    *) echo "no match, try again"
        ;;
esac
done

