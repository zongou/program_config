1.安装[ssh](https://so.csdn.net/so/search?q=ssh&spm=1001.2101.3001.7020)服务  
sudo apt-get update #更新软件源  
sudo apt-get install ssh #安装  
2.修改sshd\_config文件，命令为：vi /etc/ssh/sshd\_config  
将#PasswordAuthentication no的注释去掉，并且将no修改为yes  
将#PermitRootLogin prohibit-password的注释去掉，将prohibit-password改为yes  
PasswordAuthentication yes  
PermitRootLogin yes  
或echo -e “PasswordAuthentication yes\\nPermitRootLogin yes” >> /etc/ssh/sshd\_config  
3.启动SSH服务，命令为：/etc/init.d/ssh start // 或者service ssh start  
4.验证SSH服务状态，命令为：/etc/init.d/ssh status  
5\. 添加开机自启动 update-rc.d ssh enable