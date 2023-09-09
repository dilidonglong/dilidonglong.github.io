---
title: grep/正则表达式/awk/sed
date: 2019-08-11 21:30:15
categories: linux
tags:
---

Linux三剑客

grep适合单纯的查找或是匹配文本

sed适合编辑我们查找到的文本

awk对于查找到的文本，可以进行格式化处理，即输出成我们想要看到的样子

正则表达式是公式。我们可以在三剑客中按（正则表达式）条件查找到我们需要的东西

<!--more-->



## 1.[grep](http://www.zsythink.net/archives/1733)

grep（global search regular expression and print out the line）

- grep  “需要搜索的字符”
- grep  -i  “需要搜索的字符”               不区分大小写
- grep  -n  “需要搜索的字符”              在行首显示字符所在行号
- grep  --color=auto  “需要搜索的字符”           字符用颜色显示
- grep  --color  “需要搜索的字符”           字符用颜色显示
- grep  -c  “需要搜索的字符”            显示字符一共所在多少行
- grep  -o  “需要搜索的字符”           显示字符，在单独的一行输出
- grep  -Bx  “需要搜索的字符”           显示字符所在的行及其前x行
- grep  -Ax  “需要搜索的字符”           显示字符所在的行及其后x行
- grep  -Cx  “需要搜索的字符”           显示字符所在的行及其前后x行
- grep  -w  “需要搜索的字符”          精确显示字符所在的行，比如字符是abc，就不会显示abcd所在行
- grep  -v  “需要搜索的字符”           显示不包含该字符所在的行
- grep  -e  “需要搜索的字符”  -e  “需要搜索的字符2”            显示多个目标字符所在行

------





## 2.正则表达式

### 2.1基本正则表达式

grep  "^hello"             打印出以hello开头的行

grep  "hello$"             打印出以hello结尾的行

grep  "^hello$"             打印出只有hello单词的行

grep  "^$"                    打印出空行，该行中有空格也不能算是一个空行

grep  "\ < hello"          打印出以hello作为一个单词词首的一行

grep  "hello\ >"          打印出以hello作为一个单词词尾的一行

grep  "\ < hello\ >"          打印出以hello作为一个单词的一行

同时可以使用\ b来表示锚定词首或词尾，即来替代\ >和\ <

使用\ B可以表示词首或词尾不是某个单词

------

#### [连续次数的匹配](http://www.zsythink.net/archives/1893)

grep  "a\ {3\ }"           打印出单词中有3个连续a的一行

grep  "\ < a\ {3\ } \ >"           打印出单词中**只有**3个连续a的一行（以连续3个a作为一个单词）

grep  "a\ {2,4\ } "           打印出单词中至少有连续2个a或最多连续4个a的一行

grep  "a\ { ,4\ } "           打印出单词中最多连续4个a的一行

grep  "a\ {2,\ } "           打印出单词中至少连续2个a的一行

grep  "a*"                   打印出单词中有n个a的一行

grep  "a.*"                   打印出单词中有a且a后面接上任意个数目及字符的行

grep  "a\ ?"                  打印出单词中能匹配到0个或1个a的行（其实有2个以上的a也能匹配到，因为2个以上的a包含0个或1个a）

grep  "a\ +"                  打印出单词中能匹配到至少1个a的行

------

#### [常用符号](http://www.zsythink.net/archives/1921)

grep  "a..."           打印出单词中能匹配到a后面接上3个任意字符的行

grep  "a[[:alpha:]]\ { 3\ }"            打印出单词中能匹配到a后面接上了3个任意大小写字母的行

[[:alpha:]]  表示任意大小写字母
[[:lower:]]  表示任意小写字母
[[:upper:]]  表示任意大写字母
[[:digit:]]  表示0到9之间的任意单个数字（包括0和9）
[[:alnum:]]  表示任意数字或字母
[[:space:]]  表示任意空白字符，包括"空格"、"tab键"等。
[[:punct:]]  表示任意标点符号

[0-9]与[[:digit:]]等效
[a-z]与[[:lower:]]等效
[A-Z]与[[:upper:]]等效
[a-zA-Z]与[[:alpha:]]等效
[a-zA-Z0-9]与[[:alnum:]]等效



grep  "a[ ^[:alpha:]]\ { 3\ }"       打印出单词中能匹配到a后面接上了3个不是大小写字母的行

