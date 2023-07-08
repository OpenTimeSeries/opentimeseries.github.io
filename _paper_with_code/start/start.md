---
layout: post
title: 初识GameMaker
nav_order: 2
has_children: true
permalink: /tutorials/start/
---
## 术语介绍

* **GM8** 是 ~~GayMaker~~ **GameMaker8.0** 的缩写。顾名思义，GM8 是一款专门针对**制作游戏**而开发的编程工具。
* **GM8.1/GM81** 是 GameMaker8.1 的缩写，GM8 的底层实现是 Delphi，而 GM8.1 的底层实现是 C++，由于 bug 众多为人诟病。总的来说 GM8.1 是 GMS 的试验品，不建议使用。
* **GMS** 是 GameMaker: Studio 的缩写，为 GM8 的后续增强版本，目前有 GameMaker: Studio（简称 GMS 或 GMS1）和 GameMaker: Studio 2（简称 GMS2）两代，其中 GameMaker: Studio 2 现在已经更名为 [GameMaker](https://gamemaker.io/)，并且从买断制变成了订阅制。新版本的 GameMaker 也习惯性地被称为 GMS2 以和旧版本 GameMaker 区分。
* **GML** 是 **GameMaker Language** 的缩写，为 GM 系列所使用的编程语言。由于 GMS2 中对 GML 的改动越来越大，近年来也出现了 GMSL（即GameMaker Studio Language）的说法来称呼 GMS2 中的 GML。
* **gmk** 是指 GameMaker8.0 的工程文件，即源文件。

## 下载地址

我知道你们懒得找，[下载地址戳这](https://pan.baidu.com/s/1AbKfIDRf8coPeZpcfAHdFw?pwd=qt2c)（~~正版是不存在的~~）

## 打开高级模式

第一次打开 GM8，如果出现一个弹窗提示（不好意思我找不到图），询问你是否开启 **Advanced Mode（高级模式）**，请点 **yes**。

如果没有出现，请点击左上角的 **File（文件）**，确认是否勾选 **Advanced Mode（高级模式）**，如图所示：

![Advanced Mode](/assets/images/start/advanced_mode.png)

## 资源文件夹

做完上面的事之后，我们可以看到，在左边的框框里有一竖的文件夹，如图所示：

![Resource Folders](/assets/images/start/resource_folders.png)

这些文件夹是用来分类储存各种资源的。

先简单地介绍其中一些好理解的：

**Sprites（精灵）**和 **Backgrounds（背景）**：都是用来存放图片资源的文件夹。

二者的区别是：

Backgrounds 顾名思义，是用来存放背景图片的文件夹，放在这个文件夹的图片的特点是：尺寸比较大，一般不会发生变化，常用作游戏的背景的图片。

与此相反 Sprites 存放的是尺寸较小，灵活性大的图片（比如 gif），一般用作游戏中各个小物体的图像。

简单的举个例子：你正在做一个打飞机弹幕射击游戏（即STG），假设你的游戏背景是一幅星空图，那么它应该放在 Backgrounds 里，而敌机和自机的图片，子弹的图片，血条的图片等等，这些应该放在 Sprites 里。

**Sounds（音效）**：用来存放背景音乐（即 BGM），效果音等的文件夹。（~~有 SS，MM，Fmod 还需要这个？~~）

**Objects（对象）**：如果将一个游戏比作一台机器设备，Objects 就是构成游戏的零件。游戏里的一个个小部件，事实上都是一个个 Objects。我们要实现任何效果，都要经由 Objects 来实现。

**Rooms（房间）**：可以简单的理解为，一个房间就是游戏的一个小关卡，或者说一张地图。

其他资源：Paths（路径），Scripts（脚本），Fonts（字体），Time Lines（时间轴）。

## 功能栏

位于屏幕的上方，如图所示：

![Top Bar](/assets/images/start/topbar.png)

从左到右分别是：

* 新建一个工程文件、打开一个现有的工程文件、保存当前工程文件
* 生成 exe、上传游戏到网络
* 运行游戏、以调试模式（Debug Mode）运行游戏
* 创建一个 Sprite/Sound/Background/Path/Script/Font/Timeline/Object/Room 资源
* 更改游戏信息、游戏全局设定、添加扩展包
* 帮助

有些看不懂没关系，以后会详讲。

## 全局游戏设定（Global Game Settings）

通过**功能栏倒数第三个按钮**，或者在 Rooms 文件夹下面的 **Global Game Settings** 双击可进入。里面的内容根据需要勾选即可。

**建议**勾选的项目：

其他---ESC 关闭游戏、按 F4 改变屏幕显示模式、按 F9 截图

错误---将未初始化的变量设置为 0

**不建议**勾选的项目：

其他---按 F5 和 F6 分别保存和载入游戏（后期会教你如何自己写代码[存档读档]({{ site.baseurl }}{% link _tutorials/make_your_game/save_load.md %})，自带的实在太废了）

## 工程文件

GM8 的工程文件是指以 **.gmk** 作为后缀的文件。

PS：后缀 .gm81 为 GameMaker8.1 的文件，.gmx 为 GameMaker: Studio 的文件，.yyp 是 GMS2 的文件。

GM8.1 问题较多，不建议使用。GMS 和 GM8 比较像，可以用 GMS 代替 GM8 学习。GMS2 和 GM8 差别较大，不建议用 GMS2 学习 GM8。
