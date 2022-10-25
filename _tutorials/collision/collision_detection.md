---
layout: default
title: 碰撞检测
nav_order: 2
parent: 碰撞
---

## 碰撞事件

**碰撞事件（Collision Event**），从字面上理解，就是判断两个对象的实例的碰撞盒是否重叠，如果重叠了，就会执行的一种事件。

新建碰撞事件，需要为这个事件选定一个碰撞对象，如图：

![Collision Event](/assets/images/collision/collision_event.png)

一个对象可以为他设置多个碰撞事件，理论上，最多可以为一个对象设置等同于总对象数量那么多的碰撞事件（也可以设置和自己碰撞的碰撞事件）。

*注意：只要二者的碰撞盒仍处于重叠状态，那么碰撞事件每一步都会执行一次*。在一些碰撞判定中，比如子弹打中BOSS，如果没有任何特殊处理，那么子弹穿过 BOSS 的这几步，BOSS 每一步都会减一滴血，所以，要么让子弹完成碰撞后立马 `instance_destroy()`，要么给 BOSS 设置无敌时间。至于如何给 BOSS 设置无敌时间，后期我大概会写一个 BOSS 专题来讲。

正如之前所说，无论是中弹判定，接触判定，阻碍判定，其本质都是碰撞判定，比如，玩家角色与地面碰撞，就应该把速度清空，子弹与 BOSS 碰撞，就应该令 BOSS 扣血（用变量控制），玩家角色中弹（或触碰其他危险物品），就要先销毁玩家角色，然后再播放死亡音效，增加死亡数（最好作为全局变量），并且弹出死亡菜单或者其他死亡效果等（一般而言就是用大量的 objects 堆效果）。

## other

在碰撞事件中，如果我们要让被碰撞方（即为碰撞事件选定的对象）做点事，如果被碰撞方的对象只有一个实例，我们仍然可以用传统的 `对象名.xx` 或者 `with (对象)` 方式。

但是如果被碰撞方同时有多个实例在场，而我们只要碰撞盒和碰撞方重叠的那个实例执行些什么，而不影响其他没有碰撞的实例，就应该用到 GM 提供的 **other** 关键字。

比如，在 BOSS 的对象中，新建一个碰撞子弹的事件，在碰撞事件中，我们应该让 BOSS 减血，假设用变量 hp 来储存血量，就应该是：

```c
if (hp > 0)
    hp -= 1;
```

但是正如我们上面所说，子弹穿过 BOSS 也是要时间的，在这段时间里，BOSS 每一步都会减血，所以我们要摧毁和 BOSS 碰撞的子弹，但是又不能影响其他没有打中 BOSS 的子弹：

```c
if (hp > 0)
    hp -= 1;
with (other)
    instance_destroy();
```

other 就能胜任这一功能。

