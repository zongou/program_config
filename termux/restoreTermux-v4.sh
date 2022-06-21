# https://wiki.termux.com/wiki/Backing_up_Termux

# define presets
backupDir="/storage/emulated/0/termux/backups"
rootDir=$(dirname $(dirname $PREFIX))

#----------------------------------------------------------------------------+
#Color picker, usage: printf $BLD$CUR$RED$BBLU'Hello World!'$DEF             |
#-----------------------------+------------------------------------+---------+
#         Text color          |         Background color           |         |
#-------------+---------------+----------------+-------------------+         |
# Base color  | Lighter shade | Base color     | Lighter shade     |         |
#-------------+---------------+----------------+-------------------+         |
BLK='\033[30m'; blk='\033[90m'; BBLK='\033[40m'; bblk='\033[100m' #| Black   |
RED='\033[31m'; red='\033[91m'; BRED='\033[41m'; bred='\033[101m' #| Red     |
GRN='\033[32m'; grn='\033[92m'; BGRN='\033[42m'; bgrn='\033[102m' #| Green   |
YLW='\033[33m'; ylw='\033[93m'; BYLW='\033[43m'; bylw='\033[103m' #| Yellow  |
BLU='\033[34m'; blu='\033[94m'; BBLU='\033[44m'; bblu='\033[104m' #| Blue    |
MGN='\033[35m'; mgn='\033[95m'; BMGN='\033[45m'; bmgn='\033[105m' #| Magenta |
CYN='\033[36m'; cyn='\033[96m'; BCYN='\033[46m'; bcyn='\033[106m' #| Cyan    |
WHT='\033[37m'; wht='\033[97m'; BWHT='\033[47m'; bwht='\033[107m' #| White   |
#-------------------------------{ Effects }------------------------+---------+
DEF='\033[0m'   #Default color and effects                                   |
BLD='\033[1m'   #Bold\brighter                                               |
DIM='\033[2m'   #Dim\darker                                                  |
CUR='\033[3m'   #Italic font                                                 |
UND='\033[4m'   #Underline                                                   |
INV='\033[7m'   #Inverted                                                    |
COF='\033[?25l' #Cursor Off                                                  |
CON='\033[?25h' #Cursor On                                                   |
#------------------------------{ Functions }---------------------------------+
# Text positioning, usage: XY 10 10 'Hello World!'                           |
XY(){ printf "\033[$2;${1}H$3"; }                                           #|
# Print line, usage: line - 10 | line -= 20 | line 'Hello World!' 20         |
line(){ printf -v _L %$2s; printf -- "${_L// /$1}"; }                       #|
# Create sequence like {0..(X-1)}, usage: que 10                             |
que(){ printf -v _N %$1s; _N=${_N// / 1}; printf "${!_N[*]}"; }             #|
#----------------------------------------------------------------------------+

# printf $BLD$CUR$RED$BBLU'Hello World!\n'$DEF

heading() { printf "${WHT}${BLD}${@}${DEF}"; }
info()    { printf "${cyn}${@}${DEF}"; }
warning() { printf "${mgn}Warning: ${@}${DEF}"; }
error()   { printf "${red}ERROR: ${@}${DEF}"; }
success() { printf "${grn}${@:-Successfully done.}${DEF}"; }
abort()   { printf "${RED}Abort. ${@}${DEF}\n"; exit 1; }

# debug=1
# if [ $debug -eq 1 ]; then
#     heading "heading\n"
#     info "info\n"
#     warning "warning\n"
#     error "error\n"
#     success "success\n"
#     # abort abort
# fi

show_help(){
echo "\
Examples:
-b archive.tgz          # Make backup to archive.tgz.
-r archive.tgz          # Restore from archive.tgz.
-vb archive.tgz         # Make backup to archive.tgz with verbose.
-vr archive.tgz         # Restore from archive.tgz with verbose.
-l                      # list backups.
--help                  # show help information.\
"
}

get_session_mode(){
    #LD_PRELOAD, TMPDIR
    if [ $LD_PRELOAD ]; then
        printf "NORMAL"
    else 
        printf "FAILSAFE"
    fi
}

# check storage permission
checkStoragePermission(){
    if [ ! -w /storage/emulated/0 ]; then
        abort "cannot access to storage"
    fi
}

checkBackupDirExsits(){
    checkStoragePermission
    if [ ! -d $backupDir ]; then
        error "backupDir: [$backupDir] not exists\n"
        # ask if to create dir
        warning "creat backupDir + [$backupDir]? (y/n)\n"
        read answer
        if [ "$answer"x = "y"x ]; then
            mkdir -p $backupDir
            if [ $? -ne 0 ]; then
                abort "create dir failed!"
            fi
        else
            abort "exiting..."
        fi
    fi
}

checkBackupDirEmpty(){
    checkStoragePermission
    # check if backupDir is empty
    if [ $(ls -l $backupDir | grep "^-" | wc -l) -eq 0 ]; then
        abort "backupDir is empty!"
    fi
}

askToOverride(){
    if [ -f $backupDir/$1 ]; then
        warning "file $1 exists! overide?(y/n)\n"
        read answer
        if [ "$answer" != "y" ]; then
            abort
        fi
    fi
}


kill_other_ttys(){
    current_tty=$(tty| awk -F':' '{ split($1, s, "dev/"); print s[2]}')
    info "current tty: ${ylw}$current_tty\n"
    ttys_to_kill=$(ps -e| awk '{if (NR>2){print $2}}'| grep -vw "\(?\|$current_tty\)")
    info "active ttys to kill: ${ylw}$(echo $ttys_to_kill| tr '\n' '\b')\n"
    # warning "ttys to kill: $(cat $ttys_to_kill)"
    for t in $ttys_to_kill; do
        pkill -9 -t "$t"
    done
}

kill_jobs(){
    jobs=$(ps -e|grep -vw '\(sh\|com.termux\|bash\|ps\|grep\|awk\|xargs\)'|awk '{if (NR>1){print $4}}')
    info "active jobs to kill: ${ylw}$jobs\n"
    for job in $jobs; do 
        pkill -9 $job
    done
}

kill_termux(){
    pkill -9 com.termux
}

cleanHistoryAndCache(){
    info "start cleaning\n"
    termuxBashHistory=$rootDir"/files/home/.bash_history"
    if [ -f $termuxBashHistory ]; then
        info "clean termuxBashHistory\n"
        rm $termuxBashHistory
    fi
    debianBashHistory=$rootDir"/files/home/debian-fs/root/.bash_history"
    if [ -f $debianBashHistory ]; then
        info "clean debianBashHistory\n"
        rm $debianBashHistory
    fi
    jdtCacheDir=$rootDir"/files/home/.config/coc/extensions/coc-java-data"
    if [ -d $jdtCacheDir/jdt_ws_* ]; then
        clean $jdtCacheDir/jdt_ws_*
        rm -rf $jdtCacheDir/jdt_ws_*
    fi
    # clean git ssh
    rm -rf ~/.git* ~/.ssh
}

# clean all but keep core functions, get 'rm' alike effect
removeAllExceptCoreFunctions(){
    # clean files dir
    cd $rootDir/files
    find * -maxdepth 0 | grep -vw 'usr' | xargs rm -rf
    # clean $PREFIX dir
    cd $rootDir/files/usr
    find * -maxdepth 0 | grep -vw '\(bin\|lib\)' | xargs rm -rf
    # clean bin dir
    cd $rootDir/files/usr/bin
    find * -maxdepth 0 | grep -vw '\(coreutils\|rm\|xargs\|find\|grep\|tar\|gzip\)' | xargs rm -rf
    # clean lib dir
    cd $rootDir/files/usr/lib
    find * -maxdepth 0 | grep -vw '\(libandroid-glob.so\|libtermux-exec.so\|libiconv.so\|libandroid-support.so\|libgmp.so\)' | xargs rm -rf
    # clean none exact utils, aggressively
    cd $rootDir/files/usr/bin
    rm coreutils grep xargs find rm ../lib/libgmp.so ../lib/libandroid-support.so

    # dependencies:
    # ls libandroid-support.so libgmp.so
    # rm libgmp.so
    # tar libandroid-glob libtermux-exec.so libiconv.so
}

backup(){
    # backup will fail when other linux system is installed, force running in NORMAL SESSION
    if [ $( get_session_mode ) = "FAILSAFE" ]; then
        abort "backup not available in [FAILSAFE SESSION]!"
    fi

    # check if backupDir exists
    checkBackupDirExsits
    askToOverride $2

    cleanHistoryAndCache
    info "Making backup...\n"
    cd $rootDir/files
    tar $VERBOSE -czf $backupDir/$2 ./home ./usr
    if [ $? -ne 0 ]; then
        abort "make sure running in termux default environment"
    fi
    success "Backup complete!\n"
}

restore(){
    checkBackupDirExsits
    checkBackupDirEmpty

    # check if backup exits
    if [ ! -f $backupDir/$2 ]; then
        abort "no matched backup!"
    fi

    warning "restoring will delete your termux data and kill running jobs. Press enter to continue or CTRL+c to quit"
    read ans

    info "kill activities\n"
    if [ $( get_session_mode ) = "NORMAL" ]; then
        kill_other_ttys
        kill_jobs
    fi
    
    # clean go dir
    

    # use seperated steps is more compatible for lower version of toybox
    if [ $( get_session_mode ) = "FAILSAFE" ]; then
        rm -rf $rootDir/files/*
        gzip -d -c $backupDir/$2 | tar $VERBOSE -xf - -C $rootDir/files
    elif [ $( get_session_mode ) = "NORMAL" ]; then
        removeAllExceptCoreFunctions
        info "restoring files!\n"
        tar $VERBOSE -xzf $backupDir/$2 -C $rootDir/files
    fi
    success "restoring complete!\n"
    warning 'Press enter to exit terminal\n'
    read ans
    kill_termux
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
elif [ $# -gt 1 -a $# -lt 4 -a "$( echo $2 )"x != x ]; then        # two args and not empty string
    while getopts ":vb:vr:" opt
    do
        case $opt in
            v)
                VERBOSE=-v
                ;;
            b)
                backup $*
                # break
                ;;
            r)
                restore $*
                # break
                ;;
            ?)
                show_help
                exit 1
                ;;
        esac
    done
# else
    # show_help
fi
