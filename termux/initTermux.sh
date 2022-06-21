# change greeting
echo "Wellcome to Termux!">/data/data/com.termux/files/usr/etc/motd
mv /data/data/com.termux/files/usr/etc/motd /data/data/com.termux/files/usr/etc/motd.bak

# change repo
#sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.ustc.edu.cn/termux/termux-packages-24 stable main@' $PREFIX/etc/apt/sources.list
#sed -i 's@^\(deb.*games stable\)$@#\1\ndeb https://mirrors.ustc.edu.cn/termux/game-packages-24 games stable@' $PREFIX/etc/apt/sources.list.d/game.list
#sed -i 's@^\(deb.*science stable\)$@#\1\ndeb https://mirrors.ustc.edu.cn/termux/science-packages-24 science stable@' $PREFIX/etc/apt/sources.list.d/science.list
#apt update

checkStoragePermission(){
    if [ ! -w /storage/emulated/0 ];then
        echo "Permission denied"
        exit
    fi
}

# remove storage dir if exists
if [ -d ~/storage ];then
    rm -rf ~/storage
fi
