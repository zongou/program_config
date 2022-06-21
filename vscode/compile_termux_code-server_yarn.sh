# Termux pack codeserver

## step1, compile code-server
### change repo and update if necessarily
    # termux-change-repo

### Install dependencies, including python, nodejs, and yarn
    pkg install -y python nodejs yarn git
### use Alibaba agent to speed up downloading if in CN
    yarn config set registry https://registry.npm.taobao.org
### Install code-server, this step will take a while
    pkg install binutils;
    v=$(node -v); v=${v#v}; v=${v%%.*};
    FORCE_NODE_VERSION="$v" yarn global add code-server --ignore-engines;
### test code-server
    code-server -v

#============================
## step2, pack to deb file
#echo "version?"
#read version

version="$(code-server -v | awk '{print $1}')""                             4.2.0
output=~/code-server_aarch64_termux_$version.deb
    rm -rf ~/fakeroot
### make a dir, let's assume it fakeroot
    mkdir ~/fakeroot

### copy and order the compiled program data into it
    cd ~/fakeroot

    # mkdir -p data/data/com.termux/files/home/.config
    # cp -r ~/.config/yarn/global/node_modules/code-server data/data/com.termux/files/home/.config/

    # copy binaries
    node_modules_dir="data/data/com.termux/files/usr/lib/node_modules"
    mkdir -p $node_module_dir
    cp -r  ~/.config/yarn/global/node_modules/code-server/ $node_module_dir/

### create 'DEBIAN' folder and 'control', 'md5sums' files
if [ ! -d DEBIAN ];then
  mkdir DEBIAN 
fi
### create a 'control' file or copy from elsewhere
cat > DEBIAN/control <<EOF
Package: code-server
Version: $version
Section: devel
Priority: optional
Architecture: aarch64
Pre-Depends: nodejs
Maintainer: Anmol Sethi <hi@nhooyr.io>
Vendor: Coder
Homepage: https://github.com/zongou/code-server-termux
Description: Run VS Code in the browser, packed by zongou.
EOF

# postinst
cat > DEBIAN/postinst <<EOF
ln -s $PREFIX/lib/node_modules/code-server/out/node/entry.js $PREFIX/bin/code-server
EOF

# postrm
cat > DEBIAN/postrm <<EOF
rm $PREFIX/bin/code-server
EOF

# empower permission
chmod 755 DEBIAN
chmod 775 DEBIAN/postinst DEBIAN/postrm

### make a 'md5sum' file, this step is not necessarily
#    md5sum $(find usr -type f) > DEBIAN/md5sums

### pack to deb file
    dpkg -b ~/fakeroot/ $output