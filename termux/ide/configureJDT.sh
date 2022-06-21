workdir="/storage/emulated/0/termux"

# configure jdt.ls
jdtls="$workdir/vim/jdt-language-server-*.tar.gz"
jdtdir=~/".config/coc/extensions/coc-java-data/server"

if [ -d $jdtdir ];then
	rm -rf $jdtdir/*
else
	mkdir -p $jdtdir
fi
tar -xzvf $jdtls -C $jdtdir/