[^ 0-9]与[ ^[:digit:]]等效
[ ^ a-z]与[ ^[:lower:]]等效
[ ^ A-Z]与[ ^[:upper:]]等效
[ ^ a-zA-Z]与[ ^[:alpha:]]等效
[ ^ a-zA-Z0-9]与[ ^[:alnum:]]等效



grep  "a[efg]"       打印出单词中能匹配到a后面接上了e或f或g的行

grep  "a[ ^efg]"       打印出单词中能匹配到a后面接上不是e或f或g的行



同时还有简短格式，但是并非所有正则表达式解析器都可以识别。使用的时候可以尝试加上-P参数
\d 表示任意单个0到9的数字
\D 表示任意单个非数字字符
\t 表示匹配单个横向制表符（相当于一个tab键）
\s表示匹配单个空白字符，包括"空格"，"tab制表符"等
\S表示匹配单个非空白字符

------

#### [分组及向后引用](http://www.zsythink.net/archives/1952)

grep  "\ (hello\ ) \ {2\ }"                 以hello为一个组（第一个分组），打印出单词中能匹配到2次hello的行

grep  "\ (hello\ ) word \1"             以hello为一个组，打印出有hello word hello的行。其中\1表示第一个分组

------

#### [转义符](http://www.zsythink.net/archives/1977)

grep  "a\ .\ ."                     打印出单词中能匹配到a..的行

grep  "a\ *\ *"                     打印出单词中能匹配到a**的行

grep  'a\ \ \ \ '                     打印出单词中能匹配到a\ \的行，注意此时使用单引号

------



### 2.2[扩展正则表达式](http://www.zsythink.net/archives/1999)

使用扩展正则表达式时，要加上-E参数

在扩展正则表达式中，有|这个符号，按住“shift键”和“\键”就可以打出

grep  -E  "(com|net)$"     打印出以com或net结尾的行



在基本正则表达式中需要加\，但是扩展中不需要的如下：

?  表示匹配其前面的字符0或1次

\+  表示匹配其前面的字符至少1次，或者连续多次，连续次数上不封顶。

{n} 表示前面的字符连续出现n次，将会被匹配到。

{x,y} 表示之前的字符至少连续出现x次，最多连续出现y次，都能被匹配到，换句话说，只要之前的字符连续出现的次数在x与y之间，即可被匹配到。

{,n} 表示之前的字符连续出现至多n次，最少0次，都会被匹配到。

{n,}表示之前的字符连续出现至少n次，才会被匹配到。



分组与后向引用
( ) 表示分组，我们可以将其中的内容当做一个整体，分组可以嵌套。
(ab) 表示将ab当做一个整体去处理。
\1 表示引用整个表达式中第1个分组中的正则匹配到的结果。
\2 表示引用整个表达式中第2个分组中的正则匹配到的结果。

------





## 3.awk

> awk的基本语法结构
>
> awk  [options]  'Pattern  {Action}'  file1,file2 
>
> 如果是对命令执行awk操作而不是文件，那么可以使用命令+管道符（|）+awk



### [3.1基础入门](http://www.zsythink.net/archives/1336)

df  |awk  '{print  $5}'     表示输出df信息的第五列

df  |awk  '{print  $4,$5}'     表示输出df信息的第四和第五列



- 除了输出文本或命令输出信息中的列，我们也可以自己添加信息，只需在""中添加即可

  awk  '{print  "anychar:"$4,"anychar2"$5}'  file1

- 如果写成如下格式，那么输出的就不是第五列，而是输出$5

  df  |awk  '{print  "$5"}' 



Pattern中文含义是模式，特殊的2种模式BEGIN和END

- 在执行文件1（file1）前，先执行BEGIN的内容，即先把aaa输出，然后再对文件1做处理，处理方式就是后面写的动作

  awk  'BEGIN{print  "aaa"}  {print  "anychar:"$4,"anychar2"$5}'  file1

- 在执行完对文件1（file1）的操作后，再在结尾执行END的内容，即输出aaa

  awk  '{print  "anychar:"$4,"anychar2"$5}  END{print  "aaa"}'  file1



### [3.2分隔符](http://www.zsythink.net/archives/1357)

#### 3.2.1输入分割符

文本输入的时候，默认是以空格作为分割符号的，但是我们可以手工指定在文本中的一行，该以什么符号作为区分一列的分割符

 awk  -F#  '{print  $4,$5}'  file1            通过-F参数，来指定#作为输入分割符

 awk  -v  FS='#'  '{print  $4,$5}'  file1    通过-v参数，来修改系统内置的输入分割符变量，效果同上



