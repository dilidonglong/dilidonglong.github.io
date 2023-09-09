---
title: 使用github+hexo创建一个博客
date: 2019-04-25 15:01:58
tags:
categories: 小技巧
---

# 使用github+hexo创建一个博客

github建库过程略

在Windows系统下，要使用hexo需要先安装Nodejs以及Git



## 1.安装Nodejs

[Nodejs下载地址](https://nodejs.org/en/)，下载之后，一路默认安装

<!--more-->

{% asset_img Nodejs.png This is an test image %}



## 2.安装Git

[Git下载地址](https://gitforwindows.org/)，下载之后又是一路安装

{% asset_img Git.png This is an test image %}



## 3.安装Hexo

### 3.1创建一个文件夹

创建一个文件夹，比如hexo。来存放数据(这个blog不用管，是后面初始化后自动创建的)

{% asset_img mkdir.png This is an test image %}



在这个目录下右键，选择红框所示内容。之后会弹出一个框，里面使用的是bash命令。

{% asset_img gitbash.png This is an test image %}

{% asset_img bash.png This is an test image %}



### 3.2安装过程

在界面中输入下面内容，关于指令含义参考：[Hexo-指令](https://hexo.io/zh-cn/docs/commands.html#generate)

```bash
$ cd d:/hexo
$ npm install hexo-cli -g 
$ hexo init blog             #初始化一个文件夹，命名为blog
$ cd blog
$ npm install
$ hexo g                     # 或者hexo generate
$ hexo s                     # 或者hexo server，可以在http://localhost:4000/ 查看
```

> 经常使用的命令：
>
> 1. hexo generate (hexo g)                生成静态文件，会在当前目录下生成一个新的叫做public的文件夹
> 2. hexo server (hexo s)                     启动本地web服务，用于博客的预览
> 3. hexo deploy (hexo d)                    部署播客到远端（比如github, heroku等平台）
> 4. hexo new "postName"                  新建文章，postname指创建的文件名，文件会放在source\ _posts\下
> 5. hexo new page "pageName"        新建页面，pagename指创建的网页文件夹名，文件夹放在source\下



### 3.3更换主题

```bash
$ hexo clean          #清除缓存文件 (db.json) 和已生成的静态文件 (public)。
                      #在某些情况（尤其是更换主题后），如果发现您对站点的更改无论如何也不生效，您可能需                       #要运行该命令
$ git clone https://github.com/zhwangart/hexo-theme-ocean.git themes/ocean
```

#### 3.3.1使用主题

修改Hexo目录下的_config.yml配置文件中的theme属性，将其设置为ocean。

{% asset_img theme.png This is an test image %}



#### 3.3.2更新主题

```bash
$ cd themes/ocean
$ git pull
$ cd ..
$ hexo g                # 生成
$ hexo s                # 启动本地web服务器
```





## 4.使用hexo deploy部署

[部署命令说明](https://hexo.io/zh-cn/docs/deployment.html)

### 4.1扩展安装

```bash
npm install hexo-deployer-git --save
```



### 4.2修改配置

{% asset_img deployer.png This is an test image %}

```yaml
deploy:
  type:git
  repo:https://github.com/dilidonglong/dilidonglong.github.io.git
  branch:master
```



### 4.3完成部署

然后在命令行中执行

```bash
$ hexo d              #部署之前预先生成静态文件
```

即可完成部署。



### 4.4其他注意事项

上述命令虽然简单方便，但是偶尔会有莫名其妙的问题出现，因此，我们也可以追本溯源，使用git命令来完成部署的工作。

```bash
$ cd d:/hexo/blog
$ git clone https://github.com/dilidonglong/dilidonglong.github.io.git .deploy/dilidonglong.github.io
```

将我们之前创建的仓库克隆到本地，新建一个目录叫做.deploy用于存放克隆的代码。前提是这个库里面有你之前上传上去的内容。

接下来创建一个deploy脚本文件，比如可以取名叫deploy.sh

```
hexo generate
cp -R public/* .deploy/dilidonglong.github.io
cd .deploy/dilidonglong.github.io
git add .
git commit -m “update”
git pull --rebase origin master
git push origin master
```

简单解释一下，hexo generate（hexo g）生成public文件夹下的新内容，然后将其拷贝至dilidonglong.github.io的git目录下，然后使用git commit命令提交代码到dilidonglong.github.io这个repo的master branch上。

需要部署的时候，执行这段脚本就可以了（比如可以将其保存为deploy.sh）。执行过程中可能需要让你输入Github账户的用户名及密码，按照提示操作即可。执行时，等同linux命令行：`./deploy.sh`



```
git pull --rebase origin master
对于这条命令，是为了解决git push错误failed to push some refs to的问题
```

上述问题的[参考链接](https://blog.csdn.net/MBuger/article/details/70197532)



> 参考文章：
>
> [手把手教你使用Hexo + Github Pages搭建个人独立博客](https://linghucong.js.org/2016/04/15/2016-04-15-hexo-github-pages-blog/?tdsourcetag=s_pcqq_aiomsg)
>
> [一个看板娘入住你的个人博客只需要三步](https://www.cnkirito.moe/live2d/#lg=1&slide=0)
>
> [hexo博客美化添加live2d](https://mrlichangming.github.io/2018/10/24/hexo博客美化添加live2d/)

