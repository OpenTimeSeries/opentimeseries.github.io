---
layout: default
title: 路径与运动
nav_order: 14
---

本章内容位于 GML 汉化文档 21-26

## 运动函数

在[运动初步]({{ site.baseurl }}{% link _tutorials/move.md %}#最基本的运动函数)中，我们介绍了最基本的运动函数 `move_towards_point(x, y, speed)`，现在我们将学习与它共处于 GML 汉化文档 21-22 页的其他运动函数。（只选取重要的以及难理解的讲解，并不是全讲）

* `motion_set(dir, speed)` 设置运动。这个函数作用不大，`motion_set(a, b);` 即等效于：`direction = a; speed = b;`。
* `motion_add(dir, speed)` 根据矢量叠加速度。

  如果没有学习过矢量可能会不懂，假设物体原速度为 spd1，原方向为 dir1，则执行 `motion_add(dir2, spd2);` 得到的物体运动速度 spd3 和 dir3 如下图所示：

  ![Vector Speed](/assets/images/path_move/vector_speed.jpg)

* `move_wrap(hor,vert,margin)` 离开房间到另一边时卷动实例。参数 hor 为是否水平卷动（1 或 0），参数 vert 为是否垂直卷动（1 或 0）。参数 margin 为卷动前离原点多远时实例必须离开房间。等于围绕房间的一圈留白。这个函数在离开事件（outside event）中使用非常具有代表性。

  什么叫卷动？就是像诺基亚上的贪吃蛇那样，从上面穿墙，会从下面出来，从左边穿墙，会从右边出来。

  如果还是不懂，就来看一下效果图：

  ![Wrap](/assets/images/path_move/wrap.gif)

  接下来说明一下参数 margin，这个参数填写 0 的时候，只要实例的坐标 (x, y) 超出了屏幕的边界，就会自动传送到对面。但是当坐标超出屏幕边界时，实例本身的精灵一般来讲还有一半仍在房间里，卷动时就会有一种不和谐的感觉。这时候就要调大 margin 的值，margin 的作用是，当实例离开房间后，还要再超出相当于 margin 的值的像素，才会发生卷动，并且传送到对面时，也是传送到屏幕外 margin 个像素的位置。

* `move_bounce_solid(adv)` 遇到固体实例反弹。这并不是一个设置属性的函数，写在 create 事件是无效的，必须写在 step 事件或者碰撞事件中。adv 是 advanced 的缩写，值为 1 或 0，意思是是否开启高级反弹。普通反弹只考虑水平面和垂直面，而高级反弹会考虑斜面的反弹（注意：在只有水平面和垂直面的情况下，普通反弹和高级反弹是完全一样的！）。效果如下，上面是普通反弹，下面是高级反弹：

  ![Bounce](/assets/images/path_move/bounce.gif)

* `move_bounce_all(adv)` 遇到所有的实例都反弹。
* `move_contact_solid(dir, maxdist)` 这是我们在[碰撞]({{ site.baseurl }}{% link _tutorials/collision/use_step.md %}#最基本的运动函数)中提到过的函数。它的含义是，令实例以最大速度不超过 maxdist 向方向 dir 运动，直到接触到固体为止。如果实例和另一固体实例之间的距离小于实例的速度，则 `move_cantact_solid` 函数会令二者紧紧地贴在一起，既不重叠也没有任何空隙。这就是为什么我们在第十二章中使用这个函数的原因了。
* `move_contact_all(dir, maxdist)` 与上一个函数类似，这个函数是遇到任何实例都会停止。
* `move_outside_solid(dir, maxdist)` 与 `move_contact_solid` 相反，这个函数是向方向 dir 运动直到离开固体实例为止。如果最开始执行这个函数的时候实例就不与任何固体实例重叠，则实例不会运动。根据官方文档的建议，一般用于分离重叠的实例。
* `move_outside_all(dir, maxdist)` 与上一个函数类似，这个函数是离开任何实例都会停止。

## 路径

**路径**（Paths）是 GM 的一种游戏资源，保存在 Paths 文件夹下。

![Path](/assets/images/path_move/path.png)

由于路径的特殊性，很难给定一种标准的命名法，简单的路径一般使用方向加距离（格子数），如上图中的 pathDown16，复杂路径一般根据实际用途或作用对象来命名。

![Path Properties](/assets/images/path_move/path_properties.png)

在上面点点，就能生成一条路径。当我们把路径附加到实例身上时，实例就会按照这条路径的轨迹来运动。

现在先来解释一下左上角框内每一个点都有的 **sp** 属性。这个 sp 指的是 speed，指实例在经过路径的这个点时，速度将会变为多少。注意！这个 sp 所指的速度是**相对速度**，并非绝对速度。sp 的默认值为 100，表示“原速度”。举个例子，如果某个点 sp 设置为 200，当实例以速度为 5 在路径上运动时，经过这个点后，速度就会变成：5 * 200 / 100 = 10，而不是真的变成 200。

**连接模式**有直线和平滑曲线两种，**精度**指的是平滑曲线的平滑度，取值范围为 1~8，可以自己试着调整一下看看效果。**封闭**指的是路径首尾是否连接。

在右上角，你可以选择一个参考房间：

![Reference Room](/assets/images/path_move/reference_room.png)

参考房间的作用是让你更好制作路径，但是注意，在参考房间中绘制路径，并不会对被参考的房间造成任何影响。

![Example](/assets/images/path_move/example.png)

## 路径函数与变量

* `path_start(path, speed, endaction, absolute)` 为当前实例开始一段路径。参数 path 是你想开始的路径名。参数 speed 是跟随路径的速度。负的 speed 意味着实例沿着路径往回移动。参数 edaction 是设定当实例到达路径的终点时发生的事件。有以下几个值可供使用:

  * 0: 停止路径；
  * 1: 从开始点继续（如果路径没有闭合，直接跳到开始点）；
  * 2: 从当前点继续；
  * 3: 反转路径，改变速度的符号。

  参数 absolute 应该是 true 或是 false（1 或 0）。设为 true 时和路径是绝对的关系（absolute）。设为 false 时路径和实例的当前位置是相关的关系（relative）为了更精确地设定，如果 speed 是正的，当前位置就是路径的开始点，路径沿着当前位置而行。 speed 为负值时，当前位置就是路径的终点，路径沿着当前位置往后移动。

  要注意的几点是，首先 `path_start` 是应当只执行一次的函数，这意味着它应该写在 create 事件或 alarm 事件或在 with 结构中被使用，而不应该在 step 事件这类每一步都会执行一次的事件中出现。其次，endaction 是 "end action"，即“结束的行为”，并不是一个单词。第三，关于绝对路径，如果 absolute 为 0，则实例会以自己的位置作为路径的起点运动，如果 absolute 为 1，则实例会先把自己移动到路径的起点的坐标上，再运动。

* `path_end()` 结束跟随路径。
* `path_index` 实例正在使用的路径。不可被改变，改变路径应使用 `path_start()`。
* `path_position` 实例处在路径的哪个位置。以起点为 0，终点为 1，在路径中间则按照比例输出 0~1 之间的小数。
* `path_positionprevious` 实例以前在路径的位置。和 `xprevious` 与 `yprevious` 是同样的理解。
* `path_speed` 改变或返回跟随路径的速度。
* `path_orientation` 这个变量可以让你先旋转路径，再跟随路径运动。默认值是 0，不旋转。
* `path_scale` 这个变量可以让你放大/缩小路径。
* `path_endaction` 改变或返回路径的 endaction。

## 运动设计

虽然它在 GML 的汉化文档里有这——么长：

![Move Design](/assets/images/path_move/move_design.png)

但是我并不打算去讲它。首先，官方文档我觉得已经讲得很详细了，基本上，看一遍就能知道怎么用。其次，这些函数用途也不广，所以也建议各位现在不要花时间在上面，等到需要用的时候再来看也不迟。*值得注意的一点是，汉化文档有误，checkall 为 true 应当是遇到任何实例都会停止，而不是不停止。*

这里用的最多的函数应该是 `mp_linear_step_object(x, y, stepsize, obj)` 了，还记得我们在[运动初步]({{ site.baseurl }}{% link _tutorials/move.md %}#最基本的运动函数)的时候提到，`move_towards_point(x, y, speed)` 并不会在到达 (x, y) 后停止，并且推荐使用 `mp_linear_step_object` 吗？使用 `mp_linear_step_object(x, y, speed, noone)` 就可以实现到达 (x, y) 之后自动停止了。注意！这个函数与 `move_towards_point` 不同，它必须写在 step 事件里才能持续移动。