#### 3.2.2输出分割符

文本输出的时候，默认也是以空格作为分割符号的，但是我们可以指定其他的符号来连接不同的列

awk  -v  OFS='++++'  '{print  $4,$5}'  file1    通过-v参数，来修改系统内置的输出分割符变量



注：输出分割时，用“，”来区分。如果是想把两列连在一起，可以写成以下形式

awk   '{print  $4$5}'  file1



### 3.3awk变量

#### 3.3.1内置变量

|            名称            |   代码   |
| :------------------------: | :------: |
|         输入分割符         |    FS    |
|         输出分隔符         |   OFS    |
|       输入记录分隔符       |    RS    |
|       输出记录分割符       |   ORS    |
|    当前行被分割成了几列    |    NF    |
|            行号            |    NR    |
|     各文件分别记录行号     |   FNR    |
|         当前文件名         | FILENAME |
|      命令行参数的个数      |   ARGC   |
| 保存的是命令行所给的各参数 |   ARGV   |

awk   '{print  NR,NF}'  file1         表示输出文件1中的行号及该行的列数



FS和OFS都是以每行各个字符间隔为单位

RS和ORS是来判断以什么条件来作为换行，默认情况下，系统认为是回车即换行



#### 3.3.2自定义变量

awk  -v  变量名称="变量值"

eg： awk  -v  mychar="hahaha"   'BEGIN｛print  mychar｝'

or： awk  -v   'BEGIN｛mychar="hahaha" ; print  mychar｝'



### [3.4格式化](http://www.zsythink.net/archives/1421)

{% asset_img 1.png This is an test image %}



### [3.5模式](http://www.zsythink.net/archives/1426)

{% asset_img 2.png This is an test image %}



使用正则表达式

awk  '/正则表达式/ {print $0}'  file1

{% asset_img 3.png This is an test image %}

{% asset_img 4.png This is an test image %}





### [3.6动作](http://www.zsythink.net/archives/2046)

{% asset_img 5.png This is an test image %}

{% asset_img 6.png This is an test image %}



------





## 4.sed

> awk的基本语法结构
>
> awk  [options]  '动作'



### 4.1新增与删除

sed  'sed  2,5d'             其中d表示删除，意味删除2到第5行

```bash
[root@vultr ~]# nl /etc/passwd
     1	root:x:0:0:root:/root:/bin/bash
     2	bin:x:1:1:bin:/bin:/sbin/nologin
     3	daemon:x:2:2:daemon:/sbin:/sbin/nologin
     4	adm:x:3:4:adm:/var/adm:/sbin/nologin
     5	lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
     6	sync:x:5:0:sync:/sbin:/bin/sync
     7	shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
     8	halt:x:7:0:halt:/sbin:/sbin/halt
     9	mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
    10	operator:x:11:0:operator:/root:/sbin/nologin
    11	games:x:12:100:games:/usr/games:/sbin/nologin
    12	ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
    13	nobody:x:99:99:Nobody:/:/sbin/nologin
    14	systemd-network:x:192:192:systemd Network Management:/:/sbin/nologin
    15	dbus:x:81:81:System message bus:/:/sbin/nologin
    16	polkitd:x:999:998:User for polkitd:/:/sbin/nologin
    17	ntp:x:38:38::/etc/ntp:/sbin/nologin
    18	sshd:x:74:74:Privilege-separated SSH:/var/empty/sshd:/sbin/nologin
    19	postfix:x:89:89::/var/spool/postfix:/sbin/nologin
    20	chrony:x:998:996::/var/lib/chrony:/sbin/nologin
    21	tcpdump:x:72:72::/:/sbin/nologin
[root@vultr ~]# 
[root@vultr ~]# nl /etc/passwd | sed '2,20d'
     1	root:x:0:0:root:/root:/bin/bash
    21	tcpdump:x:72:72::/:/sbin/nologin

```





sed  '2a  字符串'，在第2行后面插入一字符串，i表示在第n行前插入字符串