这并不是第一次提到 other，在之前我们也有讲过，在 [with 结构]({{ site.baseurl }}{% link _tutorials/object/interaction.md %}#with-语句)中，用 other 表示调用 with 的对象的实例：

```c
xx = 55;
with (objHat)
  xx = other.xx;
```

因此，在碰撞事件中，你可以有这样的操作：

```c
with (other)
  xx = other.xx;
```

要分清楚这两个 other 的区别，`with (other)` 的 other 指被碰撞的实例，`other.xx` 的 other 则指执行碰撞事件的实例。

和 global 一样，other 也是一种特殊实例，它指向的真实实例随着场合的不同而不同。other 的索引是 -2，即可以用 `(-2)` 来取代 other 关键字：

```c
with (-2)
  xx = (-2).xx;
```

## 固体属性

在[浅谈对象]({{ site.baseurl }}{% link _tutorials/start/object.md %})中，我们跳过了一些属性没有详讲，其中一个就是**固体（Solid）**属性。

![Solid](/assets/images/collision/solid.png)

固体属性可以在代码中用 `solid = false;` 或 `solid = true;` 来改变一个实例的固体属性。

浏览 GML 的汉化文档，你会发现 GML 有很多对固体生效的函数，如下：

![Documentation Solid](/assets/images/collision/doc_solid.png)

很多函数都拆分为，对固体实例生效，和对所有实例生效两个函数。这种分类，就更好地去模拟一些物理行为。但是固体属性的意义不止于此。

*固体属性在碰撞事件中有十分重要的意义。*

如图，我们新建一个 objBall 和 objBlock，给 objBall 一个碰撞 objBlock 事件，在二者都不勾选固体的情况下：

![Example Solid](/assets/images/collision/example_solid1.png)

给 objBall 一个初速度：

![Example Solid](/assets/images/collision/example_solid2.png)

在房间里摆上二者：

![Example Solid](/assets/images/collision/example_solid3.png)

运行游戏，objBall 会直接穿过 objBlock，如下 gif 所示：

![Result Solid](/assets/images/collision/result_solid1.gif)

但是如果我们给被碰撞体，即 objBlock 勾选上固体属性，其他仍然保持不变：

![Example Solid](/assets/images/collision/example_solid4.png)

objBall 并不会穿过 objBlock：

![Result Solid](/assets/images/collision/result_solid2.gif)

这就是固体属性在碰撞中的意义：**如果被碰撞方是固体，那么碰撞方不会穿过被碰撞方，无论碰撞方是不是固体**。反过来也可以得出结论：**如果碰撞方是固体，那么碰撞方不会穿过被碰撞方，无论被碰撞方是不是固体**。总结成一句话：

> **只要参与碰撞的双方有一方或两方是固体，则不会发生穿透。**

*注意：固体属性是建立在有相应碰撞事件基础上的，如果二者并没有对应的碰撞事件，那么不管是不是固体都会穿透。*

这个性质特别适合用来做横版游戏：把 objBall 想象成玩家角色，把 objBlock 想象成砖块，给砖块勾选固体属性，并给玩家角色添加碰撞砖块的碰撞事件，那么玩家从空中下落到砖块上时，就会自动停止在砖块上。

*注意：与固体 objBlock 碰撞后，虽然 objBall 停止了，但这并不意味着速度被清除了，如果 objBlock 被移除了，objBall 还会继续下落。*

我们来理解一下发生了什么。首先，objBall 自由下落，直到他的碰撞盒和 objBlock 的碰撞盒重叠了，触发 objBall 的碰撞事件，而碰撞事件在执行代码之前，还要先检测一下被碰撞的实例是不是固体。

这时碰撞事件发现发现 objBlock 是固体，那么在执行碰撞事件里的代码之前，碰撞事件还要再做一件额外的事情：让 objBall 退回到上一步所在的位置，即还没有发生碰撞的位置。（如果 objBlock 也在运动，objBlock 也会回退到上一步所在的位置，虽然 objBlock 并没有碰撞事件，但是 objBall 的碰撞事件会承担这个职责）

回退到上一步的位置有什么用呢？

实际上，虽然看起来 objBall 是静止的，但由于速度并没有清零，每一步它的速度仍然实现了，每一步 objBall 都要往下移，然后碰撞盒与 objBlock 重叠，触发碰撞事件，又再一次地回到上一帧还没有碰撞的位置，以此保持动态平衡。

由于 speed 实现导致 objBall 下移，和 objBall 发生碰撞事件又回到原位，这两件事是在同一步之内发生的，而图像每一步只画一次，最终 objBall 的图像画在什么位置，取决于 objBall 最后在什么位置，也就是说，objBall 下移是不会被表现出来的，所以我们看到的 objBall 是静止在 objBlock 上的，而不是上下鬼畜。

正因此，objBall 停止在 objBlock 上时，每一步都会执行碰撞事件和里面的代码，切勿以为碰撞事件只执行一次。

一般来讲，最好在固体碰撞事件中手动添加 `speed = 0;`，即让碰撞事件只执行一次，这样其实在很多时候都更方便做游戏。

## 碰撞检测函数

* `place_meeting(x, y, obj)` 判断实例在 (x, y) 是否与指定对象的实例碰撞，返回值为 1（真）或 0（假）。参数 obj 也可以填实例 id 而不是对象名。

  举例来说，在obj1 里检测 place_meeting(200,200,obj2)：

  ![place_meeting](/assets/images/collision/place_meeting.png)

  虽然 (200, 200) 这个坐标并不在 obj2 的碰撞盒范围内，但是，如果把 obj1 的碰撞盒移动到 (200, 200) 的位置，obj1 的碰撞盒就会和 obj2 的碰撞盒重叠，那么 place_meeting(200, 200, obj2) 就会返回 1。

  *注意：obj1 的碰撞盒并没有真正移动，只是在假设的前提下判断是否发生碰撞。*

  如果你想要检测是否与任何实例发生碰撞，你也可以在参数 obj 处填写 **all**。**all** 是 GM 的特殊实例之一，它的 id 是 -3，代表所有的实例。比如，你可以用 `all.x = 100;` 把所有实例都移动到 x 为 100 的位置来。

* `place_empty(x, y)` 该函数用来检测，如果把实例移动到 (x, y) 位置，是否会与任何实例发生碰撞。注意函数名是 empty，所以，不会发生碰撞就返回 1，会发生碰撞则返回 0，和 place_meeting 是相反的。
* `place_free(x, y)` 函数同上，只是这个函数检测的是是否会与固体实例发生碰撞而不是全部实例。

有时候，我们不仅是想要判断是否发生碰撞，还想要知道是和哪个实例发生了碰撞。

* `instance_place(x, y, obj)` 这个函数的原理和 `place_meeting` 是一样的，也是假设把实例的碰撞盒移动过去，检测是否发生碰撞。只不过，这个函数返回的是被碰撞的实例的 id，如果不发生碰撞，则返回 **noone**。

`noone` 也是GM的特殊实例之一，索引是 -4，它的意思是“没有实例”或者“不存在实例”。

复习一下我们学过的所有特殊实例：

1. **self**(-1)，表示实例自己，如果一个变量名被 globalvar 声明了，那么之后使用这个变量名一律表示全局变量，如果实例自身也有一个局部变量是同样的名字，就要用 `self.` 作为前缀。
2. **other**(-2)，表示 with 结构中调用 with 的实例，或者碰撞事件中被碰撞的实例。
3. **all**(-3)，表示所有的实例。
4. **noone**(-4)，表示没有实例。
5. **global**(-5)，表示一个全局实例，它的变量不会因为房间变换而被销毁。

按照 id 的顺序排列，就是 self，other，all，noone，global。事实上，他们就是普通的整数常量。比如说，你可以写 `a = other * global;`，可以计算得到 a 的值为 10。

其实，GM 还有 id 为 -6 和 -7 的两个特殊实例，更详细的请看[索引]({{ site.baseurl }}{% link _tutorials/index.md %})章节。

* `collision_point(x, y, obj, prec, notme)` 这个函数和之前的函数的区别在于，被检测的位置 (x, y) 必须在被检测的obj的实例的碰撞盒范围内才会判定为碰撞，也就是说，与执行函数的实例本身的碰撞盒一点关系都没有。返回值依然是实例 id 或者 noone，参数 obj 同样可以填 all。

  对于参数 prec 和 notme，一般而言分别设置为 1 即可，几乎不会用到别的值。不想了解其中的内涵的话，可以直接跳到下一个函数了。但是如果你无论如何也想了解 prec 和 notme 这两个参数是什么意思，那就继续往下看。

  首先，prec 指的是 precise collision checking，即精准碰撞检测，在第二节“精灵的碰撞盒”中我们讲到了它，不记得的可以回去翻一翻。如果被检测的实例的精灵关闭了精准碰撞检测，那么 prec 这个参数填写0和1是没有任何区别的。但如果被检测的实例的精灵开启了精准碰撞检测，prec 如果填写 1，则按照精灵实际设置的碰撞盒来检测，prec 如果填写 0，则会强行无视精灵所勾选的精准碰撞检测，而是把[碰撞盒]({{ site.baseurl }}{% link _tutorials/collision/collision_box.md %}#精灵的碰撞盒)中说过的最小矩形当做精灵的碰撞盒来检测。

  然后，notme 就是 not me，非我。若 notme 填写 0，且参数 obj 填写的是 all 或者实例自己的对象名，那么这个函数会把实例自己也作为检测对象，如果被检测位置 (x, y) 在实例自己的碰撞盒范围内，那么函数会返回实例自身的 id。notme 填写 1 时，就不会把自身作为碰撞检测目标了，与实例同一个对象的其他实例则还是会被检测到。

* `collision_rectangle(x1, y1, x2, y2, obj, prec, notme)` 与上一个函数相同，执行函数的实例本身的碰撞盒并不会参与碰撞判定，但是取而代之的是，这个函数会以 (x1, y1) 和 (x2, y2) 作为对角线生成一个矩形，当被检测的 obj 的实例的碰撞盒与这个矩形重叠时，函数就会返回这个实例的 id。
* `collision_circle(xc, yc, radius, obj, prec, notme)` 这个函数是以 (xc, yc) 作为圆心，以 radius 作为半径生成一个圆，然后判断被检测的 obj 的实例的碰撞盒是否与这个圆重叠。
* `collision_ellipse(x1, y1, x2, y2, obj, prec, notme)` 这个函数是以 (x1, y1) 和 (x2, y2) 作为对角生成一个椭圆来判断碰撞。

  注意，生成椭圆的方式如下图所示，只能生成正椭圆，不能生成斜椭圆。

  ![Ellipse](/assets/images/collision/ellipse.png)

* `collision_line(x1, y1, x2, y2, obj, prec, notme)` 这个函数是检测连接 (x1, y1) 和 (x2, y2) 的线段是否经过了被检测的 obj 的实例的碰撞盒。通常用来判断游戏中敌人能否看到玩家角色。
