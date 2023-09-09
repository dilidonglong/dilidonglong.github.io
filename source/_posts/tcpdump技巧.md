---
title: tcpdump技巧
date: 2019-04-30 23:44:49
categories: linux
tags:
---

# tcpdump使用技巧

1.监视指定网络接口的数据包

   [root@www ~]# tcpdump -i eth1                          

2.也可以指定ip,例如截获所有210.27.48.1 的主机收到的和发出的所有的数据包

   [root@www ~]# tcpdump host 210.27.48.1       

3.截获主机210.27.48.1 和主机210.27.48.2 或210.27.48.3的通信

   [root@www ~]# tcpdump host 210.27.48.1 and \ (210.27.48.2 or 210.27.48.3 \ )      

4.获取主机210.27.48.1除了和主机210.27.48.2之外所有主机通信的ip包

   [root@www ~]# tcpdump ip host 210.27.48.1 and ! 210.27.48.2     

5.截获主机webserver发送的所有数据

   [root@www ~]# tcpdump -i eth0 src host webserver 

6.监视所有送到主机webserver的数据包       

   [root@www ~]# tcpdump -i eth0 dst host webserver        

7.获取主机210.27.48.1接收或发出的telnet包

   [root@www ~]# tcpdump tcp port 23 and host 210.27.48.1       

8.打印所有源地址或目标地址是本地主机的IP数据包

   [root@www ~]# tcpdump ip and not net localnet       

 9.打印长度超过576字节

   [root@www ~]# tcpdump ip[2:2] > 576     

10.第一个n表示以IP地址的方式显示主机名，第二个N是以端口数字的形式代替服务名。

   [root@www ~]# tcpdump -nn 

------

[root@www ~]# tcpdump tcp -i eth1 -t -s 0 -c 100 and dst port ! 22 and src net 192.168.1.0/24 -w ./target.cap
(1)tcp: ip icmp arp rarp 和 tcp、udp、icmp这些选项等都要放到第一个参数的位置，用来过滤数据报的类型
(2)-i eth1 : 只抓经过接口eth1的包
(3)-t : 不显示时间戳
(4)-s 0 : 抓取数据包时默认抓取长度为68字节。加上-S 0 后可以抓到完整的数据包
(5)-c 100 : 只抓取100个数据包
(6)dst port ! 22 : 不抓取目标端口是22的数据包
(7)src net 192.168.1.0/24 : 数据包的源网络地址为192.168.1.0/24
(8)-w ./target.cap : 保存成cap文件，方便用ethereal(即wireshark)分析