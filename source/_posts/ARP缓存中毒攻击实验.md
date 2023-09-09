---
title: ARP缓存中毒攻击实验
date: 2019-10-07 20:14:47
categories: SEED Labs
tags: 
---

>参考文档：
>[官方原文档](https://seedsecuritylabs.org/Labs_16.04/PDF/ARP_Attack.pdf)
>
>[我们可以拿Scapy做什么](http://sinhub.cn/2018/06/what-can-we-do-with-scapy/)
>
>[Linux TCP/IP 协议栈调优](https://colobu.com/2014/09/18/linux-tcpip-tuning/)
>
>[Python黑客编程3网络数据监听和过滤](https://cloud.tencent.com/developer/article/1092683)

<br>

# 1. Overview

**1.概要**

The Address Resolution Protocol (ARP) is a communication protocol used for discovering the link layer address, such as a MAC address,  given an IP address.  The ARP protocol is a very simple protocol,  and it does not implement any security measure. The ARP cache poisoning attack is a common attack against the ARP protocol. Under such an attack, attackers can fool the victim into accepting forged IP-to-MAC mappings. This can cause the victim’s packets to be redirected to the computer with the forged MAC address.

地址解析协议（ARP）是一个用来发现数据链路层地址的通信协议，例如给出IP地址来获取MAC地址。ARP协议是一个非常简单的协议，并且它并没有实现任何安全措施。ARP缓存中毒攻击是一个依赖于ARP协议的常见攻击。在这种攻击下，攻击者可以欺骗受害者以接受伪造的IP到MAC映射。这可能导致受害者的数据包使用伪造的MAC地址重定向到计算机。

<!--more-->

The objective of this lab is for students to gain the first-hand experience on the ARP cache poisoning attack, and learn what damages can be caused by such an attack. In particular, students will use the ARP attack to launch a man-in-the-middle attack, where the attacker can intercept and modify the packets between the two victims A and B.

 这个实验的目的是为学生在ARP缓存中毒攻击上获得第一手的经验，并且学到通过这种攻击会导致什么样的危险。更重要的是，学生将使用ARP攻击来发起中间人攻击，攻击者可以在其中拦截和修改两个受害者A和B之间的数据包。

**Lab environment.** This lab has been tested on our pre-built Ubuntu 16.04 VM, which can be downloaded from the SEED website.

**实验环境。**该实验已经在预建的Ubuntu 16.04 VM上通过测试，该VM可以在SEED网页上下载。

**拓扑图如下：**在该图中，我们的主机1和3分别为该文档中的主机A和B，主机2则为该文档中的主机M

{% asset_img seedlab拓扑图.png This is an test image %}

<br>

# 2. Task 1: ARP Cache Poisoning

**2.任务1：ARP缓存中毒**

The objective of this task is to use packet spoofing to launch an ARP cache poisoning attack on a target, such that when two victim machines A and B try to communicate with each other, their packets will be intercepted by the attacker, who can make changes to the packets, and can thus become the man in the middle between A and B. This is called Man-In-The-Middle (MITM) attack. In this lab, we use ARP cahce poisoning to conduct an MITM attack.

这个实验的目标是，使用数据包欺骗来发起ARP缓存中毒攻击，以便当两个受害设备A与B试图互相通信时，它们的数据包将被攻击者截获，攻击者可以修改数据包，并且可以成为在A和B之间的中间人。这就是所谓的中间人(MITM)攻击。在该实验中，我们使用ARP缓存中毒来进行中间人攻击。

The following code skeleton（骨架，框架） shows how to construct an ARP packet using Scapy.

以下代码框架展示了如何使用Scapy构建ARP数据包。

```python
#!/usr/bin/python3
from scapy.all import *

E = Ether()
A = ARP()

pkt = E/A
sendp(pkt)
```

The above program constructs and sends an ARP packet. Please set necessary attribute（属性） names/values to define your own ARP packet. We can use ls(ARP) to see the attribute names of the ARP class. If a field is not set, a default value will be used (see the third column（纵行，列） of the output):

以上程序构建并发送了一个ARP包。请设置必要的属性名称/值来定义你自己的ARP数据包。我们可以使用ls(ARP)来查看ARP类中的属性名称。如果字段没有设置，则将使用默认的值（参考输出的第三列）：

```python
$ python3
>>> from scapy.all import *
>>> ls(ARP)
hwtype			: XShortField				= (1)
ptype			: XShortEnumField			= (2048)
hwlen			: ByteField					= (6)
plen			: ByteField					= (4)
op				: ShortEnumField			= (1)
hwsrc			: ARPSourceMACField			= (None)
psrc			: SourceIPField				= (None)
hwdst			: MACField					= ('00:00:00:00:00:00')
pdst			: IPField					= ('0.0.0.0')
```

> 注：在实验环境中，输入python，再输入上述内容是没有问题的。但是，如果输入python3，则会报错`ImportError: No module named 'scapy'`，对于该问题的[解决方案](https://stackoverflow.com/questions/46602880/importerror-no-module-named-scapy-all)如下，注意下面方法是用于python2的，而不是python3。
>
> `ImportError: No module..` found error happens when Python doesn't find your module. So, where does it look for modules?
>
> ```py
> import os
> print os.sys.path
> ```
>
> Verify `/usr/local/lib/python2.7/site-packages` is in that list. If not, append it
>
> `os.sys.path.append('/usr/local/lib/python2.7/site-packages')` and try to load it. If that still doesn't work, try re-installing the module, because it seems there is an issue there.

In this task, we have three VMs, A, B, and M. We would like to attack A’s ARP cache, such that the following results is achieved in A’s ARP cache.

在该实验中，我们将需要3台VM，即A,B和M。我们想要攻击A的ARP缓存，以便在A的ARP缓存中实现以下结果。

`B’s IP address --> M’s MAC address`

There are many ways to conduct（举办，进行） ARP cache poisoning attack. Students need to try the following three methods, and report whether each method works or not.

进行ARP缓存中毒攻击的方法有很多。学生需要尝试以下三种方式，并且记录每种方式是否可行。（注：我先做的任务B，后再做的任务A，C。）

- **Task 1A (using ARP request).** On host M, construct an ARP request packet and send to host A. Check whether M’s MAC address is mapped to B’s IP address in A’s ARP cache.

  **任务1A（使用ARP请求）**在主机M，构建一个ARP请求包并发送给主机A。检测是否在A的ARP缓存表中有B的IP地址映射了M的MAC地址。

  > 1. 在zhangshuaiyang2/ARP-Cache-Poisoning文件夹下，创建了文件task1B.py
  > 2.  文件task1B.py 中的python代码如下
  >
  > ```python
  > #!/usr/bin/python
  > from scapy.all import *
  > 
  > #spoof A,so we need A'mac
  > E = Ether(dst="08:00:27:04:d9:58")
  > #src is B,dst is A,but now i'm in M
  > #op中的1表示who-has，2表示is-at
  > A = ARP(op = 1,psrc="10.0.2.5",pdst="10.0.2.15")
  > 
  > pkt = E/A
  > sendp(pkt)
  > ```
  >
  > 3. 在主机A中查看ARP缓存表，第一条命令是没有执行文件显现出来的情况。第二条命令是执行命令后显示出来的情况，可以看到，在A的arp表中已经存在了主机B的ip对应于主机M的mac地址
  >
  >    {% asset_img 5.jpg This is an test image %}
  >
  > 4. 在执行文件前，我们就使用wireshark开启了抓包。在wireshark中也可以看到结果。A收到了主机M发出的arp广播请求，并且还给主机M一个回应
  >
  >    {% asset_img 6.jpg This is an test image %}

  <br>

- **Task 1B (using ARP reply).** On host M, construct an ARP reply packet and send to host A. Check whether M’s MAC address is mapped to B’s IP address in A’s ARP cache.

  **任务1B（使用ARP回应）**在主机M，构建一个ARP回应包并发送到主机A。检测是否在A的ARP缓存表中有B的IP地址映射了M的MAC地址。

  > 1. 我在主机M（即linux2）上，创建了zhangshuaiyang2文件夹，然后再在该文件夹下创建了ARP-Cache-Poisoning文件夹。在ARP-Cache-Poisoning文件夹下，创建了文件task1A.py 
  >
  > 2. 文件task1A.py 中的python代码如下
  >
  > ```python
  > #!/usr/bin/python
  > from scapy.all import *
  > 
  > #spoof A,so we need A'mac
  > E = Ether(dst="08:00:27:04:d9:58")
  > #src is B,dst is A,but now i'm in M
  > A = ARP(op = "is-at",psrc="10.0.2.5",pdst="10.0.2.15")
  > 
  > pkt = E/A
  > sendp(pkt)
  > ```
  >
  > 3. 接下来，我在主机A（即linux1）上，清除了arp缓存表`sudo ip neigh flush dev enp0s3`
  >
  > 4. 清除完后，再在主机M上，执行task1A.py文件。`sudo ./task1A.py`
  >
  > 5. 再次查看主机A的arp缓存表，可以发现，主机B的mac地址已经变成主机C的mac了
  >
  >    {% asset_img 2.png This is an test image %}
  >
  > 6. 同时，在主机A上，你也可以用wireshark看到主机M发出的ARP回应报文
  >
  >    {% asset_img 3.png This is an test image %}
  >
  > 7. 然后我们再在A上pingB的IP，理论来说应该是ping不通的。因为A的数据包交给了M
  >
  >    {% asset_img 4.png This is an test image %}
  >
  > 8. 但是从上图可知，开始虽然不通，但最终还是能ping通的。从wireshark截图中，我们就可以发现原因。虽然最开始3个ping包没有回应，但是主机A发现ping不通的时候，又重新发起了ARP请求，请求主机B的mac，并且收到了B的回应，这将导致A的ARP缓存表的更新。所以ping请求包后续封装的目的MAC地址又是正确的了，所以就能ping通。

  <br>

- **Task 1C (using ARP gratuitous（免费） message).** On host M, construct an ARP gratuitous packets. ARP gratuitous packet is a special ARP request packet. It is used when a host machine needs to update outdated（过时） information on all the other machine’s ARP cache. The gratuitous ARP packet has the following characteristics（特性）:

  1. The source and destination IP addresses are the same, and they are the IP address of the host issuing the gratuitous ARP.
  2. The destination MAC addresses in both ARP header and Ethernet header are the broadcast MAC address (ff:ff:ff:ff:ff:ff).
  3. No reply is expected.

  **任务1C（使用无故ARP）**在主机M，构建一个无故ARP报文。无故ARP是一个特殊的ARP请求包。它被使用在，当一个主机设备需要在其他所有的设备的ARP缓存表中更新过时信息时。无故ARP报文拥有以下特点：

  1. 源IP地址和目标IP地址相同，它们是发出免费ARP的主机的IP地址。
  2. 在ARP头部和以太网头部中的目的MAC地址都是广播地址（ff:ff:ff:ff:ff:ff）
  3. 理论来说不会收到回应（注：如果假冒的主机是存在的，那么还是会有回应）
  
  > 1. 测试前可以清除主机A和B的arp缓存表，`sudo ip neigh flush dev enp0s3`，不清除也没事。正好我们可以看下在主机A中，是不是arp中的B与网关的mac地址都成为主机M的了
  >
  > 2. 在主机M上编写程序文件。文件task1C.py 中的python代码如下。由于是欺骗所有人，所以我就没有设置假冒B了，因为也要欺骗B。这里我假冒的是网关IP
  >
  >    ```python
  >    #!/usr/bin/python
  >    from scapy.all import *
  >    
  >    #spoof all,so we need broad'mac
  >    E = Ether(dst="ff:ff:ff:ff:ff:ff")
  >    #src is gateway,dst is gateway,but now i'm in M
  >    A = ARP(op = 1,psrc="10.0.2.1",pdst="10.0.2.1")
  >    
  >    pkt = E/A
  >    sendp(pkt)
  >    ```
  >
  > 3. 在主机A和B中，查看arp缓存表。可以看到主机A中，网关和B的IP所对应的mac都变成主机M的mac地址了。而在主机B中，arp中的网关IP对应的也是主机M的mac地址。
  >
  >    {% asset_img 7.jpg This is an test image %}
  >
  > 4. 同时做上述操作前，我还在主机A上重新利用wireshark抓包，结果如下。可以发现第一个包是一个无故ARP包，由主机M发出。同时由于冒充的是网关，所以网关真实存在，则得到了一个回应，即第二个包。所以在主机M中，网关的mac依旧是没有发生变化的。
  >
  >    {% asset_img 8.png This is an test image %}
  >
  >    {% asset_img 9.png This is an test image %}

<br>

# 3. Task 2:MITM Attack on Telnet using ARP Cache Poisoning

**3.任务2：使用ARP缓存中毒在telnet上实现中间人攻击**

Hosts A and B are communicating using Telnet, and Host M wants to intercept their communication, so it can make changes to the data sent between A and B. The setup is depicted（描述，描绘） in Figure 1.

主机A和B正在使用telnet通信，而主机M想要拦截它们的通信，因此它可以对发送给A和B的数据做出修改。设置如图1所示。

**Step 1 (Launch the ARP cache poisoning attack).** First, Host M conducts（举办） an ARP cache poisoning attack on both A and B, such that in A’s ARP cache, B’s IP address maps to M’s MAC address, and in B’s ARP cache, A’s IP address also maps to M’s MAC address. After this step, packets sent between A and B will all be sent to M. We will use the ARP cache poisoning attack from Task 1 to achieve this goal.

 **步骤1（发起ARP缓存中毒攻击）。**首先，主机M在A和B上都进行ARP缓存中毒攻击，以便在A的ARP缓存上有B的IP地址映射到M的MAC地址，同时在B的ARP缓存上也有A的IP地址映射到M的MAC地址。这步之后，在AB之间发送的数据包将会全部交给M。我们将使用从任务1实现的ARP缓存中毒攻击来完成这一目标。

<br>

**Step 2 (Testing).** After the attack is successful, please try to ping each other between Hosts A and B, and report your observation. Please show Wireshark results in your report.

**步骤2（测试）。**当攻击成功后，请尝试在AB之间互ping，并且记录你的发现。请在你的报告中展示Wireshark的结果。

{% asset_img 1.jpg This is an test image %}

> 1. 先在M上发起对A和B的缓存欺骗攻击，使得A和B上的mac地址表关于对方的条目mac地址指向M
>
>    {% asset_img 10.png This is an test image %}
>
> 2. 然后开始在A，B上互ping，可以看到ping不通。因为是在介质共享型网络中，所以可以在A,B,M三台设备上都抓到icmp包
>
>    {% asset_img 11.png This is an test image %}

<br>

**Step 3 (Turn on IP forwarding).** Now we turn on the IP forwarding on Host M, so it will forward the packets between A and B. Please run the following command and repeat Step 2. Please describe your  observation.

**步骤3（打开IP转发）。**现在我们在主机M上打开了IP转发，所以它将转发在A和B间的数据包。请执行以下命令，并且重复步骤2.请描述你的发现。

```bash
$ sudo sysctl net.ipv4.ip_forward=1
```

> 3. 接上面步骤继续，然后我们在M上开启IP转发
>
> 4. 接下来再在AB上互ping
>
>    > 猜想结果：当A ping B时，数据包会发给M，而由于M开启了路由转发，所以M应该会把数据包转发给B，但是由于M没有B的mac地址，所以M会发送arp广播请求。B收到回应后，就会单播回应给M。而在介质共享型网络中（该实验环境下，而非使用交换机互联），A也能收到B的单播回应，那应该A就会更新MAC地址表。则后续A 再pingB应该会使用正确的MAC地址了，而不会交给M。
>    >
>    > 那么ping 3个包试试水
>    
> 5. 看了数据包，和我想的不一样。那我们来分析下数据包
>
>    {% asset_img 12.png This is an test image %}
>
>    - 在ping第一个包的时候。有4个arp报文，以及4个seq=1的icmp报文，和2个icmp重定向报文
>
>    - 1号包发送了一个数据包给B，但实际上它的目的mac地址是M
>
>      {% asset_img 13.png This is an test image %}
>
>    - 2—6号包是arp报文，和一个icmp重定向报文。是M要获取到A和B的mac地址。同时M发现A是找B的，发现报文跑到我M上了，就发了路由重定向报文，告诉A，大哥你以后找B吧，交给我M是啥事啊（M是机器，它不知道我在它上面做实验了）
>
>    - 7号包是M替A把数据包转发给B。通过mac地址可以获知
>
>    - 8号包是B把回应包交给M。通过mac地址可以获知
>
>    - 9号包是重定向报文，由M告诉B，你以后转发数据包的时候请直接交给A，不要给我M了
>
>    - 10号包是M把B发过来的回应包转交给A。通过mac地址可以获知
>
> 6. 所以综上，你才可以看到有arp包，icmp的ping包和重定向包。同时这也是为什么icmp的ping包有4个及显示上第一个ping包显示的是没有收到回应（no response）的理由

<br>

**Step 4 (Launch the MITM attack).** We are ready to make changes to the Telnet data between A and B. Assume（假设） that A is the Telnet client and B is the Telnet server. After A has connected to the Telnet server on B, for every key stroke（笔、划） typed（除了类型还有打印的意思） in A’s Telnet window, a TCP packet is generated（发生） and sent to B. We would like to intercept the TCP packet, and replace each typed character with a fixed character (say Z). This way, it does not matter what the user types on A, Telnet will always display Z.

**步骤4（发起中间人攻击）。**我们打算修改在A和B间的telnet数据。假设A是telnet客户端，B是telnet服务器。在A连接到B上的Telnet服务器之后，对于在A的Telnet窗口中键入的每个按键，都会生成一个TCP数据包并将其发送到B。我们想截取该TCP数据包，并用固定字符（如Z）替换每个键入的字符。这样，无论用户在A上键入什么，Telnet都将始终显示Z。

From the previous steps, we are able to redirect the TCP packets to Host M, **but instead of forwarding them, we would like to replace them with a spoofed packet.** （学习这句话的语序）We will write a sniff-and-spoof program to accomplish this goal. In particular, we would like to do the following:

从之前的步骤，我们重定向了TCP的数据包到主机M，**我们想用一个欺骗性数据包替换它们，而不是转发它们**。我们将写一个嗅探-欺骗程序来完成这个目标。特别的，我们将做如下操作：

- We first keep the IP forwarding on, so we can successfully create a Telnet connection between A to B. Once the connection is established, we turn off the IP forwarding using the following command. Please type something on A’s Telnet window, and report your observation:

  我们首先开启IP转发功能，所以我们能成功在A和B之间创建telnet连接。一旦该连接建立，我们使用以下命令关闭IP转发功能。请在A的telnet窗口输入一些内容，并报告你的发现：

  ```bash
  $ sudo sysctl net.ipv4.ip_forward=0
  ```

> 1. 在M上对A和B开启了arp欺骗
> 2. 同时开启了IP转发功能
> 3. A telnet B的时候，syn的数据包也是由M帮忙转发的
> 4. A远程到B后，再在A上输入ifconfig等命令，都能在A上显示出来
> 5. 此时关闭M上的IP转发功能。再在A上输入命令，或是任意字符。会发现，A上已经无法显示任何东西了。【不管输入什么，A的界面上确实没有任何反应】
> 6. 但是过了不久，输入的字符又能在A上显示出来。抓包看可以知道，当A无法显示内容的时候，其实就开始发送ARP报文重新想要获取B的地址了。当获取到了B的真实MAC地址，后续输入字符和命令都能显示出来

- We run our sniff-and-spoof program on Host M, such that for the captured packets sent from A to B, we spoof a packet but with TCP different data. For packets from B to A (Telnet response), we do not make any change, so the spoofed packet is exactly the same as the original one.

  我们在主机M上运行嗅探-欺骗程序，对于捕获的从A发往B的数据包，我们冒充一个使用TCP不同数据内容的数据包。对于从B发往A的数据包（telnet回应），我们不做任何改变，因此冒充的数据包和原始的完全一样。

<br>

A skeleton（骨骼，框架） sniff-and-spoof program is shown below:

一个嗅探-欺骗程序的框架展示如下：

```python
#!/usr/bin/python
from scapy.all import *

def spoof_pkt(pkt):
	print("Original Packet.	")
	print("Source IP : ", pkt[IP].src)
	print("Destination IP :", pkt[IP].dst)

	a = IP()
	b = TCP()
	data = pkt[TCP].payload
	newpkt = a/b/data

	print("Spoofed Packet.	")
	print("Source IP : ", newpkt[IP].src)
	print("Destination IP :", newpkt[IP].dst)
	send(newpkt)

pkt = sniff(filter='tcp',prn=spoof_pkt)
```

<br>

The above program sniffs all the TCP packets and then spoof a new TCP packet based on the captured packets. Please make necessary changes to distinguish（区分，辨别） whether a packet is sent from A or B. If it is sent from A, set all the attribute names/values of the new packet to be the same as those of the original packet, and replace each alphanumeric（一个字母或数字的字符） characters in the payload (usually just one character in each packet) with character Z. If the captured packet is sent from B, no change will be made.

以上程序监听了所有TCP数据包并且还基于捕获的数据包冒充了一个新的TCP包。请做必要的改变来区分是从A还是B发送了数据包。如果从A发送数据包，则设置新的数据包的所有属性名/值和原始数据包一致，并在负载（一般在每个数据包中都只有一个字符，注：telnet是每发送一个字符就封装一个包发出）中用Z替换每个字符。如果捕获的数据包是从B发送出去的，则不做任何改变。

In Telnet, every character we type in the Telnet window will trigger a TCP packet. Therefore, in a typical （典型）Telnet packet from client to server, the payload only contains one character. The character will then be echoed back by the server, and the client will then display the character in its window. Therefore, what we see in the client window is not the direct result of the typing; whatever we type in the client window takes a round trip before it is displayed. If the network is disconnected, whatever we typed on the client window will not displayed, until the network is recovered. Similarly（同样的）, if attackers change the character to Z during the round trip, Z will be displayed at the Telnet client window.

在telnet中，我们在telnet窗口输入的每个字符将会触发一个TCP包。因此，在一个从客户端发往服务器的典型数据包中，负载仅包含一个字符。因此，我们在客户端窗口看到的东西不是输入后的直接结果；不论我们在客户端窗口中输入什么，都需要经过返程才能显示。如果网络被关闭，不论我们在客户端窗口输入什么都将不会被显示，直到网络恢复。同样，如果攻击者在往返过程中将字符更改为Z，则Z将显示在Telnet客户端窗口中。

> 1. 欺骗程序代码如下
>
>    ```python
>    #!/usr/bin/python
>    from scapy.all import *
>    
>    def spoof_pkt(pkt):
>    	if pkt[Ether].src =='08:00:27:04:d9:58' and  pkt[IP].src == "10.0.2.15" and pkt[IP].dst == '10.0.2.5' :
>    		print("Original Packet. ")
>    		print("Source IP : ", pkt[IP].src)
>    		print("Destination IP :", pkt[IP].dst)
>            
>    		a = IP(src = "10.0.2.15",dst = "10.0.2.5")
>    		b = TCP(sport = pkt[IP].sport,dport = pkt[IP].dport)
>    		pkt[TCP].payload = 'z'
>    		data = 'z'
>    		newpkt = a/b/data
>            
>    		print("Spoofed Packet.  ")
>    		print("Source IP : ", newpkt[IP].src)
>    		print("Destination IP :", newpkt[IP].dst)
>    		send(newpkt)
>    
>    	elif pkt[Ether].src =='08:00:27:26:fb:90' and  pkt[IP].src == "10.0.2.5" and pkt[IP].dst == '10.0.2.15' :
>    		a = IP(src = "10.0.2.5",dst = "10.0.2.15")
>    		b = TCP(sport = pkt[IP].sport,dport = pkt[IP].dport)
>    		data = pkt[TCP].payload
>    		newpkt = a/b/data
>    		send(newpkt)
>            
>    pkt = sniff(filter = 'tcp',prn=spoof_pkt)                                      
>    ```
>
> 2. telnet连接建立后，关闭IP转发功能
>
> 3. A发给B的数据包，经M修改后再次发送给B
>
> 4. B给的回应，经过M修改后，转发给A
>
> 5. A的界面上依旧无法显示任何内容。但是过了一段时间，由于A获取不到信息，导致重新发送ARP报文，当获取到B的正确mac地址后，就能正常显示了

Here is a summary what we need to do in order to launch the MITM attack.

为了发起中间人攻击，以下汇总了我们需要做的事情。

- Conduct ARP cache poisoning attacks against（针对） Hosts A and B.

  对主机A和B进行ARP缓存中毒攻击

- Turn on IP forwarding on Host M.

  在主机M上开启IP转发功能

- Telnet from host A to Host B.

  从主机A向B发起telnet

- After the Telnet connection has been established, turn off IP forwarding.

  在telnet连接被建立后，关闭IP转发功能

- Conduct the sniff and spoof attack on Host M.

  在主机M上发起嗅探和欺骗攻击

<br>

# 4. Submission

**4.提交投稿**

Students need to submit a detailed lab report to describe what they have done, what they have observed, and how they interpret（阐释） the results. Reports should include evidences to support the observations. Evidences include packet traces, screenshots, etc. Reports should also list the important code snippets（一小块或简短的摘录。） with explanations. Simply attaching（附带） code without any explanation will not receive credits（信用，学分）.

学生需要上传一份细节实验报告来描述他们做了哪些操作，他们发现了什么，以及他们是怎么解释结果。报告中应该包含证据来支撑他们的发现。证据包含数据包追踪，截屏等等。报告中还应该列出带有解释的重要部分代码。没有任何解释的简单附加代码将不会获得学分。