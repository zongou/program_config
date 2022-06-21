workdir="/storage/emulated/0/termux"

# configure JDK
jdk_pkg="/sdcard/termux/software/openjdk11_jvdroid.deb"
dpkg -i $jdk_pkg

# configure jdt.ls
jdtls_pkg="$workdir/vim/jdt-language-server-*.tar.gz"
jdtdir=~/".config/coc/extensions/coc-java-data/server"

mkdir -p $jdtdir
tar -xzvf $jdtls_pkg -C $jdtdir/

# install coc plugins
vim -c "CocInstall coc-java coc-snippets" -c "echo 'after coc plugins installed, all done'"
