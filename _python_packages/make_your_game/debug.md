---
layout: post
title: 调试
nav_order: 6
parent: Make Your Game!
---

## 调试模式

GM 为我们测试游戏提供了两种方式：

![Run Type](/assets/images/make_your_game/run_type.png)

绿色的是“运行游戏”，即以正常的方式运行游戏，最终发布之前一定要用这个方式运行一次以确保没有 bug。

红色的是“运行调试模式”。所谓**调试模式**（Debug Mode），就是让游戏在 GM 的监控下运行，你可以实时把握每一个实例的数据与动向，以方便发现并修正游戏的 bug。我们这节所讲的就是调试模式。

打开调试模式之后，应该会有这样的一个界面：

![Debug Information](/assets/images/make_your_game/debug_information.png)

我们先来看看状态栏的数据。

* `50 fps` 指的是当前游戏帧率。
* `192 ins` 指当前房间内有 192 个实例。
* `mouse id: 100248` 指的是鼠标所指向的那个实例的 id 为 100248。

现在我们来说一下最重要的三个用法，监视值，监视实例，临时执行代码。

### 监视值

监视值需要用到 Watch 下的 Add，或者直接点按钮栏的加号：

![Add](/assets/images/make_your_game/add.png)

你可以添加监视任何一个变量，要以对象名/实例名作为前缀。如：`world.death`, `(100248).x` 等，使用对象名监控变量，默认给出该对象 id 最小的那个实例的值。实例名可以通过上述的 mouse id 来获取。

同样的，你也可以监控任意有返回值的函数，如：`instance_number(obj)`（返回 obj 的实例数量）, `point_distance((100248).x, (100248).y, (100259).x, (100259).y)`, `keyboard_check(vk_up)`等。

更甚者，你可以进行任意的运算。如：`56+98`, `sin(5.6*pi)`等。

![Expressions](/assets/images/make_your_game/expressions.png)

### 监视实例

监视实例位于 Tools 下的 Show Local Variables：

![Show Local](/assets/images/make_your_game/show_local.png)

选择之后，输入你想要监控的实例的 id。也可以输入对象名，默认监视 id 最小的那个。如果你想监控特殊实例 global 的变量，请选择 Show Global Variables。

![Local Variables](/assets/images/make_your_game/local_variables.png)

监视窗口中一共有四组数据。

1. 第一组是实例的最根本属性，可以看到里面有坐标，速度，重力，阻力等值。
2. 第二组是实例的基本属性，可以看到有可见，固体，id，深度等。
3. 第三组是实例的路径属性，我们还没有学到，先不用管。
4. 第四组是实例的自定义变量，我们自己定义的变量都在这里找。

### 临时执行代码

临时执行代码位于 Tools 下的 Execute codes：

![Execute](/assets/images/make_your_game/execute.png)

你可以在游戏运行时临时让游戏执行一些什么代码，以满足调试的需求。

## debug_mode

说到调试，就不能不提 GM 自带的变量 `debug_mode`。

这个变量不可被修改，他只和游戏本身的运行方式有关。在正常运行游戏的时候，`debug_mode` 的值为 0，而在调试模式下运行游戏时，`debug_mode` 的值为 1。即：

```c
if (debug_mode)
{
    xxxx;
}
```

其中代码 xxxx，只有你在调试模式下才会执行，而生成的 exe 发布给玩家时则不会执行。换句话而言，我们可以用 `debug_mode` 开启只有我们制作者才有的特殊权限。

举个例子，我不想每次调试的时候都一关一关打，这样太浪费时间，所以我在 world 的 step 里写：

```c
if (debug_mode)
{
    if (keyboard_check_press(ord('K')))
        room_goto_next();    // 跳到下一个房间
    if (keyboard_check_press(ord('J')))
        room_goto_previous();    // 跳到上一个房间
}
```

这样就可以按 J 和 K 任意跳关。

但是这样总感觉不够，于是我又写下了下面这个代码：

```c
if (debug_mode)
{
    if (mouse_check_button_press(mb_left))
    {
        objPlayer.x = mouse_x;
        objPlayer.y = mouse_y;
    }
}
```

这样，只要我点击屏幕某个位置，角色就会被传送过去，更方便了调试。

`if (debug_mode)` 下的代码只有在调试模式下执行，所以当你要发布你的游戏时，你不需要把这些代码删掉，因为它们根本不会执行。
