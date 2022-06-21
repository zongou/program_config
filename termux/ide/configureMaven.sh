mkdir $PREFIX/share/maven

tar -xzvf /sdcard/Download/apache-maven-*-bin.tar.gz -C ~/../usr/share/maven/

cat > $PREFIX/etc/profile.d/mvn.sh <<- EOF
export PATH=\$PATH:\$PREFIX/share/maven/"$(ls $PREFIX/share/maven/)"/bin
EOF

if [ ! -d ~/.m2 ];then mkdir ~/.m2; fi;
cat > ~/.m2/settings.xml <<- EOF
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                          https://maven.apache.org/xsd/settings-1.0.0.xsd">

    <mirrors>
        <mirror>
            <id>alimaven</id>
            <name>aliyun maven</name>
            <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
            <mirrorOf>central</mirrorOf>
        </mirror>
    </mirrors>
    <profiles>
        <profile>
            <id>jdk8</id>
            <activation>
                <activeByDefault>true</activeByDefault>
                <jdk>1.8</jdk>
            </activation>
            <properties>
                <maven.compiler.source>1.8</maven.compiler.source>
                <maven.compiler.target>1.8</maven.compiler.target>
                <maven.compiler.compilerVersion>1.8</maven.compiler.compilerVersion>
            </properties>
        </profile>
    </profiles>
</settings>
EOF
