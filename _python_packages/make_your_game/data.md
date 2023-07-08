---
layout: post
title: 数据
nav_order: 3
parent: Make Your Game!
---

## 杀死玩家，记录死亡数

首先，我们要有一个能稳定记录死亡数的办法，所以要么保存存在 global 里，要么保存在 world 里。这里讲解保存在 world 里的方法，毕竟 world 本来就是全局控制的实例嘛。所以我们先在 world 的 create 事件里初始化一个死亡数变量：

![Init Death](/assets/images/make_your_game/init_death.png)

然后，新建一个对象叫做 **killerParent**。至于为什么叫 "Parent"，这就是这一节的重头戏。随便给它一个精灵。是的，随便给，给什么精灵都无所谓，不影响的。

![Kill Parent](/assets/images/make_your_game/kill_parent.png)

打开 objPlayer。给它的 step 事件添加新的代码。

由于我们这次添加的代码和之前写在 step 里的代码作用不同，所以建议用一个新的代码框来写。但凡是写在同一个事件但是作用不相同的代码，都建议分开不同的代码框来写。

![New Code Editor](/assets/images/make_your_game/new_code_editor.png)

在新的代码框里，我们写这样一段代码：

```c
if (place_meeting(x, y, killerParent))
{
    // 播放死亡音效，如果没有，请删除这句。
    sound_play(sndDeath);
    // 用来控制死亡效果的对象。
    // view_xview + view_wview / 2和view_yview + view_hview / 2是确保在游戏窗口的正中间创建对象，如果不需要可以改成别的坐标。
    instance_create(view_xview + view_wview / 2, view_yview + view_hview / 2, objGameOver);
    // 确保如果屏幕里有多个 objPlayer，也都会被销毁。如果不需要这个效果，直接改成 instance_destroy(); 即可。
    with (objPlayer) instance_destroy();
    // 增加死亡数。
    world.death += 1;
    // 保存死亡数及时间。
    saveDeathTime();
}
```

在这里用到了未定义的脚本 `saveDeathTime`，所以GM会报错。不过不要急，我们很快就会讲**存读档**。

然后新建一个对象 **objGameOver**，深度调到 -9999999。如果不叫这个名字，上面的代码中第七行也要修改掉。

这个 objGameOver 是用来实现死亡效果的。当然，现在咱还没讲到那些高级的特效函数，所以基本上也做不了什么高端特效，最普通的效果就是给 objGameOver 配一张好看的精灵了：

![Game Over](/assets/images/make_your_game/game_over.png)

接着回到 world，创建一个按下R键事件（随便什么键都行）用来 restart：

```c
// 停止播放死亡音效。如果没有请删除。
sound_stop(sndDeath);
// 读取存档
loadGame();
```

这里同样用到了未定义的脚本 `loadGame`，GM也会在这里报错。

房间中，能杀死角色的实例可能是多种多样的，但是它们的形状也可能是各种各样的，所以并不能效仿 objBlock 一样使用贴图来解决这一问题。这次我们只能给每一种能杀死角色的东西都新建一个对象了。

但是问题又来了。我们判断角色死亡，用的是 `if (place_meeting(x, y, killerParent))`，如果创建多个对象的话，又要面临 `if (place_meeting(x, y, objBullet) || place_meeting(x, y, objSpike) || place_meeting(x, y, objThunder)...)` 的窘境了。要知道，GM 只有固体和非固体两种实例，固体属性已经被我们拿去做地面和墙壁了，我们总不能把所有非固体都作为 killer 吧？

这时候，另一个在[浅谈对象]({{ site.baseurl }}{% link _tutorials/start/object.md %})中被我们跳过的属性站了出来，他就是**父对**（Parent）。

![Parent](/assets/images/make_your_game/parent.png)

我们随便新建一个对象（比如上图中的 objSpike），然后给他的父对选上 killerParent：

![Set Parent](/assets/images/make_your_game/set_parent.png)

把它放到房间里面，运行游戏，你会惊奇的发现——

![Error](/assets/images/make_your_game/error.png)

**报错了**。这是显然的，还记得我们之前使用了未声明的脚本 `saveDeathTime` 和 `loadGame` 么？

所以我们先姑且暂时新建这两个脚本，不过里面什么都不写，空着。

![Empty Scripts](/assets/images/make_your_game/empty_scripts.png)

再次运行游戏，控制角色去触碰 objSpike，角色死亡被触发了。

![Die](/assets/images/make_your_game/die.png)

这就是设置父对的意义之一：**继承父对的被碰撞检测**。无论是使用 `place_meeting`，`instance_place` 还是 `collision_系列` 函数，都会继承碰撞检测。

至此，这个问题也被完美的解决了。只要所有能杀死角色的对象，都设置 killParent 作为父对即可。这就是为什么 killParent 设置什么精灵都无所谓的原因，因为我们不会真的用到它。

当然，[父对的意义不止于此，还有别的作用]({{ site.baseurl }}{% link _tutorials/grammar.md %}#父对)，比如子对继承父对的事件，子对响应父对的 with 等。正因如此，作为父对的对象，本身不应该有额外的代码（并不是说不能有代码），并且不应当作为实例出现在房间中。

## 记录游戏时间

有了记录死亡数的经验，记录游戏时间就简单了很多，所以我就不配图了。

首先先在 world 的 create 事件里初始化一个变量 `time = 0;`，然后在 world 的 step 变量里写入如下代码：

```c
// 你需要把一切不应该记录游戏时间的房间写在这里。
if (room != rTitle && room != rStageSelect)
{
    // 当角色死亡时不记录游戏时间，你也可以删除这句。
    if (!instance_exists(objPlayer))
    // 60 是游戏帧数，非 60 帧游戏请改动
        time += 1 / 60;
}
```

time 一次增加 `1 / fps`，刚好每一秒（60 步）增加 1。

## 标题栏

现在我们的游戏窗口的标题栏还是空的。

![Empty Caption](/assets/images/make_your_game/empty_caption.png)

这时候，我们就要用到 GM 自带的变量 `room_caption` 了。给 world 新建一个房间开始（room start）事件，在里面写到：

```c
room_caption = "你的游戏名";
```

![Hell Ball](/assets/images/make_your_game/hell_ball.png)

就可以在游戏的标题栏显示你的游戏名了：

![Caption](/assets/images/make_your_game/caption.png)

当然，你也可以在标题栏添加更多的玩意，别忘了字符串允许使用加号运算。

如果你要向标题栏添加动态数据，如，帧率，死亡数，游戏时间等，你应该把代码转移到**步事件**。具体的格式如下：

```c
room_caption = "你的游戏名";
// 注意下面开始使用+=而不是=
// 此处应该去掉不应该显示死亡数和游戏时间的房间，例如游戏封面
if (room != rTitle)
{
    // 添加死亡数
    room_caption += " --death :" + string(death);
    // 添加游戏时间
    hours = time div 3600;
    minutes = (time mod 3600) div 60;
    seconds = (time mod 3600) mod 60;
    mseconds = frac(time);
    room_caption += " --time :" + string(hours) + ":" + string(minutes) + ":" + string(seconds) + "." + string(mseconds);
}
// 添加帧数
room_caption += " --fps :" + string(fps);
```

效果如下：

![Caption With Data](/assets/images/make_your_game/caption_with_data.png)

添加别的内容也是一样的道理。
