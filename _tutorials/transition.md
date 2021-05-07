---
layout: default
title: 房间过渡
nav_order: 30
---

# 内置过渡方式

默认情况下，使用 `room_goto()` 函数切换房间时，GM8 是直接切换画面的。如果你觉得这种切换太生硬，GM8 提供房间过渡的功能。

* `transition_kind` 默认为 0 的内置变量，用于改变切换房间时的过渡效果。注意，该设置是一次性设置，每次切换房间后该变量会自动归零。
* `transition_steps` 设置房间过渡步数的内置变量，默认是 80 步，即 80 步完成过渡过程。

GM8 提供 21 种过渡方式（不计为 0 时的无过渡）：

```c
1 = 从左创造  2 = 从右创造  3 = 从上创造  4 = 从下创造  5 = 中心创造
```

以从左创造为例，其效果为：

![Example](/assets/images/transition/example1.gif)

```c
6 = 从左移动  7 = 从右移动  8 = 从上移动  9 = 从下移动
```

以从左移动为例，其效果为：

![Example](/assets/images/transition/example2.gif)

```c
10 = 从左隔行  11 = 从右隔行  12 = 从上隔行  13 = 从下隔行
```

以从左隔行为例，其效果为：

![Example](/assets/images/transition/example3.gif)

```c
14 = 从左推  15 = 从右推  16 = 从上推  17 = 从下推
```

以从左推为例，其效果为：

![Example](/assets/images/transition/example4.gif)

```c
18 = 左转动  19 = 右转动
```

以左转动为例，其效果为：

![Example](/assets/images/transition/example5.gif)

```c
20 = 混合房间
```

![Example](/assets/images/transition/example6.gif)

```c
21 = 淡入淡出
```

![Example](/assets/images/transition/example7.gif)

# 自定义过渡方式

* `transition_define(kind, name)` 注册一个新的房间过渡方式。参数 kind 是用来提供给 `transition_kind` 的值，重复定义可以覆盖掉原有效果。参数 name 是自定义过渡方式的脚本名，注意脚本名要使用双引号包起，以字符串方式传递。

我们将脚本名注册为房间过渡方式后，GM8 在使用我们的脚本时，会传递**五个参数**到脚本中，分别是**上一个房间画面的表面**，**下一个房间画面的表面**，**表面宽**，**表面高**，**过渡的进程**（0~1）。GM 所提供的 argument0 和 argument1 是分别绘制有上一个房间画面和下一个房间画面的表面的 id，我们需要利用这两个表面绘制到屏幕上。argument4 是过渡的进程，即**当前步数/总步数**，用来帮助我们绘制动态效果。GM8 会在每一步都调用一次该脚本，因此默认 `transition_steps` 为 80 的情况下，GM8 一共要调用 80 次脚本。值得注意的一点是，GM8 不会重绘 argument0 和 argument1 的表面，这意味着如果你在某一步的时候改变了某个表面内容，那么下一步读取到的表面也是被修改后的表面。因此如果你要改变表面上的内容，最好开辟自己的表面来修改。

---

为了更好地说明如何写脚本，我们就以实现内置的 14 号过渡方式从左推为例：

```c
{
    var _surf1, _surf2, _width, _height, _percent;
    _surf1 = argument0;
    _surf2 = argument1;
    _width = argument2;
    _height = argument3;
    _percent = argument4;

    draw_surface(_surf1, _percent * _width, 0);
    draw_surface(_surf2, (_percent - 1) * _width, 0);
}
```

以上代码注册为房间过渡方式后，与内置的 14 号过渡方式是一模一样的。

---

再举一个非内置的例子：

![Example](/assets/images/transition/example8.gif)

代码：

```c
{
    var _surf1, _surf2, _width, _height, _percent;
    _surf1 = argument0;
    _surf2 = argument1;
    _width = argument2;
    _height = argument3;
    _percent = argument4;

    draw_clear(c_black);
    draw_surface_ext(_surf2, 0, 0, 1, 1, 0, c_white, sqr(_percent));
    draw_surface_part(_surf1, 0, 0, _width, _height / 2, 0, -_percent * _height / 2);
    draw_surface_part(_surf1, 0, _height / 2, _width, _height / 2, 0, (1 + _percent) * _height / 2);
}
```
