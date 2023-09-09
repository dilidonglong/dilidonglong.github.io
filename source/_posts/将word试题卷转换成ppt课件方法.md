---
title: 将word试题卷转换成ppt课件方法
date: 2021-01-08 18:56:38
categories: 小技巧
tags:
---

## 需求

目前要录制试题讲解视频，所以要制作ppt课件。通过手动把试题添加到一张张幻灯片的方式效率过低，所以该文档讲述如何快速将word版本的试题卷转换成PPT幻灯片。

本文稿由展宏老师口述，本人编辑记录。

<br>

## 操作流程简介

1. word中的题目和选项需要区分，可以把题目设置为标题1，选项设置为标题2，形成分级的形式
2. 在ppt中导入大纲格式的word
3. 在母版视图中设置好版式（版式里面可以设置字体、颜色、字号、背景等），一次性应用于所有幻灯片
4. 后续微调，最后保存



<!--more-->

## 操作步骤：

### 1.word设置

1. 先从试卷编辑同事处获取从后台导出的word版试题卷

{% asset_img 1.jpg This is an test image %}

2. 打开word文件后，先删除标题。

{% asset_img 2.jpg This is an test image %}

3. 然后按`ctrl+a`选择剩下全部文字内容，设置为标题2

{% asset_img 3.jpg This is an test image %}

4. 接下来需要让题目和答案选项区别开来，我们可以把每个题目都设置为标题1，但是如果想快速设置所有题目，那此处需要用到替换功能。使用替换功能，就需要观察每个题目的共同特点。比如此word中，我们发现，每个题目都会有`“数字和、”`连在一起。所以以此为依据进行替换

{% asset_img 4.jpg This is an test image %}

5. 按`ctrl+h`将弹出替换窗口，先点击下【查找内容】旁的方框，让光标处于此处。然后点击【更多】，就能看到【搜索选项】。然后点击【特殊格式】

{% asset_img 5.jpg This is an test image %}

6. 点击【特殊格式】后，选择【任意数字】，会出现如下图所示^#

{% asset_img 6.jpg This is an test image %}

{% asset_img 7.jpg This is an test image %}

7. 然后再补上一个`、`号。此时【查找内容】就设置完毕了

{% asset_img 8.jpg This is an test image %}

8. 再用鼠标点击【替换为】旁的方框，让光标处于此处。然后再点击【格式】，选择弹出框中的【样式】

{% asset_img 9.jpg This is an test image %}

9. 点击【样式】后，会弹出【替换样式】框，然后选择【标题1】，再点击【确定】

{% asset_img 10.jpg This is an test image %}

10. 最后点击【全部替换】

{% asset_img 11.jpg This is an test image %}

11. 替换完后，效果如下图所示。可以看到导航窗口内，题目和问题是变成分级结构了。

{% asset_img 12.jpg This is an test image %}

12. 此时保存文件。可以选择另存为的方式保存。这里主要是考虑到后台导出的word文件实际是html格式，所以需要改为word的doc或docx格式。**注意：自己要记得另存为文件后的存放路径**

{% asset_img 13.jpg This is an test image %}

13. 保存完毕后，关闭word文件。记得要关闭！！！！

<br>

### 2.ppt设置

1. 新建一个ppt
2. 选择【开始】—【新建幻灯片】—【幻灯片（从大纲）】

{% asset_img 14.jpg This is an test image %}

3. 选择刚刚保存的doc文件，点击【插入】

{% asset_img 15.jpg This is an test image %}

4. 效果如下图所示

{% asset_img 16.jpg This is an test image %}

5. 接下来我们需要微调，先选中【视图】—【幻灯片母版】

{% asset_img 17.jpg This is an test image %}

6. 在【幻灯片母版】—【幻灯片大小】处可以调整ppt比例

{% asset_img 18.jpg This is an test image %}

7. 在下图示界面中，删除所有版式，删不动的就可以不删。

{% asset_img 19.jpg This is an test image %}

8. 删除完后，只会留下两个版式

{% asset_img 20.jpg This is an test image %}

9. 我们打开一份平常的课件ppt，需要把我们的背景图贴上去。同样的，我们打开日常课件后，先选中【视图】—【幻灯片母版】，然后右键复制一份箭头所指的版式。

{% asset_img 21.jpg This is an test image %}

10. 复制的版式，粘贴到我们的试题ppt上，得到如图所示

{% asset_img 22.jpg This is an test image %}

11. 选择第二张版式，然后复制里面的内容，到我们的背景图版式中去

{% asset_img 23.jpg This is an test image %}

12. 接下来我们可以调整文字的展示效果。把最下方的红框内三个虚线框删除

{% asset_img 24.jpg This is an test image %}

13. 调整问题的字体颜色，字号等，这里按自己需求设置

{% asset_img 25.jpg This is an test image %}

14. 调整答案选项的字体颜色，字号等，这里按自己需求设置，同时没必要有项目符号，所以取消勾选

{% asset_img 26.jpg This is an test image %}

15. 退出母版视图

{% asset_img 27.jpg This is an test image %}

16. 在左侧边框随意选中一个幻灯片，然后按`ctrl+a`选中所有幻灯片。右键鼠标，选择【版式】，然后选择有我们背景图的那个版式。

{% asset_img 28.jpg This is an test image %}

17. 最终效果如下

{% asset_img 29.jpg This is an test image %}

<br>

### 3.完成

新建的ppt就已经全部完成。此时对于部分幻灯片内的内容可能需要自己后续手动再微调下，再有就是word中的图片是没有导入到ppt内的，所以需要你自己复制word中的试题图片然后粘贴到ppt内。

<br>

## 问题

在用ppt导入word文件时出现报错，如下图所示：

{% asset_img 问题.jpg This is an test image %}

<br>

[解决办法如下：](https://zhidao.baidu.com/question/1452777193692191460.html)不用ppt导入word了，而是改成在word中直接发送到ppt内

1. 打开word，点击“文件”菜单。

{% asset_img 30.jpg This is an test image %}

2. 点击页面左下角的“选项”

{% asset_img 31.jpg This is an test image %}

3. 进入选项页面后，点击“快速访问工具栏”

{% asset_img 32.jpg This is an test image %}

4. 再在上方下拉菜单选择“不在功能区中的命令”，然后，下拉选择“发送到Microsoftpownpoint＂，点击中间的“添加”

{% asset_img 33.jpg This is an test image %}

5. 添加成功后，在word的上面的工具栏中，会出现“发送到Microsoftpownpoint”的按钮，点击它。

{% asset_img 34.jpg This is an test image %}

6. 此时将进入打开PPT的界面。即进入到了【操作步骤】中的【2.ppt设置】