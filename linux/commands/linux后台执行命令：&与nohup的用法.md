---
created: 2022-04-17T02:47:00 (UTC +08:00)
tags: [Linux,Shell,程序员]
source: https://developer.aliyun.com/article/875904
author: 良许Linux
                    +关注
---

# linux后台执行命令：&与nohup的用法-阿里云开发者社区

> ## Excerpt
> linux后台执行命令：&与nohup的用法

---
大家可能有这样的体验：某个程序运行的时候，会产生大量的log，但实际上我们只想让它跑一下而已，log暂时不需要或者后面才有需要。所以在这样的情况下，我们希望程序能够在后台进行，也就是说，在终端上我们看不到它所打出的log。为了实现这个需求，我们介绍以下几种方法。

我们以下面一个test程序来模拟产生大量log的程序，这个程序每隔1秒就会打印一句“Hello world!”：

#include

#include

#include

int main()  
{

   fflush(stdout);

   setvbuf(stdout, NULL, \_IONBF, 0);

   while (1) {

       printf("Hello world!\\n");

       sleep(1);

   }

}

现在，我们想要一个清静的世界，终端上不要有大量的log出现，我们要求test程序在后台运行。

**&**

这种方法很简单，就是在命令之后加个“&”符号就可以了，如下：

./test &

这样一来，test程序就在后台运行了。但是，这样处理还不够，因为这样做虽然程序是在后台运行了，但log依然不停的输出到当前终端。因此，要让终端彻底的清静，还应将log重定向到指定的文件：

./test >> out.txt 2>&1 &

2>&1是指将标准错误重定向到标准输出，于是标准错误和标准输出都重定向到指定的out.txt文件中，从此终端彻底清静了。

但是这样做要注意，如果Test程序需要从标准输入接收数据，它就会在那死等，不会再往下运行。所以需要从标准输入接收数据，那这种方法最好不要使用。

那现在程序在后台运行了，我们怎么找到它呢？很简单，有两种方法：

**1\. jobs命令**

jobs命令可以查看当前有多少在后台运行。

jobs -l

此命令可显示所有任务的PID，jobs的状态可以是running, stopped, Terminated。但是如果任务被终止了（kill），shell 从当前的shell环境已知的列表中删除任务的进程标识。

**2\. ps命令**

ps aux | grep test

**nohup命令**

在命令的末尾加个&符号后，程序可以在后台运行，但是一旦当前终端关闭（即退出当前帐户），该程序就会停止运行。那假如说我们想要退出当前终端，但又想让程序在后台运行，该如何处理呢？

实际上，这种需求在现实中很常见，比如想远程到服务器编译程序，但网络不稳定，一旦掉线就编译就中止，就需要重新开始编译，很浪费时间。

在这种情况下，我们就可以使用nohup命令。nohup就是不挂起的意思( no hang up)。该命令的一般形式为：

nohup ./test &

如果仅仅如此使用nohup命令的话，程序的输出会默认重定向到一个nohup.out文件下。如果我们想要输出到指定文件，可另外指定输出文件：

nohup ./test > myout.txt 2>&1 &

这样一来，多管齐下，既使用了nohup命令，也使用了&符号，同时把标准输出/错误重定向到指定目录下。

使用了nohup之后，很多人就这样不管了，其实这样有可能在当前账户非正常退出或者结束的时候，命令还是自己结束了。所以在使用nohup命令后台运行命令之后，需要使用exit正常退出当前账户，这样才能保证命令一直在后台运行。

本公众号全部博文已整理成一个目录，请在公众号里回复「**m**」获取！

**推荐阅读：**

[资料 | 不再为PPT模板发愁了](http://mp.weixin.qq.com/s?__biz=MzU4MTU3OTI0Mg==&mid=2247484397&idx=1&sn=4f6a9b10708d27e7afccbd756cfeda6a&chksm=fd443b68ca33b27e702c2ccdd7475b6f0be59e6e5105b8bd1a223fbf7de36d8e6284c8fcbec5&scene=21#wechat_redirect)

[程序员提高文件查看效率的神器](http://mp.weixin.qq.com/s?__biz=MzU4MTU3OTI0Mg==&mid=2247484402&idx=1&sn=93c1467bef92659ed15e7355da2930a3&chksm=fd443b77ca33b261cc47837065fdb572370cdad3c1731a4f8a98d36903e809a38c866cda6466&scene=21#wechat_redirect)[](http://mp.weixin.qq.com/s?__biz=MzU4MTU3OTI0Mg==&mid=2247483932&idx=1&sn=599f8b25dacfa0b63ded8b4c96d06e97&chksm=fd443a99ca33b38f40bbba92ee3dda67fe97fad033b56c735e77acb5f7a0c65bfe7b33b17067&scene=21#wechat_redirect)

[Linux性能检测常用的10个基本命令](http://mp.weixin.qq.com/s?__biz=MzU4MTU3OTI0Mg==&mid=2247484406&idx=1&sn=84fb289eb05effe3d2956096d2369956&chksm=fd443b73ca33b2655b9d70359106ddaca49c04feab6b47595f2a68f22b2bf08c1b10ba8e2b9f&scene=21#wechat_redirect)

[](http://mp.weixin.qq.com/s?__biz=MzU4MTU3OTI0Mg==&mid=2247484402&idx=1&sn=93c1467bef92659ed15e7355da2930a3&chksm=fd443b77ca33b261cc47837065fdb572370cdad3c1731a4f8a98d36903e809a38c866cda6466&scene=21#wechat_redirect)[](http://mp.weixin.qq.com/s?__biz=MzU4MTU3OTI0Mg==&mid=2247483932&idx=1&sn=599f8b25dacfa0b63ded8b4c96d06e97&chksm=fd443a99ca33b38f40bbba92ee3dda67fe97fad033b56c735e77acb5f7a0c65bfe7b33b17067&scene=21#wechat_redirect)[Linux系统编程 | 进程间同步](http://mp.weixin.qq.com/s?__biz=MzU4MTU3OTI0Mg==&mid=2247484428&idx=1&sn=17f28efc8daeb5c417a38bcb9aeaa04b&chksm=fd443c89ca33b59f0270891889528dc6719190c4e30ca7d25a900fa8737284b1726fe946bfb6&scene=21#wechat_redirect)
