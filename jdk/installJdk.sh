#install JDK
echo "installing JDK"

# check folder
jvmdir="/opt/jvm"
if [ ! -d $jvmdir ];then
    echo "jvm folder not exitst,creating new"
    mkdir -p $jvmdir
else
    echo "jvm folder ready"
fi
# extract package
package=/sdcard/termux/jdk/linux-jdk/OpenJDK*.tar.gz
tar -xzvf $package -C $jvmdir

cat << EOM | tee /etc/profile.d/jdk.sh
export JAVA_HOME=$jvmdir/$(ls $jvmdir)
export CLASSPATH=.:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar
export PATH=\$JAVA_HOME/bin:\$PATH
EOM
source /etc/profile.d/jdk.sh
java -version
echo "JDK configured"
