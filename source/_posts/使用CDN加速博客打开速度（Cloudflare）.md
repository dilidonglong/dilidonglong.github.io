---
title: 使用CDN加速博客打开速度（Cloudflare）
date: 2019-09-27 23:03:52
categories: 小技巧
tags:
---

# 1.概述

由于github的服务器在国外，所以有时候访问会比较卡慢，甚至在特殊时期，网站可能会打不开。通过CDN技术可以缓解这一问题。

CDN技术简单可以理解成：在世界各地分布部署有各个缓存服务器，它们会提前缓存网站上的资源内容。当用户想要访问网站资源时，通过DNS解析，指向离用户最近的一台缓存服务器。然后直接从缓存服务器上取就可以了。这样不仅可以增加访问速度减少访问延迟，还可以减缓网站服务器上的压力。

<!--more-->

<br>

我们需要准备的内容：

1. 一个域名
2. 注册使用Cloudflare
3. Cloudflare关联github



# 2.域名注册

我是在[ResellerClub](https://cn.resellerclub.com/)上注册的域名，主要是图便宜，界面支持中文，同时还可以支付宝付款。我买的这个域名才6块钱。以下是网络上的一些描述

> ResellerClub成立于1998年，创建于印度
>
> 一，亚洲最大的域名主机提供商。售后服务等有保证。
>
> 二， 域名过户免费，可以在线修改，无需提交任何书面材料，这点是很赞的。国内域名商进行域名过户麻烦不堪，提交申请、变更注册人、等待审核，更多时候不给你进行过户，让你进得来出不去。
>
> 三， ResellerClub免费赠送高达15个邮箱的中文企业邮局。企业邮局对于很多个人或者中小企业来说十分重要，它们提供的中文企业邮局基本满足个人及中小企业的需求，在一定程度上大大地节约了成本。
>
> 四， 最赞的是whois隐私保护免费，可显示中性whois信息，对于whois信息这个很多人都知道在很多域名商那里都是收费的。
>
> 五， ResellerClub还有多样化的返款政策，相信不少使用者都受益匪浅，小编致电ResellerClub中国支持中心了解到ResellerClub的代理政策。现在代理ResellerClub旗下产品只要99元，并且代理费还是可消费的!看了ResellerClub中文官网的相关内容后，发现ResellerClub除了上面的域名注册、域名续费返款外，ResellerClub的域名转入如果量大的话也可以获得较大的返款政策。

1. 注册一个账号（过程略）
2. 在界面中选择注册域名，然后挑一个最便宜的域名购买就可以了，比如下面这么多域名里面框框的是最便宜的

{% asset_img 1.png This is an test image %}

<br>

{% asset_img 2.png This is an test image %}

<br>

3. 购买完后，可以看到自己的[域名管理界面](https://cp.cn.resellerclub.com/servlet/ViewDomainServlet?orderid=88415254&referrerkey=SDVaUnQrOS93aWp3UjZCMWFrbDhLM244Q1Q2NjJGUDdINCtRWWxzT2c5OD0=)

{% asset_img 3.png This is an test image %}

<br>

# 3.配置CDN

参考该文档[为博客添加免费的 CDN (Cloudflare)](https://mogeko.me/2019/056/?tdsourcetag=s_pcqq_aiomsg)

该篇文档中的这一步，我们需要到购买域名的管理网站上做修改。把域名服务商的域名替换成Cloudflare给的。

{% asset_img 4.png This is an test image %}

<br>

{% asset_img 5.png This is an test image %}

<br>

同时该文档中的添加别名记录设置如下

{% asset_img 6.png This is an test image %}

<br>

设置SSL证书如下

{% asset_img 7.png This is an test image %}

<br>

# 4.和Github个人网页做关联

在github个人库中进行如下图设置

{% asset_img 8.png This is an test image %}

<br>

{% asset_img 9.png This is an test image %}

<br>

# 5.本地博客设置

在本地创建一个CNAME文件，注意大写同时不包含后缀 

文件创建位置：~/blog/source/CNAME

文件里的内容写你自己的域名，然后保存，比如我的是

```txt
dilidonglong.site
```

然后修改站点配置文件~/blog/_config.yml：

```yaml
# URL
## If your site is put in a subdirectory, set url as 'http://yoursite.com/child' and root as '/child/'
- url: https://dilidonglong.github.io/
+ url: https://dilidonglong.site/
```

<br>

以上内容就全部完成了，后续就可以使用 https://dilidonglong.site 访问个人网站了