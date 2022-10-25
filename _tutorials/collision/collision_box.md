---
layout: default
title: 碰撞盒
nav_order: 1
parent: 碰撞
---

## 碰撞盒

爱玩游戏的人，或多或少应该听说过“判定域”这个词（东方玩家敢说不知道我打死你啊）。

我们知道，在一些游戏中（尤其是东方），判断玩家中弹（或其他伤害），或者判断敌方中弹，并不是简单地判断二者图像是否重叠。

> ![Touhou](/assets/images/collision/touhou.jpg)
>
> 取自《东方永夜抄》，自机（即玩家角色）只有中心很小的一个点与弹幕重合时才被系统认为中弹。
>
> ![IWBTG](/assets/images/collision/iwbtg.png)
>
> 取自《I Wanna Be The Guy》，BOSS 只有拳套部分会杀死玩家角色。

判定域，从字面上就可以理解，是指实际参与中弹判定、接触判定、阻碍判定等的区域。判定域有一个更为专业的称呼，Collision Box，常翻译为**碰撞盒**或者碰撞箱，在本教程中以“碰撞盒”作为译名。

事实上，无论是中弹判定，阻碍判定，拾取道具判定，还是什么其他的判定，其本质上都是碰撞判定，即，本质上都是判断参与判定的二者，他们的碰撞盒是否重叠，如果重叠，那么就视二者发生了“碰撞”。

然而在 GM 中，你还能看到以下这些单词：Mask（笼罩/笼罩层/遮罩），Collision Mask（碰撞笼罩），Bounding Box（边界盒），这些词在 GM 中似乎和碰撞盒的意思都差不多，它们之间都有些什么区别呢？让我来告诉你：没什么瘠薄的区别！全部当成碰撞盒来理解就行了。越是想搞清楚就越乱。我曾与数位 GM 的大佬讨论这个问题，最后结论是，煞笔 Overmars 大概自己都搞不清楚有什么区别。

## 精灵的碰撞盒

碰撞盒是精灵的属性之一。

如下图，在精灵属性的中央位置，可以对它的碰撞盒进行修改。

![Sprite Collision](/assets/images/collision/sprite_collision.png)

首先，在不做任何额外设置的情况下，GM 默认把一切**非完全透明**的区域作为精灵的碰撞盒。上图中，miku的整个身体都被视为碰撞盒，周围的完全透明的区域则不。

再如下图的方块：

![Block](/assets/images/collision/block.png)

它虽然绝大部分区域都是透明度很高的，但并不是完全透明，所以 GM 默认它所有位置都是碰撞盒。

这里我们解释一下**精准碰撞检测**，默认情况下是勾选的。如果不勾选，那么一个精灵的碰撞盒就是这个样子：

![Nonprecise](/assets/images/collision/nonprecise.png)

就是把一个能包含所有非透明区域的最小的矩形作为碰撞盒。

GM默认的碰撞盒处理方式很多时候并不能让我们满意。比如下面这张精灵：

![GIF Miku](/assets/images/collision/gif_miku.png)

它是由多张子图构成的，每一张子图里，葱的位置都不一样。那么 GM 是怎么判断他的碰撞盒呢？如下图，灰色部分为碰撞盒。

![GIF Collision](/assets/images/collision/gif_collision.png)

也就是说，GM 默认地把所有葱的位置都当做是碰撞盒。如果把它作为 BOSS 的精灵，那问题就来了，明明这个时候，葱是在上面的，怎么碰到下面空空的地方，我也掉血了呢？

这个时候，就应该开启**独立的碰撞笼罩**。

![Independent](/assets/images/collision/independent.png)

开启后，精灵会为每一张子图都分配一个专门的碰撞盒，而不是共用一个碰撞盒。

再比如这张精灵：

![Knife](/assets/images/collision/knife.png)

自带光晕，甚是好看。但是 GM 表示，我认为你的碰撞盒是这样的：

![Knife Collision](/assets/images/collision/knife_collision.png)

哇，这还得了，光晕全都当成碰撞盒来搞了，要是做成弹幕，还不被玩家骂死。这个时候，我们就要调整一下 Alpha 容差值，把碰撞盒压在本体处：

![Edit Mask](/assets/images/collision/edit_mask.png)

除此之外，你也可以自定义碰撞盒。比如，把碰撞盒压在 miku 的胸口处：

![Custom Mask](/assets/images/collision/custom_mask.png)

## 对象的碰撞盒

在对象的编辑面板，我们可以看到有一个叫做**笼罩（Mask）**的属性：

![Object Mask](/assets/images/collision/obj_mask1.png)

一个对象，使用了某一个精灵作为自己的图像，但这并不意味着，这个对象必须使用该精灵的碰撞盒。

默认的情况下，笼罩的值为“与精灵相同”（Same as sprite）。即，对象使用自己的精灵的碰撞盒。但是我们可以改变它，选择另外一个精灵，把另一个精灵的碰撞盒用作自己的碰撞盒：

![Object Mask](/assets/images/collision/obj_mask2.png)

更换笼罩之后，新的碰撞盒会以**原点**重合的方式与对象的精灵重合。

同样的，GM也自带了变量 `mask_index` 可以改变实例的碰撞盒。`mask_index = 精灵名;` 可以把实例的碰撞盒换掉。若执行 `mask_index = -1`，则代表碰撞盒“与精灵相同”。注意，`mask_index` 效率不高，使用需谨慎。
