---
layout: default
title: 对象
nav_order: 6
has_children: true
permalink: /tutorials/object/
---

# 对象的自带变量

对象自身会带有一些变量，这些变量通常与对象自身的状态、属性、行为相关。例：

* `x` 对象的实例在房间的位置的x坐标。
* `y` 对象的实例在房间的位置的y坐标。
* `speed` 对象的实例的速度（单位：像素/步）。
* `gravity` 对象的重力（单位：像素/步²）。准确的说应该是对象的加速度。
* `sprite_index` 对象的实例的图像（精灵，Sprite）对应的索引（Index）。

由于自带的变量数量众多，不在此一一列出，在各个章节中逐渐介绍。

GM 自带的变量会自动染上红色，切记自定义的变量名不能和自带变量的变量名冲突！

# 对象实例的创建

正如[浅谈房间]({{ site.baseurl }}{% link _tutorials/start/room.md %}#对象objects)所说，我们可以通过直接在房间里面放置对象（Objects）来创造它的实例（Instances）。但是有的时候，我们并不想让他们在房间开始的时候就创建，例如射击游戏中，子弹的实例应该在射击时才被创建。

这时我们可以用到这个函数：

* `instance_create(x, y, obj)` 在房间的 (x, y) 的位置创造一个对象 obj 的实例，并返回这个实例的索引（ID）。

例子：

新建对象 objControl，objBullet。在对象 objControl 的 create 事件（创建事件）里写：

```c
alarm[0] = 50;    // 这句话的意思是 50 步之后执行 alarm 0 事件
```

在对象 objControl 的 alarm 0 事件（计时器 0 号事件）里写：

```c
instance_create(100, 200, objBullet);
alarm[0] = 50;
```

给对象 objBullet 加上子弹的精灵（Sprite），然后在 create 事件里写上：

```c
speed = 6;    // 注意：speed默认方向为向右
```

把对象 Control 摆在房间里，设置房间速度为 50 帧，运行游戏，就实现了每隔 1 秒钟在位置 (100,200) 创建一个向右的速度为6像素/步的子弹。

![Example](/assets/images/object/example1.png)

![Example](/assets/images/object/example2.png)

![Example](/assets/images/object/example3.png)

![Example](/assets/images/object/example4.png)

![Example](/assets/images/object/example5.png)

效果如图：

![Effect](/assets/images/object/effect.gif)

*注意：实例在离开游戏窗口之后不会自动销毁。*

也就是说，上面的例子中离开游戏窗口的子弹，实际上还是一直在向更右的右边运动。所以，在制作弹幕游戏时，若不清理掉离开了游戏窗口的实例，必然会导致游戏越玩越卡。

所以我们应该在对象 objBullet 的**离开游戏房间事件**里写上：

```c
instance_destroy();
```

这样 objBullet 的实例在超出房间边缘时会自我销毁：

![Destroy](/assets/images/object/destroy1.png)

![Destroy](/assets/images/object/destroy2.png)
