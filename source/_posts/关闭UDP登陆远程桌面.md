---
title: 关闭UDP登陆远程桌面
date: 2020-12-30 23:27:44
categories: 小技巧
tags:
---

## 1.现象及猜测

windows VPS部署在国外，需要通过远程桌面的方式进行登陆。在连接过程中会产生卡顿，极大限度影响操作。查看桌面上的连接提示，说是尝试使用了UDP登陆。

但是我有一台线路良好的中转服务器把流量转发到windows vps上，转发的是TCP流量。怀疑是使用远程登陆的过程中，本地使用了udp协议连接到windows VPS，导致流量没有走中转服务器转发。同时udp被qos，导致访问出现卡顿现象。

<br>

## 2.本地电脑禁用UDP方式登陆远程桌面

1. 因为是win10家庭版电脑，无法打开组策略，所以通过修改注册表（运行—regedit）的方式关闭udp

2. 此策略设置指定是否使用 UDP 协议以通过远程桌面协议访问服务器。

   如果启用此策略设置，则远程桌面协议流量仅使用 TCP 协议。

   如果禁用或未配置此策略设置，则远程桌面协议流量将尝试同时使用 TCP 和 UDP 协议。

| Registry Hive  | HKEY_LOCAL_MACHINE                                           |
| -------------- | ------------------------------------------------------------ |
| Registry Path  | SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services\Client |
| Value Name     | fClientDisableUDP                                            |
| Value Type     | REG_DWORD                                                    |
| Enabled Value  | 1                                                            |
| Disabled Value | 0                                                            |

{% asset_img 1.jpg This is an test image %}

3. 关闭udp后，果然问题解决。