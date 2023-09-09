---
title: Nginx无法启动问题解决
date: 2020-06-03 22:44:40
categories: linux
tags:
---

## 问题：

Nginx写好配置文件后，启动时报错

报错提示：

```
Job for nginx.service failed because the control process exited with error code. See "systemctl status nginx.service" and "journalctl -xe" for details.
```

## 问题出现原因：

创建配置文件是在/etc/nginx/conf.d/这个目录下，文件名是：default.conf，使用/etc/init.d/nginx reload 命令时提示的错误

配置文件内容：

```
server {
    listen	443 ssl;
    server_name  xxx.dilidonglong.site;                  #修改为自己的域名
    ssl_certificate ssl/xxx.dilidonglong.site.crt;       #修改为自己的域名
    ssl_certificate_key ssl/xxx.dilidonglong.site.key;   #修改为自己的域名
 
    location /yuuka {                         #修改为你自己的路径，需要和V2RAY里面的路径一样
        proxy_redirect off;
        proxy_pass http://127.0.0.1:210;       #修改为你自己的v2ray服务器端口
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_connect_timeout 60s;
        proxy_read_timeout 86400s;
        proxy_send_timeout 60s;
    }
 
}

```

<!--more-->

## 解答经过：

​    网上说这种错误一般都是目录不存在或者权限不足，所以直接执行下面两条命令即可，结果发现根本行不通。

```bash
[root@typecodes ~]# cd /var/tmp/
[root@typecodes ~]# mkdir -p /var/tmp/nginx/{client,proxy,fastcgi,uwsgi,scgi}
```

## 最终解决办法：

​    1. 使用以下命令，得到错误提示如下：

```bash
[root@ecs-u4x ~]# systemctl status nginx.service
● nginx.service - The nginx HTTP and reverse proxy server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; vendor preset: disabled)
   Active: failed (Result: exit-code) since Tue 2020-06-02 15:22:46 CST; 1min 13s ago
  Process: 14014 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=1/FAILURE)
  Process: 14012 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
 Main PID: 9181 (code=exited, status=0/SUCCESS)

Jun 02 15:22:46 ecs-u4x systemd[1]: Starting The nginx HTTP and reverse proxy server...
Jun 02 15:22:46 ecs-u4x nginx[14014]: nginx: [emerg] cannot load certificate "/etc/nginx/ssl/xxx.dili...file)
Jun 02 15:22:46 ecs-u4x nginx[14014]: nginx: configuration file /etc/nginx/nginx.conf test failed
Jun 02 15:22:46 ecs-u4x systemd[1]: nginx.service: control process exited, code=exited status=1
Jun 02 15:22:46 ecs-u4x systemd[1]: Failed to start The nginx HTTP and reverse proxy server.
Jun 02 15:22:46 ecs-u4x systemd[1]: Unit nginx.service entered failed state.
Jun 02 15:22:46 ecs-u4x systemd[1]: nginx.service failed.
Hint: Some lines were ellipsized, use -l to show in full.
```

2. 根据错误提示发现`Jun 02 15:22:46 ecs-u4x nginx[14014]: nginx: [emerg] cannot load certificate "/etc/nginx/ssl/xxx.dili...file)`，这表明无法加载/etc/nginx/ssl/xxx……这个证书文件。于是查看了下/etc/nginx/ssl/目录下的文件，发现只有dilidonglong开头的证书文件，而没有xxx.dilidonglong开头的证书文件。
3. 于是把default.conf配置文件中的域名里的xxx.dilidonglong全部删掉`xxx.`。然后再重启Nginx服务，问题解决。

## 反思：

​    **多看英文，多看错误提示！**