```bash
[root@vultr ~]# nl /etc/passwd | sed '2,20d' |sed '1a nihaoa'
     1	root:x:0:0:root:/root:/bin/bash
nihaoa
    21	tcpdump:x:72:72::/:/sbin/nologin
[root@vultr ~]# 
[root@vultr ~]# 
[root@vultr ~]# nl /etc/passwd | sed '2,20d' |sed '1i nihaoa'
nihaoa
     1	root:x:0:0:root:/root:/bin/bash
    21	tcpdump:x:72:72::/:/sbin/nologin
[root@vultr ~]# 
[root@vultr ~]# 
[root@vultr ~]# nl /etc/passwd | sed '2,20d' |sed '2i nihaoa'
     1	root:x:0:0:root:/root:/bin/bash
nihaoa
    21	tcpdump:x:72:72::/:/sbin/nologin
[root@vultr ~]# 
[root@vultr ~]# 
[root@vultr ~]# nl /etc/passwd | sed '2,20d' |sed '20i nihaoa'
     1	root:x:0:0:root:/root:/bin/bash
    21	tcpdump:x:72:72::/:/sbin/nologin
[root@vultr ~]# 

```





想要增加多行，可以先输入\，然后回车，就会跳转到下一行。

```bash
[root@vultr ~]# nl /etc/passwd | sed '2,19d' |sed '2a nihaoa \>zaijian'
     1	root:x:0:0:root:/root:/bin/bash
    20	chrony:x:998:996::/var/lib/chrony:/sbin/nologin
nihaoa >zaijian
    21	tcpdump:x:72:72::/:/sbin/nologin
[root@vultr ~]# 
[root@vultr ~]# nl /etc/passwd | sed '2,19d' |sed '2a nihaoa \
> zaijian'
     1	root:x:0:0:root:/root:/bin/bash
    20	chrony:x:998:996::/var/lib/chrony:/sbin/nologin
nihaoa 
zaijian
    21	tcpdump:x:72:72::/:/sbin/nologin
[root@vultr ~]# 

```



### 4.2替代

sed  '2,19c  字符串'，c表示从2到19行被该字符串替代掉

```bash
[root@vultr ~]# nl /etc/passwd | sed '2,19c 2 to 19 no show'
     1	root:x:0:0:root:/root:/bin/bash
2 to 19 no show
    20	chrony:x:998:996::/var/lib/chrony:/sbin/nologin
    21	tcpdump:x:72:72::/:/sbin/nologin
[root@vultr ~]# 
```



sed  -n  '2,4p'，表示显示第2到第4行，-n参数需要加上

```bash
[root@vultr ~]# nl /etc/passwd | sed '2,4p'
     1	root:x:0:0:root:/root:/bin/bash
     2	bin:x:1:1:bin:/bin:/sbin/nologin
     2	bin:x:1:1:bin:/bin:/sbin/nologin
     3	daemon:x:2:2:daemon:/sbin:/sbin/nologin
     3	daemon:x:2:2:daemon:/sbin:/sbin/nologin
     4	adm:x:3:4:adm:/var/adm:/sbin/nologin
     4	adm:x:3:4:adm:/var/adm:/sbin/nologin
     5	lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
     6	sync:x:5:0:sync:/sbin:/bin/sync
     7	shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
     8	halt:x:7:0:halt:/sbin:/sbin/halt
     9	mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
    10	operator:x:11:0:operator:/root:/sbin/nologin
    11	games:x:12:100:games:/usr/games:/sbin/nologin
    12	ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
    13	nobody:x:99:99:Nobody:/:/sbin/nologin
    14	systemd-network:x:192:192:systemd Network Management:/:/sbin/nologin
    15	dbus:x:81:81:System message bus:/:/sbin/nologin
    16	polkitd:x:999:998:User for polkitd:/:/sbin/nologin
    17	ntp:x:38:38::/etc/ntp:/sbin/nologin
    18	sshd:x:74:74:Privilege-separated SSH:/var/empty/sshd:/sbin/nologin
    19	postfix:x:89:89::/var/spool/postfix:/sbin/nologin
    20	chrony:x:998:996::/var/lib/chrony:/sbin/nologin
    21	tcpdump:x:72:72::/:/sbin/nologin
[root@vultr ~]# 
[root@vultr ~]# nl /etc/passwd | sed -n '2,4p'
     2	bin:x:1:1:bin:/bin:/sbin/nologin
     3	daemon:x:2:2:daemon:/sbin:/sbin/nologin
     4	adm:x:3:4:adm:/var/adm:/sbin/nologin

```





sed  's/需要被替代的字符串/替换后的字符串/g'

{% asset_img 7.png This is an test image %}





### 4.3直接在文本中做修改操作

{% asset_img 8.png This is an test image %}

