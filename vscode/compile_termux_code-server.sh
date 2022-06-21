# Termux pack codeserver

## step1, compile code-server
### change repo and update if necessarily
    # termux-change-repo

### Install dependencies, including python, nodejs, and yarn
    pkg install -y python nodejs yarn git
### use Alibaba agent to speed up downloading if in CN
    yarn config set registry https://registry.npm.taobao.org
### Install code-server, this step will take a while
    yarn global add code-server
### test code-server
    code-server -v

#============================
## step2, pack to deb file
version=3.9.1
output=~/code-server_aarch64_termux_$version.deb
    rm -rf ~/fakeroot
### make a dir, let's assume it fakeroot
    mkdir ~/fakeroot

### copy and order the compiled program data into it
    cd ~/fakeroot
    mkdir -p data/data/com.termux/files/usr/bin/
    cp $PREFIX/bin/code-server data/data/com.termux/files/usr/bin/
    mkdir -p data/data/com.termux/files/home/.config
    cp -r ~/.config/yarn/ data/data/com.termux/files/home/.config/

### create 'DEBIAN' folder and 'control', 'md5sums' files
if [ ! -d DEBIAN ];then
  mkdir DEBIAN 
fi
chmod 755 DEBIAN
### create a 'control' file or copy from elsewhere
cat > DEBIAN/control \
<< EOF
Package: code-server
Version: $version
Section: devel
Priority: optional
Architecture: aarch64
Maintainer: Anmol Sethi <hi@nhooyr.io>
Vendor: Coder
Homepage: https://github.com/zongou/code-server-termux
Description: Run VS Code in the browser, packed by zongou.
EOF
### make a 'md5sum' file, this step is not necessarily
#    md5sum $(find usr -type f) > DEBIAN/md5sums

### pack to deb file
    dpkg -b ~/fakeroot/ $output
