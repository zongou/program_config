 #!/data/data/com.termux/files/usr/bin/bash
cd ${HOME}
if [ -f "/data/data/com.termux/files/usr/bin/wget" -a -f "/data/data/com.termux/files/usr/bin/curl" -a -f "/data/data/com.termux/files/usr/bin/proot" -a -f "/data/data/com.termux/files/usr/bin/pulseaudio" ]; then
echo -e "[35m 开始检测工具是否存在...... [0m"
sleep 1
echo -e "[32m 工具存在，开始进行下一步... [0m"
else
echo -e "[31m 检测完成，工具缺少! 开始尝试安装需要的工具! [0m"
pkg update
pkg install -y wget curl proot pulseaudio
fi

if [ -f "DebianforMacOS-theme1.0.tar.xz" ]; then
    echo -e "[32m DebianforMacOS-theme1.0.tar.xz 文件存在! [0m"
else
echo -e "[31m 未检测到DebianforMacOS-theme1.0.tar.xz文件!开始下载系统!服务器带宽小，等待时间稍长...... [0m"
    wget -c http://106.13.229.181/DebianforMacOS-theme1.0.tar.xz
fi

if [ -d "debian-fs" ]; then
echo -e "[32m 已检测到debian-fs文件夹存在，即将停止此脚本! [0m"
sleep 1
exit
else
echo -e "[31m 未检测到debian-fs文件夹，脚本继续进行中... [0m"
fi


if [ -f "DebianforMacOS-theme1.0.tar.xz" ]; then
tar xpf DebianforMacOS-theme1.0.tar.xz
else
echo -e "[31m 未检测到DebianforMacOS-theme1.0.tar.xz文件! [0m"
fi


if [ -d "debian-fs" ]; then
   echo "load-module module-native-protocol-tcp listen=0.0.0.0 auth-anonymous=1" >> /data/data/com.termux/files/usr/etc/pulse/default.pa
   echo "#!/bin/bash
export PULSE_SERVER=tcp:0.0.0.0:4713
xrdb $HOME/.Xresources
startxfce4 &" > /data/data/com.termux/files/home/debian-fs/root/.vnc/xstartup
exit 
   else
   echo -e "[31m 请检查系统是否解压成功检测不到debian-fs文件夹的存在！[0m"
fi
echo -e "[35m 完成！即将退出！ [0m"
sleep 2
exit 

