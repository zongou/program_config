# https://wiki.termux.com/wiki/Backing_up_Termux

# define presets
backupDir="/storage/emulated/0/termux/backups"
termuxRoot="/data/data/com.termux"

show_help(){
echo "\
Examples:
-b archive.tgz          # Make backup to archive.tgz.
-r archive.tgz          # Restore from archive.tgz.
-l                      # list backups.
--help                  # show help information.\
"
}

get_session_mode(){
    if command -v termux-info >/dev/null 2>&1; then 
        echo "NORMAL"
    else 
        echo "FAILSAFE"
    fi
}

# check storage permission
checkStoragePermission(){
    if [ ! -w /storage/emulated/0 ]; then
        echo "Permission denied"
        exit 1
    fi
}

checkBackupDirExsits(){
    checkStoragePermission
    if [ ! -d $backupDir ]; then
        echo "backupDir: "[$backupDir]
        echo " not exists"
        # ask if to create dir
        echo "creat backupDir + [$backupDir]? (y/n)"
        read answer
        if [ "$answer"x = "y"x ]; then
            mkdir -p $backupDir
            if [ $? -ne 0 ]; then
                echo "create dir failed!"
                exit 1
            fi
        else
            echo "exiting..." && exit 1
        fi
    fi
}

checkBackupDirEmpty(){
    checkStoragePermission
    # check if backupDir is empty
    if [ $(ls -l $backupDir | grep "^-" | wc -l) -eq 0 ]; then
        echo "backupDir is empty!" && exit 1
    fi
}

cleanHistoryAndCache(){
    echo "start cleaning"
    termuxBashHistory=$termuxRoot"/files/home/.bash_history"
    if [ -f $termuxBashHistory ]; then
        echo "clean termuxBashHistory"
        rm $termuxBashHistory
    fi
    debianBashHistory=$termuxRoot"/files/home/debian-fs/root/.bash_history"
    if [ -f $debianBashHistory ]; then
        echo "clean debianBashHistory"
        rm $debianBashHistory
    fi
    jdtCacheDir=$termuxRoot"/files/home/.config/coc/extensions/coc-java-data"
    if [ -d $jdtCacheDir/jdt_ws_* ]; then
        ls $jdtCacheDir/jdt_ws_*
        rm -rf $jdtCacheDir/jdt_ws_*
    fi
}

# clean all but keep core functions, get 'rm' alike effect
removeAllExceptCoreFunctions(){
    # clean files dir
    cd $termuxRoot/files
    find * -maxdepth 0 | grep -vw 'usr' | xargs rm -rf
    # clean $PREFIX dir
    cd $termuxRoot/files/usr
    find * -maxdepth 0 | grep -vw '\(bin\|lib\)' | xargs rm -rf
    # clean bin dir
    cd $termuxRoot/files/usr/bin
    find * -maxdepth 0 | grep -vw '\(coreutils\|rm\|xargs\|find\|grep\|tar\|gzip\)' | xargs rm -rf
    # clean lib dir
    cd $termuxRoot/files/usr/lib
    find * -maxdepth 0 | grep -vw '\(libandroid-glob.so\|libtermux-exec.so\|libiconv.so\|libandroid-support.so\|libgmp.so\)' | xargs rm -rf
    # clean none exact utils, aggressively
    cd $termuxRoot/files/usr/bin
    rm coreutils grep xargs find rm ../lib/libgmp.so ../lib/libandroid-support.so

    # dependencies:
    # ls libandroid-support.so libgmp.so
    # rm libgmp.so
    # tar libandroid-glob libtermux-exec.so libiconv.so
}

backup(){
    # backup will fail when other linux system is installed, force running in NORMAL SESSION
    if [ $( get_session_mode ) = "FAILSAFE" ]; then
        echo "backup not available in [FAILSAFE SESSION]!"
        exit 1
    fi

    # check if backupDir exists
    checkBackupDirExsits

    # cleanHistoryAndCache
    echo "making backup..."
    cd $termuxRoot/files
    tar $VERBOSE -czf $backupDir/$2 ./home ./usr
    if [ $? -ne 0 ]; then
        echo "make sure running in termux default environment"
        exit 1
    fi
    echo -e "\033[0;32m backing up finished! \033[0m"
}

restore(){
    checkBackupDirExsits
    checkBackupDirEmpty

    # check if backup exits
    if [ ! -f $backupDir/$2 ]; then
        echo "no matched backup!" && exit 1
    fi

    echo "start restoring!"
    # use seperated steps is more compatible for lower version of toybox
    if [ $( get_session_mode ) = "FAILSAFE" ]; then
        rm -rf $termuxRoot/files/*
        gzip -d -c $backupDir/$2 | tar $VERBOSE -xf - -C $termuxRoot/files
    elif [ $( get_session_mode ) = "NORMAL" ]; then
        removeAllExceptCoreFunctions
        tar $VERBOSE -xzf $backupDir/$2 -C $termuxRoot/files
    fi
    echo -e "\033[0;32m restoring finished! \033[0m"
}

list_backups(){
    checkBackupDirExsits
    checkBackupDirEmpty
    ls $backupDir
}

# Begin
if [ $# -eq 1 ]; then                       # one arg
    if [ "$1"x = "--help"x ]; then
        show_help
        exit 0
    elif [ "$( echo $1 )"x != x ]; then
        while getopts "lh" opt
        do
            case $opt in
                l)
                    list_backups
                    break
                    ;;
                ?)
                    show_help
                    exit 1
                    ;;
            esac
        done
    fi
elif [ $# -eq 2 -a "$( echo $2 )"x != x ]; then        # two args and not empty string
    while getopts ":brv" opt
    do
        echo "[optValue]=$opt"
        case $opt in
            b)
                backup $*
                break
                ;;
            r)
                restore $*
                break
                ;;
            v)
                VERBOSE=-v
                ;;
            ?)
                show_help
                exit 1
                ;;
        esac
    done
else
    show_help
fi
