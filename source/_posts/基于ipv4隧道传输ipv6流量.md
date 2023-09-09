---
title: 基于ipv4隧道传输ipv6流量
date: 2022-04-21 20:15:18
categories: 小技巧
tags:
---

## 1.获取IPv6

首先前往下面这个网站注册一个账户：

[https://www.tunnelbroker.net](https://www.tunnelbroker.net/)

注册完账户之后，点击左侧的 Create Regular Tunnel，如下所示

{% asset_img 1.jpg This is an test image %}

<br>

在下面的页面中，在对应的地方输入VPS的IP地址。然后选择一个服务器，注意选离vps所在机房最近的服务器。选好之后，在页面最下方点击 Create，进入下一个页面。

{% asset_img 2.jpg This is an test image %}

<br>

下一个页面如下所示。我们切换到 Example Configurations，然后选择 Linux-net-tools（如果是 Ubuntu 系统，选择 Debian/Ubuntu）。会出现几行代码。我们**先不要关闭这个页面**。

{% asset_img 3.jpg This is an test image %}

<br>

<!--more-->

## 2.VPS配置IPv6

通过SSH登录VPS之后，复制上面的代码，全部运行。至此应该已经成功了，我们可以顺便测试一下。可以运行 `ping6 google.com`，测试是否能 ping 通，如果能 ping 通，说明一切正常了，我们已经可以使用 IPv6 了。

**需要注意的是，这个是将ipv6的数据封装在了ipv4报头中，通过ipv4隧道传输数据到目的节点。目的节点再解封ipv4报文转发ipv6数据。同时ipv4隧道中可能会有其他流量来消耗你的带宽。**

## 3.设置开机自启

下面我们设置 IPv6 开机启动。新建文件：

```
vim /root/ipv6.sh
```

按一下 i 进行插入，输入如下内容：

```
#!/bin/bash

ifconfig sit0 up
ifconfig sit0 inet6 tunnel ::YOUR-IPV4
ifconfig sit1 up
ifconfig sit1 inet6 add YOUR-IPV6
route -A inet6 add ::/0 dev sit1
```

上面的代码记得替换成你自己的 IPv4 和 IPv6 地址，**其实就是把之前页面显示的代码抄过来，前面加上一行 #!/bin/bash 即可**。

按一下 Esc 键，然后输入 :wq 保存并退出。

给文件增加可执行权限：

```
chmod +x /root/ipv6.sh
```

然后编辑下面的文件：

```
vim /etc/rc.d/rc.local
```

在最下方加入下面一行代码：

```
sh /root/ipv6.sh
```

保存并退出，这样重启后也有 IPv6。

