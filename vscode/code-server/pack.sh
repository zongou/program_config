#============================
## step2, pack to deb file
# echo "version?"
# read version
workdirname=workdir
workdir=~/$workdirname

cd $workdir

# orgnize dirs
    mv node_modules/code-server ./
    mv node_modules/* code-server/node_modules/
    
    version=$(node code-server/out/node/entry.js -v| awk '{print $1}')
    ARCHITECTURE=$(uname -m)
    echo "code-server version: "$version
    echo "ARCHITECTURE: "$ARCHITECTURE
    
### make a dir, let's assume it fakeroot
    debdir=fakeroot
    if [ -d $debdir ]; then rm -rf $debdir; fi
    mkdir $debdir

### copy and order the compiled program data into it

    # copy binaries
    install_location="data/data/com.termux/files/usr/lib/node_modules"
    mkdir -p $debdir/$install_location
    

    # copy to installdir
    cp -r code-server $debdir/$install_location/

### create 'DEBIAN' folder and 'control', 'md5sums' files
if [ ! -d $debdir/DEBIAN ];then
  mkdir $debdir/DEBIAN 
fi
### create a 'control' file or copy from elsewhere
cat > $debdir/DEBIAN/control <<EOF
Package: code-server
Version: $version
Section: devel
Priority: optional
Architecture: aarch64
Pre-Depends: nodejs
Maintainer: Anmol Sethi <hi@nhooyr.io>
Vendor: Coder
Homepage: https://github.com/zongou/code-server-termux
Description: Run VS Code in the browser, pack script written by zongou.
EOF

# postinst
cat > $debdir/DEBIAN/postinst <<EOF
ln -s $PREFIX/lib/node_modules/code-server/out/node/entry.js $PREFIX/bin/code-server
EOF

# postrm
cat > $debdir/DEBIAN/postrm <<EOF
rm $PREFIX/bin/code-server
EOF

# empower permission
chmod 755 $debdir/DEBIAN
chmod 775 $debdir/DEBIAN/postinst $debdir/DEBIAN/postrm

### make a 'md5sum' file, this step is not necessarily
#    md5sum $(find usr -type f) > DEBIAN/md5sums

### pack and save deb file
    v=$(node -v); v=${v#v}; v=${v%%.*};
    output_location=$workdir/code-server_termux_"$ARCHITECTURE"_node"$v"_"$version".deb
    dpkg -b $debdir $output_location
    echo "output location: "$output_location
