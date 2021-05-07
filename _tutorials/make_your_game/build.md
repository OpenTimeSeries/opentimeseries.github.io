---
layout: default
title: 构建
nav_order: 7
parent: Make Your Game!
---

# 游戏图标

默认的情况下，我们的游戏图标是这样子的：

![ICON](/assets/images/make_your_game/icon.png)

我们可以将自己的图片作为图标，而不是用 GM 的默认图标。首先，你需要把你的图片转换为 **icon 格式**。别问我怎么转，百度啊百度呀百度哇。然后，打开游戏的 **Global Game Settings**，选择**装载**——**变更图标**：

![Change ICON](/assets/images/make_your_game/change_icon.png)

选择你的 icon 图像即可。

# 生成

点击下图中的图标生成游戏：

![Compile](/assets/images/make_your_game/compile.png)

会弹出一个选项框，询问你保存 exe 在什么位置。一般默认保存在和 gmk 相同的位置。

*注意，如果你的游戏有附加资源，比如上面存档与读档一节中，你的路径不是 `working_directory + "\save.dat"` 而是 `working_directory + "\Data\save.dat"` 或是其他的文件夹，那么这个文件夹也是你的游戏的一部分，所以你在发布游戏的时候，要把这些外置文件夹连同 exe 一起打包。除此之外，还有后面会讲到的外置 dll，外置音乐等，也要一起打包。*

还有一点是，记得写一个 readMe.txt 告诉玩家游戏的操作方式，一并打包，不然玩家会一脸懵逼的。

*注意：.gmk 和 .gbl 是游戏的工程文件，千万别一起打包发出去了。*

# 后话

能坚持看到这里，我要恭喜你，你现在已经有能力制作一个简易的小游戏了。

但是，GML 的学习才刚刚开始，12 章的内容实际上也就刚讲了个皮毛罢了。尤其是对于 GM 最重要，最复杂，最庞大的绘制系统，本教程截止于此几乎还没有过任何的接触。前路漫长，与君共勉。
