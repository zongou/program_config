#!/data/data/com.termux/files/usr/bin/bash

proot_bin=./proot


# cp $HOME/storage/shared/phone_backup/termux/debian-rootfs-arm64.tar.xz $HOME/debian-rootfs.tar.xz
# wget "ftp://192.168.3.150:2121/phone_backup/termux/debian-rootfs-arm64.tar.xz" -O $tarball
# https://mirrors.tuna.tsinghua.edu.cn/lxc-images/images/

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
this script installs linux with proot
Examples:
[tarball] [distro]
-b archive.tgz          # Make backup to archive.tgz.
-r archive.tgz          # Restore from archive.tgz.
-vb archive.tgz         # Make backup to archive.tgz with verbose.
-vr archive.tgz         # Restore from archive.tgz with verbose.
-l                      # list backups.
--help                  # show help information.\
"
}

cmd(){
    if [ ! $# -eq 2 ]; then 
        show_help
        echo $1 $2
    else
        tarball=$1
        distro=$2
        main
    fi
}

check_proot(){
    if [ ! $(command -v $proot_bin) ]; then
        proot_bin=proot
        if [ ! $(command -v $proot_bin) ]; then
            error "proot not found, install it? y/n\n"
            read ans
            if [ "$ans" = "y" ]; then
                pkg i proot -y > /dev/null 2>&1 || abort "Installing proot failed."
            else
                abort
            fi
        fi
    fi
}

decompress_rootfs(){
    cur=$(pwd)
    mkdir -p "$distro"
    info "Decompressing rootfs, please be patient.\n"
    $proot_bin --link2symlink tar -xf ${tarball} -C ${distro}||:
}

os_patch(){
    os_release=$distro/etc/os-release
    OS_ID=$(cat $os_release| awk -F= '/^ID=/ {print $2}')
    OS_VERSION_ID=$(cat $os_release| awk -F= '/^VERSION_ID=/ {print $2}')
    info "OS_ID: ${ylw}$OS_ID${DEF}\n";
    info "OS_VERSION_ID: ${ylw}$OS_VERSION_ID${DEF}\n"
    
    case $OS_ID in
#         busybox|alpine)
        #     login_shell=sh
        #     ;;
        # debian|ubuntu)
        #     login_shell=bash
            # ;;
        *)
            # check link and file, using -e || -h/-L or use grep
            
            if [  $(ls $distro/bin| grep ^bash$) ]; then
                login_shell=bash
            elif [ $(ls $distro/bin| grep ^sh$) ]; then
                login_shell=sh
            else
                login_shell=bash
            fi
            ;;
    esac

    info "Login shell: ${ylw}${login_shell}${DEF}\n"
}

fix_nameserver(){
    resolv_conf=$distro/etc/resolv.conf
    if [ -f $resolv_conf ] && [ -z $resolve_conf  ] || [ -h $resolv_conf  ]; then
        if [ -h $resovle_conf ]; then
            rm $resolv_conf
        fi
     cat > $resolv_conf <<- EOF
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF
    fi
}

write_launch_script(){
    bin=start-$distro.sh
    mkdir -p $distro-binds
    info "writing launch script\n"
    cat > $bin <<- EOF
#!/bin/bash
distro=$distro
proot_bin=$proot_bin

# check proot
command -v \$proot_bin >/dev/null 2>&1 || { command -v proot >/dev/null 2>&1 && proot_bin=proot; } || { echo "proot not found" && exit 1; }

cd \$(dirname \$0)
## unset LD_PRELOAD in case termux-exec is installed
unset LD_PRELOAD
command="\$proot_bin"
command+=" --link2symlink"
command+=" --kill-on-exit"
command+=" -S $HOME/\$distro"
if [ -n "\$(ls -A \$distro-binds)" ]; then
    for f in \$distro-binds/* ;do
      . \$f
    done
fi
command+=" -b /dev"
command+=" -b /proc"
command+=" -b \$distro/root:/dev/shm"
## uncomment the following line to have access to the home directory of termux
#command+=" -b /data/data/com.termux/files/home:/root"
## uncomment the following line to mount /sdcard directly to / 
command+=" -b /sdcard"
command+=" -w /root"
command+=" /usr/bin/env -i"
command+=" HOME=/root"
command+=" PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games"
command+=" TERM=\$TERM"
command+=" LANG=C.UTF-8"
command+=" /bin/$login_shell --login"
com="\$@"
if [ -z "\$1" ];then
    exec \$command
else
    \$command -c "\$com"
fi
EOF
}

final(){
    info "fixing shebang of $bin\n"
    termux-fix-shebang $bin
    info "making $bin executable\n"
    chmod +x $bin
    # echo "removing image for some space"
    # rm $tarball
    printf "${grn}You can now launch $distro with the${DEF} ${red}./${bin}${DEF} ${grn}script${DEF}\n"
    # echo "debian" >> .bashrc && cat .bashrc && mv start-debian.sh $PREFIX/bin/debian && mv $PREFIX/etc/motd $PREFIX/etc/motd.bak
}

main(){
    check_proot
    decompress_rootfs
    os_patch
    fix_nameserver
    write_launch_script
    final
}

cmd $*

