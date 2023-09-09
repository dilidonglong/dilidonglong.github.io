---
title: wireshark技巧
date: 2019-04-30 23:40:03
categories: 小技巧
tags:
---

# wireshark技巧

> 资料来源：
>
> [1.EMC中文支持论坛](<https://community.emc.com/go/chinese>)
>
> [2.如果看了这个你还是不会用Wireshark-那就来找我吧-8月6日完结](https://www.dell.com/community/%E6%95%B0%E6%8D%AE%E5%AD%98%E5%82%A8%E8%AE%A8%E8%AE%BA%E5%8C%BA/%E5%A6%82%E6%9E%9C%E7%9C%8B%E4%BA%86%E8%BF%99%E4%B8%AA%E4%BD%A0%E8%BF%98%E6%98%AF%E4%B8%8D%E4%BC%9A%E7%94%A8Wireshark-%E9%82%A3%E5%B0%B1%E6%9D%A5%E6%89%BE%E6%88%91%E5%90%A7-8%E6%9C%886%E6%97%A5%E5%AE%8C%E7%BB%93/td-p/7007033/page/5)
>
> [3.Linux命令手册-tcpdump](http://linux.51yip.com/search/tcpdump)
>
> [4.Linux上使用wireshark(tshark)抓包分析](https://chegva.com/3019.html)
>
> [5.tcpdump使用技巧](https://chegva.com/2473.html)

## 1.抓包前设置过滤条件（捕捉过滤器）

**尽量避免使用抓包过滤。即便多看几个报文，也比漏看一个报文要好。**当你抓取了大量报文的时候，用显示过滤（过滤选项也更多）来重点查看某一数据流。

### 1.1 抓取指定IP地址的数据流：

1. host 10.3.1.1：抓取发到/来自10.3.1.1的数据流
2. host 2406:da00:ff00::6b16:f02d：抓取发到/来自IPv6地址2406:da00:ff00::6b16:f02d的数据流
3. not host 10.3.1.1：抓取除了发到/来自10.3.1.1以外的所有数据流
4. src host 10.3.1.1：抓取来自10.3.1.1的数据流
5. dst host 10.3.1.1：抓取发到10.3.1.1的数据流
6. host 10.3.1.1 or 10.3.1.2：抓取发到/来自10.3.1.1，以及与之通讯的所有数据流，与10.3.1.2，以及与之通讯的所有数据流
7. host www.espn.com：抓取发到/来自所有解析为www.espn.com的IP地址的数据流

<!--more-->



### 1.2 抓取指定IP地址范围的数据流:

1. net 10.3.0.0/16：抓取网络10.3.0.0上发到/来自所有主机的数据流(16表示长度)
2. net 10.3.0.0 mask 255.255.0.0：与之前的过滤结果相同
3. ip6 net 2406:da00:ff00::/64：抓取网络2406:da00:ff00:0000(IPv6)上发到/来自所有主机的数据流
4. not dst net 10.3.0.0/16：抓取除了发到以10.3开头的IP地址以外的所有数据流
5. not src net 10.3.0.0/16：抓取除了来自以10.3开头的IP地址以外的所有数据流
6. ip proto < protocol code >：抓取ip协议字段等于< protocol code >值的报文。如TCP(code 6), UDP(code 17), ICMP(code 1)。
7. ip[2:2]==< number >：ip报文大小
8. ip[8]==< number >：TTL(Time to Live)值
9. ip[9]==< number >：协议值
10. icmp[icmptype]==< identifier >: 抓取 ICMP代码等于identifier的ICMP报文, 如icmp-echo 以及 icmp-request。

方括号中第一个数字表示从<u>**协议头**</u>开始的偏移量，第二个数字表示需要观察多少位。

{% asset_img 1.png This is an test image %}





### 1.3 抓取发到广播或多播地址的数据流:

只需侦听广播或多播数据流，就可以掌握网络上主机的许多信息。

1. ip broadcast：抓取广播报文
2. ip multicast：抓取多播报文
3. dst host ff02::1：抓取到IPv6多播地址所有主机的数据流
4. dst host ff02::2：抓取到IPv6多播地址所有路由器的数据流



### 1.4 抓取基于MAC地址的数据流:

当你需要抓取发到/来自某一主机的IPv4或IPv6数据流，可创建基于主机MAC地址的抓包过滤条件。

应用MAC地址时，需确保与目标主机处于同一网段。

1. ether host 00:08:15:00:08:15：抓取发到/来自00:08:15:00:08:15的数据流
2. ether src 02:0A:42:23:41:AC：抓取来自02:0A:42:23:41:AC的数据流
3. ether dst 02:0A:42:23:41:AC：抓取发到02:0A:42:23:41:AC的数据流
4. not ether host 00:08:15:00:08:15：抓取除了发到/来自00:08:15:00:08:15以外的所有数据流
5. ether broadcast或ether dst ff:ff:ff:ff:ff:ff：抓取广播报文
6. ether multicast：多播报文
7. 抓取指定以太网类型的报文：ether proto 0800
8. 抓取指定VLAN：vlan < vlan number >
9. 抓取指定几个VLAN：vlan < vlan number > and vlan < vlan number >



### 1.5 抓取基于指定应用的数据流:

你可能需要查看基于一个或几个应用的数据流。抓包过滤器语法无法识别应用名，因此需要根据端口号来定义应用。通过目标应用的TCP或UDP端口号，将不相关的报文过滤掉。

1. port 53：抓取发到/来自端口53的UDP/TCP数据流（典型是DNS数据流）
2. not port 53：抓取除了发到/来自端口53以外的UDP/TCP数据流
3. port 80：抓取发到/来自端口80的UDP/TCP数据流（典型是HTTP数据流）
4. udp port 67：抓取发到/来自端口67的UDP数据流（典型是DHCP据流）
5. tcp port 21：抓取发到/来自端口21的TCP数据流（典型是FTP命令通道）
6. portrange 1-80：抓取发到/来自端口1-80的所有UDP/TCP数据流
7. tcp portrange 1-80：抓取发到/来自端口1-80的所有TCP数据流



### 1.6 抓取结合端口的数据流:

当你需要抓取多个不连续端口号的数据流，将它们通过逻辑符号连接起来，如下图所示：

1. port 20 or port 21：抓取发到/来自端口20或21的UDP/TCP数据流（典型是FTP数据和命令端口）
2. host 10.3.1.1 and port 80：抓取发到/来自10.3.1.1端口80的数据流
3. host 10.3.1.1 and not port 80：抓取发到/来自10.3.1.1除了端口80以外的数据流
4. udp src port 68 and udp dst port 67：抓取从端口68到端口67的所有UDP数据流（典型是从DHCP客户端到DHCP服务器）
5. udp src port 67 and udp dst port 68：抓取从端口67到端口68的所有UDP数据流（典型是从DHCP服务器到DHCP客户端）
6. 抓取TCP连接的开始（SYN）和结束（FIN）报文，配置tcp[tcpflags] & (tcp-syn|tcp-fin)!=0
7. 抓取所有RST(Reset)标志位为1的TCP报文，配置tcp[tcpflags] & (tcp-rst)!=0
8. less < length >：抓取小于等于某一长度的报文，等同于len <=< length >
9. greater < length >：抓取大于等于某一长度的报文，等同于len >=< length >



SYN: 建立连接的信号

FIN: 关闭连接的信号

ACK: 确认接收数据的信号

RST: 立即关闭连接的信号

PSH: 推信号，尽快将数据转由应用处理



- tcp[13] & 0x00 = 0: No flags set (null scan)
- tcp[13] & 0x01 = 1: FIN set and ACK not set
- tcp[13] & 0x03 = 3: SYN set and FIN set
- tcp[13] & 0x05 = 5: RST set and FIN set
- tcp[13] & 0x06 = 6: SYN set and RST set
- tcp[13] & 0x08 = 8: PSH set and ACK not set
- tcp[13]是从<u>**协议头**</u>开始的偏移量，0,1,3,5,6,8是标识位。

{% asset_img 2.png This is an test image %}





------

## 2.抓包后设置过滤条件（显示过滤器）

### 2.1 协议过滤器

1. arp：显示所有包括ARP请求和回复在内的所有ARP数据流。
2. ip：显示内含IPv4头在内的（如ICMP目的地址不可达报文，在ICMP报文头之后返回到来方向的IPv4头）IP数据流。
3. ipv6：显示所有IPv6数据流，包括内含IPv6报文头的IPv4报文，如6to4，Teredo，以及ISATAP数据流。
4. tcp：显示所有基于TCP的数据流。



### 2.2 应用过滤器

1. bootp：显示所有DHCP数据流（基于BOOTP）。
2. dns：显示包括TCP区域传输以及基于标准UDP的DNS请求和回复在内的所有DNS数据流。
3. tftp：显示所有TFTP（Trivial File Transfer Protocol）数据流。
4. http：显示所有HTTP命令，回复以及数据传输报文，但不显示TCP握手报文，TCP ACK报文以及TCP结束报文。
5. icmp：显示所有ICMP报文。



### 2.3 字符过滤器

1. tcp.analysis.flags：显示所有包含TCP分析标识的所有报文，包括报文丢失，重传，或零窗口标识。
2. tcp.analysis.zero_window：显示含有表明发送方的接收缓存用完标识的报文。



### 2.4 域过滤器

1. boot.option.hostname：显示所有包含主机名的DHCP数据流（DHCP基于BOOTP）。
2. http:host：显示所有包含HTTP主机名字段的所有HTTP报文。此报文是客户端向网络服务器发送请求时发出的。
3. ftp.request.command：显示所有包含命令的FTP数据流，比如USER，PASS，或RETR命令。



### 2.5 显示过滤器的比较运算符

1. ==或eq

   例如：ip.src == 10.2.2.2

   显示所有源地址为10.2.2.2的IPv4数据流

2. ！=或ne

   例如：tcp.srcport != 80

   显示源端口除了80以外的所有TCP数据流

3. gt 或 >

   例如：frame.time_relative > 1

   显示距前一个报文到达时间相差1秒的报文

4. <或lt

   例如：tcp.window_size < 1460

   显示当TCP接收窗口小于1460字节时的报文

5. ge 或 >=

   例如：dns.count.answers >= 10

   显示包含10个以上answer的DNS响应报文

6. <=或le

   例如：ip.ttl <= 10

   显示IP报文中Time to Live字段小于等于10的报文

7. contains

   例如：http contains “GET”

   显示所有HTTP客户端发送给HTTP服务器的GET请求



对于基于TCP应用的过滤条件采用比较运算符。例如，如果想看端口80上面的HTTP数据流，使用HTTP.port==80。

小贴士：

运算符两边不用留空格。ip.src == 10.2.2.2与ip.src==10.2.2.2的效果是相同的。



### 2.6 举例应用

#### 2.6.1 按照某一IP地址或主机过滤报文：

- 例如：ip.addr==10.3.1.1

  显示在IP源地址字段或IP目的地址字段包含10.3.1.1的帧。

  ------

- 例如：！ip.addr==10.3.1.1

  显示除了在IP源地址字段或IP目的地址字段包含10.3.1.1以外的帧。

  ------

- 例如：ipv6.addr==2406:da00:ff00::6b16:f02d

  显示以2406:da00:ff00::6b16:f02d为源地址或目的地址的帧。

  ------

- 例如：ip.src==10.3.1.1

  显示所有来自10.3.1.1的数据流。

  ------

- 例如：ip.dst==10.3.1.1

  显示所有发往10.3.1.1的数据流

  ------

- 例如：ip.host==www.wireshark.org

  显示所有解析为www.wireshark.org的IP

  ------



#### 2.6.2 按照某一IP地址范围过滤报文：

可以使用>或<比较运算符或逻辑运算符&&查找某一地址范围内的报文。

- 例如：ip.addr>10.3.0.1&&ip.addr<10.3.0.5

  显示来自或发往10.3.0.2，10.3.0.3，10.3.0.4的数据流。

  ------

- 例如：(ip.addr>=10.3.0.1&&ip.addr<=10.3.0.6)&&!ip.addr==10.3.0.3

  显示来自或发往10.3.0.1，10.3.0.2，10.3.0.4，10.3.0.5，10.3.0.6的数据流，10.3.0.3排除在外。

  ------

- 例如：ipv6.addr>=fe80::&&ipv6.addr<fec0::

  显示IPv6地址从0xfe80到0xfec0开头的数据流。

  ------



#### 2.6.3 按照某一IP子网过滤报文：

可以通过ip.addr字段名定义一个子网。这种格式使用IP地址后跟斜杠以及一个后缀，表明IP地址中定义的网络部分的比特数。

- 例如：ip.addr==10.3.0.0/16

  显示在IP源地址或目的地址字段以10.3开头的数据流。

  ------

- 例如：ip.addr == 10.3.0.0/16 && ！ip.addr==10.3.1.1

  显示除了10.3.1.1以外，在IP源地址或目的地址字段以10.3开头的数据流。

  ------

- 例如：!ip.addr == 10.3.0.0/16 && !ip.addr==10.2.0.0/16

  显示所有数据流，除了在IP源地址或目的地址字段以10.3和10.2开头的数据流

  ------



> 注意：
>
> 错误的用法导致不work：
>
> ------
>
> 错误：ip.addr != 10.2.2.2
>
> 显示在IP源地址或IP目的地址不包含10.2.2.2的报文。只要在源或目的IP地址不为10.2.2.2，报文就会被显示出来。这时隐含的或会导致实际上并未过滤任何报文。
>
> 正确：！ip.addr == 10.2.2.2
>
> 显示IP源地址和IP目的地址都不包含10.2.2.2的报文。
>
> ------
>
> 错误：!tcp.flags.syn==1
>
> 显示所有不含TCP SYN bit设置为1的报文。其他协议报文，必须UDP和ARP报文也符合这一过滤条件，因为它们的TCP SYN bit没有设置为1。
>
> 正确：tcp.flags.syn！=1
>
> 只显示包含SYN设置为0的TCP报文。
>
> ------

