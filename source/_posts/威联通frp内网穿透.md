---
title: 威联通frp内网穿透
date: 2020-11-21 21:18:17
categories: 小技巧
tags:
---

## 1.概述

该篇文档为自己所做笔记，防止后续忘记如何部署。

1、没有公网IP想要访问内网的NAS

2、通过VPS搭建Frp服务来访问NAS

<br>

## 2.FRP服务器安装

### 2.1 服务器部署

1. 命令行中，输入以下命令，并回车。直接复制即可。

```bash
wget --no-check-certificate https://raw.githubusercontent.com/clangcn/onekey-install-shell/master/frps/install-frps.sh -O ./install-frps.sh

chmod 700 ./install-frps.sh

./install-frps.sh install
```

<!--more-->

2. 安装过程一些注意项如下，其他的项可以默认就行。

```bash
Please select frps download url:
[1].aliyun (default)
[2].github
Enter your choice (1, 2 or exit. default [aliyun]): y #选择frp服务器端下载地址，默认阿里云
Please input frps bind_port [1-65535](Default Server Port: 5443): #输入frp提供服务的端口，用于服务器端和客户端通信（这个要记住）
Please input frps dashboard_port [1-65535](Default dashboard_port: 6443): #输入frp的控制台服务端口，用于查看frp工作状态（IP+端口就可以登录）
Please input frps vhost_http_port [1-65535](Default vhost_http_port: 80): #输入frp进行http穿透的http服务端口（这个要注意威联通默认是8080端口，Qfile等客户端配置的时候要与这个对应起来）
Please input frps vhost_https_port [1-65535](Default vhost_https_port: 443): #输入frp进行https穿透的https服务端口
Please input dashboard_user (Default: admin): #输入frp控制台管理用户名
Please input dashboard_pwd (Default: JUqYheKf): #输入frp控制台管理码，默认是随机生成的（修改成自己的便于查看控制台）
Please input privilege_token (Default: WEWLRgwRjIJVPx2kuqzkGnvuftPLQniq): #输入frp服务器和客户端通信的密码，默认是随机生成的
Please input frps max_pool_count [1-200](Default max_pool_count: 50): #设置每个代理可以创建的连接池上限，默认50
Please input frps log_max_days [1-30]
(Default log_max_days: 3 day): #设置日志保留天数，范围是1到30天，默认保留3天。

##### Please select log_file #####

1: enable
2: disable

#####################################################
Enter your choice (1, 2 or exit. default [1]): #设置是否开启日志记录，默认开启，开启后日志等级及保留天数生效，否则等级和保留天数无效
```

注意放通服务器端口

<br>

3. FRP命令说明

```bash
./install-frps.sh update 更新
./install-frps.sh uninstall 卸载
frps start 启动服务
frps stop 停止服务
frps restart 重启服务
frps version 版本查看
```

<br>

## 3. 威联通客户端配置

1. 进入container station

{% asset_img 1.jpg This is an test image %}

2. 在【镜像文件】中，如图设置，在镜像文件名称中输入qinmenghua/frpc

{% asset_img 2.jpg This is an test image %}

3. 提取处镜像后，会有一个镜像文件。点击该镜像旁边的+号，然后如图设置。红框处是设置配置文件位置。默认是/home目录下

{% asset_img 3.jpg This is an test image %}

4. 在弹出的框中，如图设置

{% asset_img 4.jpg This is an test image %}

5. 在【共享文件夹】中的【挂载本机共享文件夹】选择自己提前创建好的目录，后续配置文件**frpc.ini**真实的放置在这个文件夹下。在【挂载路径】中设置配置文件的文件夹，这个文件夹是不需要你手动把文件放进去的。最后点击创建。

{% asset_img 5.jpg This is an test image %}

6. 在container station中启动docker

{% asset_img 6.jpg This is an test image %}

<br>

## 4.创建配置文件

```
[common]
server_addr = #为服务端IP地址，填入即可。
server_port = 9999 #为服务器端口，填入你设置的端口号，就是那个Bind port
token = #是你在服务器上设置的连接口令token


[Qnas] #自定义服务项
type = http #链接模式
local_ip = 192.168.1.8 #本地NAS的ip
local_port = 8080 #NAS链接端口
use_gzip = true
use_encryption = true
pool_count = 20
privilege_mode = true
custom_domains = #有域名可以填写

[Qnas2] #自定义服务项
type = https #链接模式
local_ip = 192.168.1.8 #本地NAS的ip
local_port = 443 #NAS链接端口
use_gzip = true
use_encryption = true
pool_count = 20
privilege_mode = true
custom_domains = #有域名可以填写
```

配置文件需要命名为**frpc.ini**

注意事项：配置文件中的注释需要删除掉，不然会在docker中报错。

<br>

## 5.问题

在客户端上启动服务后，出现过报错login to server failed: i/o deadline reached

{% asset_img 7.jpg This is an test image %}

网上查找资料没有解决。重启了下服务器后，居然就能连上了。。。。。。

