---
layout: default
title: 初识GameMaker
nav_order: 2
has_children: true
permalink: /tutorials/start/
---
# 术语介绍

* **GM8**是~~GayMaker~~**GameMaker8.0**的缩写。顾名思义，GM8是一款专门针对**制作游戏**而开发的编程工具。
* **GM8.1/GM81**是GameMaker8.1的缩写，GM8的底层实现是Delphi，而GM8.1的底层实现是C++，由于bug众多为人诟病。总的来说GM8.1是GMS的试验品，不建议使用。
* **GMS**是GameMaker:Studio的缩写，为GM8的后续增强版本，目前有GMS1和GMS2两代。
* **GML**是**GameMaker Language**的缩写，为GM系列所使用的编程语言。由于GMS2中对GML的改动越来越大，近年来也出现了GMSL（即GameMaker Studio Language）的说法来称呼GMS2中的GML。
* **gmk**是指GameMaker8.0的工程文件，即源文件。

# 下载地址

我知道你们懒得找，[下载地址戳这](https://down.magecorn.com/s/gm8)（~~正版是不存在的~~）

# 打开高级模式

第一次打开GM8，如果出现一个弹窗提示（不好意思我找不到图），询问你是否开启**Advanced Mode（高级模式）**，请点**yes**。

如果没有出现，请点击左上角的**File（文件）**，确认是否勾选**Advanced Mode（高级模式）**，如图所示：

![Advanced Mode](/assets/images/start/advanced_mode.png)

# 资源文件夹

做完上面的事之后，我们可以看到，在左边的框框里有一竖的文件夹，如图所示：

![Resource Folders](/assets/images/start/resource_folders.png)

这些文件夹是用来分类储存各种资源的。

先简单地介绍其中一些好理解的：

**Sprites（精灵）**和**Backgrounds（背景）**：都是用来存放图片资源的文件夹。

二者的区别是：

Backgrounds顾名思义，是用来存放背景图片的文件夹，放在这个文件夹的图片的特点是：尺寸比较大，一般不会发生变化，常用作游戏的背景的图片。

与此相反Sprites存放的是尺寸较小，灵活性大的图片(比如gif)，一般用作游戏中各个小物体的图像。

简单的举个例子：你正在做一个打飞机弹幕射击游戏（即STG），假设你的游戏背景是一幅星空图，那么它应该放在Backgrounds里，而敌机和自机的图片，子弹的图片，血条的图片等等，这些应该放在Sprites里。

**Sounds（音效）**：用来存放背景音乐（即BGM），效果音等的文件夹。（~~有SS，MM，Fmod还需要这个？~~）

**Objects（对象）**：如果将一个游戏比作一台机器设备，Objects就是构成游戏的零件。游戏里的一个个小部件，事实上都是一个个Objects。我们要实现任何效果，都要经由Objects来实现。

**Rooms（房间）**：可以简单的理解为，一个房间就是游戏的一个小关卡，或者说一张地图。

其他资源：Paths（路径），Scripts（脚本），Fonts（字体），Time Lines（时间轴）。

# 功能栏

位于屏幕的上方，如图所示：

![Top Bar](/assets/images/start/topbar.png)

从左到右分别是：

**新建一个工程文件、打开一个现有的工程文件、保存当前工程文件**

**生成exe、上传游戏到网络**

**运行游戏、以调试模式(Debug Mode)运行游戏**

**创建一个Sprite/Sound/Background/Path/Script/Font/Timeline/Object/Room资源**

**更改游戏信息、游戏全局设定、添加扩展包**

**帮助**

有些看不懂没关系，以后会详讲。

# 全局游戏设定（Global Game Settings）

通过**功能栏倒数第三个按钮**，或者在Rooms文件夹下面的**Global Game Settings**双击可进入。里面的内容根据需要勾选即可。

**建议**勾选的项目：

其他---ESC关闭游戏、按F4改变屏幕显示模式、按F9截图

错误---将未初始化的变量设置为0

**不建议**勾选的项目：

其他---按F5和F6分别保存和载入游戏（后期会教你如何自己写代码[存档读档]({{ site.baseurl }}{% link _tutorials/make_your_game/save_load.md %})，自带的实在太废了）

# 工程文件

GM8的工程文件是指以 **.gmk** 作为后缀的文件。

PS：后缀.gm81为GameMaker8.1的文件，.gmx为GameMaker:Studio的文件，.yyp是GMS2的文件。

GM8.1问题较多，不建议使用。GMS和GM8比较像，可以用GMS代替GM8学习。GMS2和GM8差别较大，不建议用GMS2学习GM8。
