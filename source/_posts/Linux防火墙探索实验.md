---
title: Linux防火墙探索实验
date: 2019-10-31 22:13:22
categories: SEED Labs
tags:
---

> 参考文档：
>
> [1.官方原文档](https://seedsecuritylabs.org/Labs_16.04/PDF/Firewall.pdf)
>
> [2.iptables详解](http://www.zsythink.net/archives/1199)
>
> [3.在 Ubuntu 中用 UFW 配置防火墙](https://linux.cn/article-8087-1.html)
>
> [4.Ufw使用指南](https://wiki.ubuntu.org.cn/Ufw使用指南)

# 1. Overview

The learning objective of this lab is for students to gain the insights（眼光，内省力） on how firewalls work by playing with firewall software and implement a simplified（简化的） packet filtering firewall. Firewalls have several types; in this lab,  we focus on *packet filter*.  Packet filters inspect（检测） packets, and decide whether to drop or forward  a packet based on firewall rules. Packet filters are usually *stateless*; they filter each packet based only on the information contained in that packet, without paying attention to whether a packet is part of an existing stream of traffic. Packet filters often use a combination（组合） of a packet’s source and destination address, its protocol, and, for TCP and UDP traffic, port numbers. In this lab, students will play with this type of firewall, and also through the implementation of some of the key functionalities, they can understand how firewalls work. Moreover, students will learn how to use SSH tunnels to bypass（绕行，撇开） firewalls. This lab covers the following topics:

本次实验的学习目标是让学生通过接触防火墙软件与实现一个简单的包过滤防火墙，以深入理解防火墙的工作原理。防火墙有几种类型；在本次实验中，我们关注于*包过滤防火墙*。包过滤器检测数据包，并且基于防火墙规则来决定是丢弃或是转发一个数据包。包过滤器通常来说是*无状态的*；它们仅基于数据包中包含的信息来过滤每一个数据包，而不关注数据包是否是现有业务流中的一部分。包过滤器经常组合使用一个数据包的源目地址，协议类型，及TCP和UDP流量的端口号。本实验中，学生将接触该类型防火墙，并且实现部分关键功能，他们能理解防火墙是如何工作的。此外，学生将学习如何使用SSH隧道来绕过防火墙。该实验覆盖以下主题：

- Firewall（防火墙）

- Netfilter

- Loadable kernel module（可加载的内核模块）

- SSH tunnel（SSH隧道）

 <!--more-->

**Readings and related topics.** Detailed coverage of Firewalls can be found in Chapter 14 of the SEED book, *Computer Security: A Hands-on Approach*, by Wenliang Du. A related lab is the Firewall Bypassing lab, which shows how to use VPN to bypass firewalls.

**阅读及其相关主题。**在杜文亮教授的SEED书籍*Computer Security: A Hands-on Approach*中的14章可以找到关于防火墙的细节。相关实验是防火墙绕行实验，该实验展示了如何使用VPN绕过防火墙。



**Lab environment.** This lab has been tested on our pre-built Ubuntu 16.04 VM, which can be downloaded from the SEED website.

**实验环境。**该实验已经在预建的Ubuntu 16.04 VM上通过测试，该VM可以在SEED网页上下载。

<br>

# 2. Lab Tasks实验组

## 2.1 Task 1: Using Firewall

**2.1 实验1：使用防火墙**

*Linux* has a tool called *iptables*, which is essentially(实质上) a firewall. It has a nice front end program called *ufw*. In this task, the objective is to use *ufw* to set up some firewall policies, and observe the behaviors of your system after the policies become effective. You need to set up at least two VMs, one called Machine A, and other called Machine B. You run the firewall on your Machine A. Basically, we use *ufw* as a personal firewall.  Optionally,  if you have  more VMs,  you can set up a firewall at your router,  so it can protect   a network, instead of just one single computer. After you set up the two VMs, you should perform the following tasks:

*Linux*有个工具叫*iptables*，它实质上是个防火墙。它有个很好的前端程序，叫*ufw*。在该任务中，目标是使用*ufw*来设置一些防火墙策略，并且在策略生效后观测你系统的行为。你需要设置至少2个VM，一个叫做机器A，而另一个叫做机器B。你在你的机器A上运行防火墙。基本上，我们使用*ufw*作为一个私人防火墙。（可选），如果你有多个VM，你可以在你的路由器上设置一个防火墙，那么它可以保护你的网络，而不仅仅是一台主机。实验拓扑如下，主机1作为A，主机2作为B。

{% asset_img seedlab拓扑图.png This is an test image %}

在你设置了2台VM后，你需要执行以下任务：

- Prevent A from doing telnet to Machine B.

  阻止来自A向B的telnet访问。

  > 1. 查看ufw的状态，可以发现我们还没有开启该服务
  >
  > ```bash
  > [11/12/19]seed@VM:~$ sudo ufw status
  > Status: inactive
  > ```
  >
  > 2. 我们可以使用`sudo ufw enable`来开启
  > 3. 参考命令如下
  >
  > ```bash
  > 默认策略 允许\拒绝\拒绝并提示 [进入\发出\路由 的数据]
  > ufw [--dry-run] default allow|deny|reject [incoming|outgoing|routed]
  > 
  > [删除][插入 第 行] 允许\拒绝\拒绝并提示\限制 [数据 进入\发出][记录\全记录] 端口[/协议]
  > ufw  [--dry-run]  [delete]   [insert   NUM]   allow|deny|reject|limit  [in|out][log|log-all] PORT[/PROTOCOL]
  > ```
  >
  > 4. 输入命令`sudo ufw deny out 23 `
  >
  > ```bash
  > [11/12/19]seed@VM:~$ sudo ufw deny out 23
  > Rule added
  > Rule added (v6)
  > [11/12/19]seed@VM:~$ sudo ufw status
  > Status: active
  > 
  > To							Action		From
  > --							------		----
  > 23							DENY OUT	Anywhere                  
  > 23 (v6)						DENY OUT	Anywhere (v6)    
  > ```
  >
  > 5. 测试效果
  >
  >    {% asset_img 3.png This is an test image %}
  >
  > 6. 从上图可以看到，主机AtelnetB是没有任何数据包产生的。而当主机Btelnet主机A则没有问题

- Prevent B from doing telnet to Machine A.

  阻止来自B向A的telnet访问。

  > 1. 基于上步，再次输入命令`sudo ufw deny in 23 `
  >
  > 2. 测试效果
  >
  >    {% asset_img 4.png This is an test image %}
  >
  > 3. 从上图可以看到，此时主机B的syn数据包发送到了主机A，但是主机A没有任何相应了

- Prevent A from visiting an external（外部的） web site. You can choose any web site that you like to block, but keep in mind, some web servers have multiple IP addresses.

  阻止A访问外部的站点。你可以选择任何一个你想要禁止的网站，但是记住，一些网站有多个IP地址。命令和上述内容类似，就不再做重复实验了，主要就是限制IP地址
  
  > 1. `sudo ufw deny from 123.45.67.89`
  > 2. 上述3个实验完成后，我暂时先关闭了ufw功能 `sudo ufw disable`

You can find the manual of ufw by typing "man ufw" or search it online. It is pretty straightforward to use.  Please remember that the firewall is not enabled by default, so you should run a command to specifically（明确的） enable it. We list some commonly used commands in Appendix A.

你可以通过输入“man ufw”来获取ufw的手册，或是在网络上搜索它。这是最直白的使用方式。需要注意的是，防火墙默认是没有开启的，所以你需要通过使用命令来明确开启它。我们在附录A中列出了一些经常被使用的命令。

Before starting the task, go to the default policy file `/etc/default/ufw`. find the following entry, and change the rule from DROP to ACCEPT; otherwise, all the incoming traffic will be dropped by default.

在开始任务之前，找到默认的策略文件夹`/etc/default/ufw`。找到以下条目，然后把规则从DROP改为ACCEPT；不然，默认情况下的所有流入数据将会被丢弃。（注意使用sudo来修改。）

```bash
# Set the default input policy to ACCEPT, DROP, or REJECT. Please note that if 
# you change this you will most likely want to adjust your rules.
DEFAULT_INPUT_POLICY="DROP"
```

<br>

## 2.2 Task 2:Implementing a Simple Firewall

**任务2：实现一个简单防火墙**

The firewall you used in the previous task is a packet filtering type of firewall. The main part of this type of firewall is the filtering part, which inspects each incoming and outgoing packets, and enforces（强制执行） the firewall policies set by the administrator. Since the packet processing is done within the kernel, the filtering must also be done within the kernel. Therefore, it seems that implementing such a firewall requires us to modify the Linux kernel. In the past, this had to be done by modifying and rebuilding the kernel. The modern Linux operating systems provide several new mechanisms（机制） to facilitate（促进） the manipulation of packets without rebuilding the kernel image. These two mechanisms are *Loadable Kernel Module* (LKM) and *Netfilter*.

你在上一个任务中用到的防火墙是包过滤型防火墙。该类型防火墙的主要部分是过滤部分，它检测每一个流入与流出的数据包，并且强制执行防火墙上管理员所做的策略。由于包处理是在内核中完成，所以过滤也需要在内核中完成。因此，看上去似乎实现这类防火墙就要求我们去修改Linux的内核。在过去，修改和重建内核是必须要做的事情。现代Linux操作系统提供多种新的机制来促进数据包的操作，而无需重建内核镜像。以下有2种机制：*Loadable Kernel Module* (LKM) 和 *Netfilter*。

LKM allows us to add a new module to the kernel at the runtime. This new module enables us to extend the functionalities of the kernel, without rebuilding the kernel or even rebooting the computer. The packet filtering part of a firewall can be implemented as an LKM. However, this is not enough. In order for the filtering module to block incoming/outgoing packets, the module must be inserted into the packet processing path. This cannot be easily done in the past before the Netfilter was introduced into the Linux.

LKM允许我们在运行期间给内核添加一个新的模块。这种新的模块使我们能扩展内核功能，而无需重建核心甚至是重启电脑。作为LKM中防火墙的包过滤部分是可以被实现的。然而，这还不够。为了使过滤模块能够阻止传入/传出的数据包，必须将模块插入到数据包处理路径中。在以前还没有在Linux中引入Netfilter时，这可不容易实现。

Netfilter is designed to facilitate the manipulation of packets by authorized（合法） users. Netfilter achieves this goal by implementing a number of *hooks* in the Linux kernel. These hooks are inserted into various places, including the packet incoming and outgoing paths. If we want to manipulate the incoming packets, we simply need to connect our own programs (within LKM) to the corresponding（相应的） hooks. Once an incoming packet arrives, our program will be invoked. Our program can decide whether this packet should be blocked or not; moreover, we can also modify the packets in the program.

Netfilter旨在促进授权用户对数据包的操作。Netfilter通过在Linux内核中实现许多*hooks*来实现此目标。这些钩子被插入到多个地点，包括数据包流入与流出的路径。如果我们想操作流入的数据包，我们只需要连接我们的程序（在LKM内）到相应的钩子上即可。当一个流入数据包到达，我们的程序将被唤醒。我们的程序可以决定这个数据包是否该被阻止或是放行；此外，我们还可以在程序中修改数据包。

In this task, you need to use LKM and Netfilter to implement the packet filtering module. This module will fetch（获取） the firewall policies from a data structure, and use the policies to decide whether packets should be blocked or not. To make your life easier, so you can focus on the filtering part, the core of firewalls, we allow you to hardcode your firewall policies in the program. You should support at least five different rules, including the ones specified in the previous task. Guidelines on how to use Netfilter can be found in Section 3. In addition, Chapter 14 (§14.4) of the SEED book provides more detailed explanation on Netfilter.

在该任务中，你需要使用LKM和Netfilter来实现包过滤模块。该模块将从数据结构中获取防火墙策略，并且使用策略来决定数据包是否该被阻止。为了让你生活更轻松，你可以只关注过滤部分，这是防火墙的核心，我们允许你在程序中硬编码你的防火墙策略。你应该支持至少5个不同的规则，包括上一个任务指定的规则。有关如何使用Netfilter的指南，请参见第3节。此外，SEED手册的第14章（第14.4节）提供了有关Netfilter的更详细说明。

**Note for Ubuntu 16.04 VM:**   The code in the SEED book was developed in Ubuntu 12.04.   It needs to be changed slightly to work in Ubuntu 16.04.  The change is in the definition of the callback function *telnetFilter()*, because the prototype of Netfilter’s callback function has been changed in Ubuntu 16.04. See the difference in the following:

**对于Ubuntu 16.04 VM的注意事项：**SEED书中的代码是在Ubuntu 12.04中开发的。 需要稍作更改才能在Ubuntu 16.04中工作。 更改是在回调函数*telnetFilter（）*的定义中进行的，因为Netfilter的回调函数的原型已在Ubuntu 16.04中进行了更改。 请参阅以下内容：

```python
// In Ubuntu 12.04
unsigned int telnetFilter(unsigned int hooknum, struct sk_buff *skb, 
                          const struct net_device *in, const struct net_device *out, 
                          int (*okfn)(struct sk_buff *))

// In Ubuntu 16.04
unsigned int telnetFilter(void *priv, struct sk_buff *skb,
                          const struct nf_hook_state *state)
```

<br>



## 2.3 Task 3: Evading（逃避） Egress Filtering

**任务3：绕过出口过滤**

Many companies and schools enforce（执行，实施） egress filtering, which blocks users inside of their networks from reaching out to certain web sites or Internet services. They do allow users to access other web sites. In many cases, this type of firewalls inspect the destination IP address and port number in the outgoing packets. If a packet matches the restrictions（限制）, it will be dropped. They usually do not conduct deep packet inspections (i.e., looking into the data part of packets) due to the performance reason. In this task, we show how such egress filtering can be bypassed using the tunnel mechanism. There are many ways to establish tunnels; in this task, we only focus on SSH tunnels.

许多公司和学校实施了出口过滤，它阻止了网络内部的用户访问特定的网站或是互联网服务。但是他们允许用户访问其他网站。在很多案例中，该类防火墙检测外出数据包中的目的IP地址和端口号。如果一个包匹配上了该限制，那它将会被丢弃。由于性能方面的原因，他们通常不做深度包检测（例如，查看数据包中的数据部分）。在这组任务中，我们说明如何使用隧道机制来绕过此类出口过滤。有许多方式可以建立隧道；在该任务下，我们只关注SSH隧道。

You need two VMs A and B for this task (three will be better). Machine A is running behind a firewall (i.e., inside the company or school’s network), and Machine B is outside of the firewall. Typically, there is a dedicated machine that runs the firewall, but in this task, for the sake of convenience, you can run the firewall on Machine A. You can use the firewall program that you implemented in the previous task, or directly use ufw. You need to set up the following two firewall rules:

在该任务中，你需要2个虚拟机A和B（如果有3个更好）。机器A运行在防火墙后（例如在公司或是学校网络内部），机器B在防火墙的外部。一般来说，要有一台运行防火墙的检测主机，但是在该任务中，为方便起见，你可以在主机A上运行防火墙。你可以使用在上一个实验中所实现的防火墙程序，或是直接使用ufw。你需要设置以下防火墙规则：

- Block all the outgoing traffic to external telnet servers. In reality, the servers that are blocked are usually game servers or other types of servers that may affect the productivity（生产率） of employees. In this task, we use the telnet server for demonstration（示范） purposes. You can run the telnet server on Machine B. If you have a third VM, Machine C, you can run the telnet server on Machine C.

  阻止所有到外部telnet服务器的外出流量。实际上，这些被阻止的服务经常是一些游戏服务或是其他的可能影响到员工生产效率的服务。在该任务中，我们使用telnet服务器来完成示范。你可以在B上运行telnet服务。如果你有3台虚拟机，你可以在第三台机器C上运行telnet服务。

- Block all the outgoing traffic to [www.facebook.com, ](http://www.facebook.com/)so employees (or school kids) are not distracted（发愣，发疯） during their work/school hours. Social network sites are commonly blocked by companies and schools. After you set up the firewall, launch your Firefox browser, and try to connect to Facebook, and report  what happens. If you have already visited Facebook before using this browser,  you need to clear all the caches using Firefox’s menu: **Edit -> Preferences -> Privacy & Security (left pane) -> Clear History (Button on right)**; otherwise, the cached pages may be displayed. If everything is set up properly, you should not be able to see Facebook pages. It should be noted that Facebook has many IP addresses, it can change over the time. Remember to check whether the address is still the same by using ping or dig command. If the address has changed, you need to update your firewall rules. You can also choose web sites with static IP addresses, instead of using Facebook. For example, most universities’ web servers use static IP addresses (e.g. www.syr.edu); for demonstration purposes, you can try block these IPs, instead of Facebook.

  阻止所有去往 www.facebook.com 的外出流量（这里我们设置成 www.baidu.com ），以使员工（或是学生）在他们的工作时间内不会分心。社交网站通常会被公司或学校阻止访问。在你设置完防火墙后，启动你的火狐浏览器，并且尝试连接到Facebook（我们这里是百度），然后报告发生了什么。如果你之前使用过浏览器访问过Facebook（百度），你需要清空所有缓存，使用火狐的菜单**Edit -> Preferences -> Privacy & Security (left pane) -> Clear History (Button on right)**；否则，可能会显示缓存的页面。如果所有事情都设置好了，你将无法看到Facebook（百度）页面。需要注意的是脸书（百度）有多个IP，它可以随时间而改变。请记住使用ping或dig命令检查地址是否仍然相同。如果地址发生了改变，你需要更新你的防火墙规则。你也可以选择使用静态IP的网站，而不是使用脸书。例如大部分的学校网站使用的是静态IP（例如 www.syr.edu ）；出于示范目的，你可以尝试阻止这些IP地址，而不是脸书。

In addition to set up the firewall rules, you also need the following commands to manage the firewall:

除了设置防火墙规则，您还需要以下命令来管理防火墙：

```bash
$ sudo ufw enable				// this will enable the firewall.
$ sudo ufw disable				// this will disable the firewall.
$ sudo ufw status numbered 		// this will display the firewall rules.
$ sudo ufw delete 3				// this will delete the 3rd rule.
```

{% asset_img 1.png This is an test image %}

<br>

### Task 3.a: Telnet toMachine B through the firewall
**任务3.a：通过防火墙telnet到机器B**

To bypass the firewall, we can establish an SSH tunnel between Machine A and B, so all the telnet traffic will go through this tunnel (encrypted), evading the inspection. Figure 1 illustrates（说明） how the tunnel works. The following command establishes an SSH tunnel between the localhost (port 8000) and machine B (using the default port 22); when packets come out of B’s end, it will be forwarded to Machine C’s port 23 (telnet port). If you only have two VMs, you can use one VM for both Machine B and Machine C.

要绕过防火墙，我们可以在A和B之间建立一个SSH隧道，那么所有的telnet流量将通过该隧道（被加密），以逃避检测。图1说明了该隧道是如何工作的。以下命令在本机（8000端口）和主机B（默认使用22端口）之间建立了一个SSH隧道；当数据包从B端流出时，它将被转发给主机C的23号端口（即telnet端口）。如果你仅有2台VM，你可以使用一台虚拟机用于B和C。

```bash
$ ssh -L 8000:Machine_C_IP:23	seed@Machine_B_IP

// We can now telnet to Machine C via the tunnel:
$ telnet localhost 8000
```

When we telnet to localhost’s port 8000, SSH will transfer all our TCP packets from one end of the tunnel on localhost:8000 to the other end of the tunnel on Machine B; from there, the packets will be forwarded to Machine C:23. Replies from Machine C will take a reverse（相反的） path, and eventually reach our telnet client. Essentially, we are able to telnet to Machine C. Please describe your observation and explain how you are able to bypass the egress filtering. You should use Wireshark to see what exactly is happening on the wire.

当我们telnet到本机的8000端口，SSH将转换我们所有的TCP报文，从本机8000端口的隧道一端发送到主机B的隧道另一端；从那里，数据包将会被转发到主机C的23号端口。来自C的回应报文将采用相反的方式，并最终到达我们的telnet客户端。本质上，我们可以telnet到主机C。请描述你的发现并解释你是如何绕过出口过滤的。你应该使用wireshark来观测在链路上到底发生了什么。

<br>

### Task 3.b: Connect to Facebook using SSH Tunnel.

**任务 3.b：使用SSH隧道连接到Facebook**

To achieve this goal, we can use the approach（途径） similar to that in Task 3.a, i.e., establishing a tunnel between your localhost:port and Machine B, and ask B to forward packets to Facebook. To do that, you can use the following command to set up the tunnel: "ssh -L 8000:FacebookIP:80 ...".  We will not use this approach, and instead, we use a more generic（通用的） approach, called dynamic port forwarding, instead of a static one like that in Task 3.a. To do that, we only specify the local port number, not the final destination. When Machine B receives a packet from the tunnel, it will dynamically decide where it should forward the packet to based on the destination information of the packet.

为了实现该目标，我们可以使用在任务3.a中类似的方法，例如，在你的本机和主机B之间建立一个隧道，并且要求B转发数据包到Facebook。为了实现上述内容，你可以使用以下命令来设置隧道`ssh -L 8000:FacebookIP:80 ...`。但是我们将不会使用该方式，相反，我们会使用更通用的方式，叫做动态端口转发，而不是像任务3.a中的静态方式。为此，我们仅需指定本地端口号，而非目的地的。当主机B收到从隧道发来的数据包，它将根据数据包的目的地址信息，动态决定数据包应该转发至何处。

`$ ssh -D 9000 -C seed@machine_B`

{% asset_img 2.png This is an test image %}

Similar to the telnet program, which connects localhost:9000, we need to ask Firefox to connect to localhost:9000 every time it needs to connect to a web server, so the traffic can go through our SSH tunnel. To achieve that, we can tell Firefox to use localhost:9000 as its proxy. To support dynamic port forwarding, we need a special type of proxy called *SOCKS proxy*, which is supported by most browsers. To set up the proxy in Firefox, go to the menu bar, click *Edit -> Preferences*, scroll（滚动） down to *Network Proxy*, and click the *Settings* button. Then follow Figure 2. After the setup is done, please do the following:

与telnet程序类似，它连接到了本地主机的9000端口，我们要让火狐在每次需要连接到网页服务器的时候，让它来连接到本地主机的9000端口，这样才可以让流量通过我们的SSH隧道。为了实现上述要求，我们可以让火狐使用本地的9000端口作为代理。为了支持动态端口转发，我们需要一个特殊类型的代理，它叫*SOCKS proxy*，在大部分浏览器中它都是被支持使用的。为了在火狐浏览器中设置代理，请到菜单栏，点击*Edit -> Preferences*，向下滚动到*Network Proxy*，并且点击*Settings*按钮。然后照图2操作。在设置完成后，请做以下步骤：

1. Run Firefox and go visit the Facebook page. Can you see the Facebook page? Please describe your observation.

   运行火狐然后浏览Facebook页面。你能否看到该网页呢？请描述你的发现。

2. After you get the facebook page, break the SSH tunnel, clear the Firefox cache, and try the connection again. Please describe your observation.

   在你打开了facebook网页后，终止SSH隧道，清空火狐上的缓存，并再次尝试访问网页。请描述你的发现。

3. Establish the SSH tunnel again and connect to Facebook. Describe your observation.

   再次建立SSH隧道，并且连接到Facebook。描述你的发现。

4. Please explain what you have observed, especially on why the SSH tunnel can help bypass the egress filtering. You should use Wireshark to see what exactly is happening on the wire. Please describe your observations and explain them using the packets that you have captured.

   请解释你发现了什么，特别是为什么SSH隧道可以帮助你绕过出口过滤。你应该使用wireshark来观测在链路上到底发生了什么。请描述你的发现并使用你捕获的数据包来解释它们。

<br>

## 2.4 Task 4: Evading Ingress Filtering

**2.4 任务4：逃避入口过滤**

Machine A runs a web server behind a firewall; so only the machines in the internal network can access this
web server. You are working from home and needs to access this internal web server. You do not have VPN, but you have SSH, which is considered as a poor man’s VPN. You do have an account on Machine A (or another internal machine behind the firewall), but the firewall also blocks incoming SSH connection, so you
cannot SSH into any machine on the internal network. Otherwise, you can use the same technique from Task 3 to access the web server. The firewall, however, does not block outgoing SSH connection, i.e., if you want to connect to an outside SSH server, you can still do that.

主机A在防火墙后运行了网页服务；所以只有在内部网络的主机可以连接到这台网页服务。你正在家里工作并且需要连接到这台内部的网页服务。你不需要有VPN，但是你有SSH，它可以被认为是穷人的VPN。你需要在主机A（或是其他处于防火墙后的网络主机）上有个账号，但是防火墙依旧阻止流入的SSH连接，所以你无法SSH到在内部网络上的任意一台主机。此外，你可以使用在任务3中的相同技术连接到网页服务器。然而，防火墙不会阻止外出的SSH连接，例如，如果你想连接到外部的SSH服务器，你依旧可以实现它。

The objective of this task is to be able to access the web server on Machine A from outside. We will use two machines to emulate（仿真） the setup. Machine A is the internal computer, running the protected web server; Machine B is the outside machine at home. On Machine A, we block Machine B from accessing its port 80 (web server) and 22 (SSH server). You need to set up a reverse SSH tunnel on Machine A, so once you get home, you can still access the protected web server on A from home.

这组任务的目标是能够从外部连接到主机A的网页服务。我们将使用2个主机来模拟设置。主机A是内部电脑，它运行了受保护的网页服务；主机B是在家的外部主机。在主机A，我们阻止来自主机B对于80端口（网页服务）和22端口（SSH服务）的连接。你需要在主机A上设置一个反向的SSH隧道，一旦你到家，你依旧可以在家访问到在A上的被保护的网页服务。

<br>



# 3. Guidelines（准则）

## 3.1 Loadable Kernel Module

**3.1可加载的内核模块**

The following is a simple loadable kernel module. It prints out "Hello World!" when the module is loaded; when the module is removed from the kernel, it prints out "Bye-bye World!". The messages are not printed out on the screen; they are actually printed into the */var/log/syslog* file. You can use `dmesg| tail -10` to read the last 10 lines of message.

以下是一个简单的可加载内核模块。加载模块时，它打印出“ Hello World！”；当从内核中删除该模块时，它会打印出“ Bye-bye World！”。 消息未在屏幕上打印出来；但是它们实际上已打印到 */var/log/syslog*文件中。 您可以使用`dmesg| tail -10`读取消息的最后10行。

```c
#include <linux/module.h>
#include <linux/kernel.h>

int init_module(void)
{
	printk(KERN_INFO "Hello World!\n");
    return 0;
}

void cleanup_module(void)
{
	printk(KERN_INFO "Bye-bye World!.\n");
}
```

We now need to create *Makefile*, which includes the following contents (the above program is named *hello.c*). Then just type *make*, and the above program will be compiled into a loadable kernel module.

现在，我们需要创建*Makefile*，其中包括以下内容（上面的程序名为*hello.c*）。 然后只需输入*make*，上面的程序将被编译成可加载的内核模块。

```c
obj-m += hello.o

all:
make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

clean:
make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
```

Once the module is built by typing *make*, you can use the following commands to load the module, list all modules, and remove the module:

一旦通过输入*make*构建模块后，你可以使用以下命令加载模块，列出所有模块以及删除该模块：

```bash
$ sudo insmod mymod.ko		(inserting a module) 
$ lsmod						(list all modules) 
$ sudo rmmod mymod.ko		(remove the module)
```

Also, you can use `modinfo mymod.ko` to show information about a Linux Kernel module.

当然，你可以使用`modinfo mymod.ko`来展示关于Linux内核模块的信息。

<br>

## 3.2  A Simple Program that Uses Netfilter

**3.2 使用Netfilter的简单程序**

Using *Netfilter* is quite straightforward. All we need to do is to hook our functions (in the kernel module) to the corresponding *Netfilter* hooks. Here we show an example:

使用*Netfilter*非常简单。 我们要做的就是将我们的函数（在内核模块中）挂接到相应的*Netfilter*挂钩。 这里我们展示一个例子：

```c 
#include <linux/module.h> 
#include <linux/kernel.h> 
#include <linux/netfilter.h> 
#include <linux/netfilter_ipv4.h>

/* This is the structure we shall use to register our function */ 
static struct nf_hook_ops nfho;

/* This is the hook function itself */
unsigned int hook_func(void *priv, struct sk_buff *skb,
                       const struct nf_hook_state *state)

{
	/* This is where you can inspect the packet contained in the structure pointed by 			skb, and decide whether to accept or drop it. You can even modify the packet */

    // In this example, we simply drop all packets 
    return NF_DROP;			/* Drop ALL packets */
}

/* Initialization routine */ 
int init_module()
{	/* Fill in our hook structure */
	nfho.hook = hook_func;	/* Handler function */ 
    nfho.hooknum = NF_INET_PRE_ROUTING; /* First hook for IPv4 */ 
    nfho.pf	= PF_INET;
    nfho.priority = NF_IP_PRI_FIRST;	/* Make our function first */
   
    nf_register_hook(&nfho); 
    return 0;
}

/* Cleanup routine */ 
void cleanup_module()
{
	nf_unregister_hook(&nfho);
}
```

<br>

# 4. Submission and Demonstration

**4.提交与示范**

Students need to submit a detailed lab report to describe what they have done, what they have observed, and explanation. Reports should include the evidences to support the observations. Evidences include packet traces, screendumps, etc. Students also need to answer all the questions in the lab description. For the programming tasks, students should list the important code snippets followed by explanation. Simply attaching code without any explanation is not enough.

学生需要提交一份详细的实验报告来描述他们所做的事情，所观察到的事情以及解释。 报告应包括支持观察的证据。 证据包括数据包跟踪，截屏等。学生还需要回答实验描述中的所有问题。对于编程任务，学生应列出重要的代码段，然后进行解释。 仅仅附加代码而没有任何解释是不够的。