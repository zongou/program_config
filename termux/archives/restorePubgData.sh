pubgdir=/storage/emulated/0/Android/data/com.tencent.tmgp.pubgmhd
workdir=/storage/emulated/0
backupfile="pubgdata.tar.gz"

backup(){
    echo "now running backup"
    echo "will create "$backupfile
    echo "backing up..."
    cd $pubgdir
    tar -czvf $workdir/$backupfile ./files
    echo "created backup "$backupfile
}
restore(){
    echo "now running restore"
    if [ -f $workdir/$backupfile ];then
        echo "star restoring!"
        mkdir $pubgdir
        rm -rf $pubgdir/*
        tar -xzvf $workdir/$backupfile -C $pubgdir
        echo "restoring finished!"
    else
        echo "no $backupfile exits!"
    fi
}

echo "this script will backup/restore pubg file"
echo "type b to backup, type r to restore"
read -p "option:" option
case $option in
    "b") backup
        ;;
    "r") restore
        ;;
    *) echo "no match, quitting!"
        exit
        ;;
esac
