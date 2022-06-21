# Termux pack codeserver
    workdirname=workdir
    workdir=~/$workdirname

    if [ -d $workdir ];then rm -rf $workdir; fi
    mkdir -p $workdir
    
    cd $workdir

## step1, compile code-server
### change repo and update if necessarily
    # termux-change-repo

### Install dependencies, including python, nodejs, and yarn
    pkg install -y python nodejs-lts yarn git
### use Alibaba agent to speed up downloading if in CN
    yarn config set registry https://registry.npm.taobao.org
### Install code-server, this step will take a while
    pkg install binutils;
    v=$(node -v); v=${v#v}; v=${v%%.*};
    echo "node version: ""$(node -v)"
    FORCE_NODE_VERSION="$v" yarn add code-server --ignore-engines;
### test code-server
    # code-server -v
    
    # backup compiled binaries
    cd ~/
    tar -czf  /sdcard/"$workdirname"_backup.tgz $workdirname

