![](https://csdnimg.cn/release/blogv2/dist/pc/img/original.png)

版权声明：本文为博主原创文章，遵循 [CC 4.0 BY-SA](http://creativecommons.org/licenses/by-sa/4.0/) 版权协议，转载请附上原文出处链接和本声明。

1、禁用APP

[adb](https://so.csdn.net/so/search?q=adb&spm=1001.2101.3001.7020) shell pm disable-user '包名'

2、解禁APP

adb shell pm enable '包名'

3、指定连接设备

adb -s 设备名 shell

4、安装apk

adb install 包名---

说明install后可加-r -t -s -d -p等关键字

\-r：替换已存在应用

\-t：测试package标识

\-s：将应用安装到adcard

\-d：忽略版本号

\-p：部分安装apk标志

使用命令安装deb文件

sudo apt install 文件.deb

5、卸载应用

adb uninstall 包名

6、卸载APP，但保存数据和缓存文件

adb uninstall -k 包名

7、adb 命令更改日期

adb shell date 0822216202021.00

7、查看手机所有包名

adb shell pm list packages

8、查看所有三方APP包名

adb shell pm list packages -3

删除所有第三方APP:

adb shell pm list packages -3|cut -d: -f2|grep -E "\[\\w.\]"|xargs -t -i adb uninstall {}

命令解释：

adb shell pm list packages -3 //表示列出第三方可卸载app软件  
| cut -d :-f2 //表示通过“:” 冒号分割取第二位程序  
| grep -E "\[\\w.\]" //表示找出符合条件的字符串(\\w表示字母、数字及下划线，.表示点号)正则匹配出来  
| xargs -t -i // xargs命令是给其他命令传递参数的一个过滤器 。-i 选项告诉 xargs 用每项的名称替换 {}。-t 选项指示 xargs 先打印命令，然后再执行  
adb uninstall {} // 依次卸载列出的第三方app  
原文链接：https://blog.csdn.net/moakey/article/details/105415884

9、清除应用数据和缓存信息

adb shell pm clear 包名

10、adb 命令修改时间

adb root;adb shell date 080816202021.00

11、 将手机卡中的某个文件复制到电脑

输入: adb pull 手机存储路径  电脑路径

12、从电脑端向手机复制文件

输入: adb push 电脑路径  手机存储路径  

13、repo 更新代码

repo sync -d --prune --force-sync --no-tags -f -j6

14、压缩与解压缩

解压tar文件：tar zxvf 文件名

压缩：zip -r name.zip 文件名

解压zip文件：unzip name.zip   --解压到当前目录下

unzip -o -d /home name.zip 

\-o ：不提示并且覆盖文件

\-d：指明文件解压到目录下