---
title: iptables笔记
date: 2019-08-11 21:25:59
categories: linux
tags:
---

# iptables笔记

> [朱双印博客-iptables规则](http://www.zsythink.net/archives/category/%E8%BF%90%E7%BB%B4%E7%9B%B8%E5%85%B3/iptables/)

数据经过防火墙流程图

{% asset_img 1.png This is an test image %}

<!--more-->



------





## 1.查找规则

> - iptables  -t  表名  -L
> - iptables  -t  表名  -L  链名                    #-L显示链名下的表名规则
> - iptables  -t  表名  -vL  链名                  #-v显示详细信息
> - iptables  -t  表名  -nvL  链名               #-n不进行地址解析
> - iptables  -t  表名  -xnvL  链名             #-x显示精确计数值
> - iptables  --line  -t  表名  -xnvL  链名             #--line在规则前加上序列号





## 2.添加规则

> - iptables  -t  表名  -A  链名  匹配条件  -j  动作
>
> `iptables -t filter -A INPUT -s 192.168.1.1 -j DROP`   #-A插入到规则最后
>
> - iptables  -t  表名  -I  链名  匹配条件  -j  动作
>
> `iptables -t filter -I INPUT -s 192.168.1.1 -j ACCEPT`  #-I插入到规则开头
>
> - iptables  -t  表名  -I  链名  规则序号  匹配条件  -j  动作
>
> `iptables -t filter -I INPUT 5 -s 192.168.1.1 -j REJECT`  #在第五行规则中插入
>
> - iptables  -t  表名  -P  链名  动作 
>
> `iptables -t filter -P INPUT REJECT`           #设置INPUT链中filter表的默认规则





## 3.删除规则

> - 按规则序号删除
>   iptables  -t  表名  -D  链名  规则序号 
>
> `iptables -t filter -D INPUT 5`     
>
> - 按匹配条件与动作删除
>
> iptables  -t  表名  -D  链名  匹配条件  -j  匹配动作 
>
> `iptables -t filter -D INPUT -s 192.168.1.1 -j ACCEPT`     
>
> - 删除某个链下指定表的所有规则
>
> iptables  -t  表名  -F  链名  
>
> `iptables -t filter -F INPUT`     
>
> - 删除所有链下指定表的所有规则
>
> iptables  -t  表名  -F 
>
> `iptables -t filter -F`   





## 4.修改规则

如果要修改规则，必须要指明原规则中的匹配条件（或者理解为只能修改动作）

> iptables  -t  表名  -R  链名  规则序号  规则原始匹配条件  -j  动作
>
> `iptables -t filter -R INPUT 3 -S 192.168.1.1 -J ACCEPT`
>
> 另外一种方式是，先删除规则。再在原来的位置添加规则   





## 5.保存规则

{% asset_img 2.png This is an test image %}



## 6.匹配条件

### 6.1基本匹配条件

- -s用于匹配源IP地址。可以指定多个IP地址，多个IP地址间用“，”号隔开；也可以指定IP网段

`iptables -t filter -I INPUT -s 192.168.1.111,192.168.1.118 -j DROP`

`
iptables -t filter -I INPUT -s 192.168.1.0/24 -j ACCEPT`

`
iptables -t filter -I INPUT ! -s 192.168.1.0/24 -j ACCEPT`

------

- -d用于匹配目的IP地址。可以指定多个IP地址，多个IP地址间用“，”号隔开；也可以指定IP网段

`iptables -t filter -I OUTPUT -d 192.168.1.111,192.168.1.118 -j DROP`

`
iptables -t filter -I INPUT -d 192.168.1.0/24 -j ACCEPT`

`
iptables -t filter -I INPUT ! -d 192.168.1.0/24 -j ACCEPT`

------

- -p用于匹配协议类型，常见的匹配类型有TCP、UDP、ICMP、ESP、AH等

`iptables -t filter -I INPUT -p tcp -s 192.168.1.146 -j ACCEPT`

`
iptables -t filter -I INPUT ! -p udp -s 192.168.1.146 -j ACCEPT`

------

- -i表示从哪个网卡接口流入本机，不能用于output链和postrouting链
- -o表示从哪个网卡接口流出本机，不能用于prerouting链和input链



### 6.2扩展匹配条件(如果协议和扩展模块一致，扩展模块可省略)

TCP扩展模块：

- -p tcp -m tcp --sport，用于匹配协议源端口，可以用冒号":"指定一个连续的端口范围(udp类似)
- -p tcp -m tcp --dport，用于匹配协议目的端口，可以用冒号":"指定一个连续的端口范围（udp类似）

`iptables -t filter -I OUTPUT -d 192.168.1.146 -p tcp -m tcp --sport 22 -j REJECT`

`
iptables -t filter -I INPUT -s 192.168.1.146 -p tcp -m tcp --dport 22:25 -j REJECT`

`
iptables -t filter -I INPUT -s 192.168.1.146 -p tcp -m tcp --dport :22 -j REJECT`

`
iptables -t filter -I INPUT -s 192.168.1.146 -p tcp -m tcp --dport 80: -j REJECT`

`
iptables -t filter -I OUTPUT -d 192.168.1.146 -p tcp -m tcp ! --sport 22 -j ACCEPT`



- --tcp-flags用于匹配tcp头部中的标志位

`iptables -t filter -I INPUT -p tcp -m tcp --dport 22 --tcp-flags SYN,ACK,FIN,RST,URG,PSH SYN -j REJECT`

`iptables -t filter -I OUTPUT -p tcp -m tcp --sport 22 --tcp-flags SYN,ACK,FIN,RST,URG,PSH SYN,ACK -j REJECT`

`
iptables -t filter -I INPUT -p tcp -m tcp --dport 22 --tcp-flags ALL SYN -j REJECT`

`
iptables -t filter -I OUTPUT -p tcp -m tcp --sport 22 --tcp-flags ALL SYN,ACK -j REJECT`

- --syn,相当于使用了“--tcp-flags SYN,ACK,FIN,RST SYN”

`iptables -t filter -I INPUT -p tcp -m tcp --dport 22 --syn -j REJECT`

------

multiport扩展模块：

- -p tcp -m multiport --sports，用于匹配协议源端口，可以用逗号","指定多个离散端口
- -p tcp -m multiport --dports，用于匹配协议目的端口，可以用逗号","指定多个离散端口

`iptables -t filter -I OUTPUT -d 192.168.1.146 -p udp -m multiport --sports 137,138 -j REJECT`

`iptables -t filter -I INPUT -s 192.168.1.146 -p tcp -m multiport --dports 22,80 -j REJECT`

`iptables -t filter -I INPUT -s 192.168.1.146 -p tcp -m multiport ! --dports 22,80 -j REJECT`

`iptables -t filter -I INPUT -s 192.168.1.146 -p tcp -m multiport --dports 80:88 -j REJECT`

`iptables -t filter -I INPUT -s 192.168.1.146 -p tcp -m multiport --dports 22,80:88 -j REJECT`

------

[icmp扩展模块（略）](http://www.zsythink.net/archives/1588)

[state扩展模块（略，但是概念重要）](http://www.zsythink.net/archives/1597)





## 7.匹配动作

- 动作SNAT，进行源地址转换(公网是固定IP)

`iptables -t nat -A POSTROUTING -s 10.1.0.0/16 -j SNAT --to-source 公网IP`

- 动作MASQUERADE，进行源地址转换（公网是动态IP）

`iptables -t nat -A POSTROUTING -s 10.1.0.0/16 -o eth0 -j MASQUERADE`



- 动作DNAT，进行目的地址转换

`iptables -t nat -I PREROUTING -d 公网IP -p tcp --dport 公网端口 -j DNAT --to-destination 私网IP:端口号`

`iptables -t nat -I PREROUTING -d 公网IP -p tcp --dport 8080 -j DNAT --to-destination 10.1.0.1:80`

`iptables -t nat -A POSTROUTING -s 10.1.0.0/16 -j SNAT --to-source 公网IP`

- 动作REDIRECT，进行本机端口重定向

`iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8080`