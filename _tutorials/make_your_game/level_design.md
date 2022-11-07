---
layout: post
title: 关卡设计
nav_order: 2
parent: Make Your Game!
---

## 全局控制

在一个游戏中，你最好有一个对象的实例勾选了“**持续**”属性，用这个实例来进行全局控制，一般取名 **world** 或者 **controller** 等名字。

![World](/assets/images/make_your_game/world.png)

持续属性就是指这个对象的实例不会因为切换房间而被销毁，所以一旦被创建，只要不使用代码去摧毁他，就会一直存在。所以我们只需要在游戏的第一个房间里放一个它的实例就行了。

为了方便叙述，以后一律用 **world** 来表示这个对象。

现在我们来列举一下哪些属于全局控制。

1. 除了控制角色基础运动的键盘操作。例如之前提到的按 R 键 restart，按 backspace 键回到选关页，按 P 键暂停等等。由于这些键盘操作，即使在角色死亡（即角色的实例被销毁）的情况下也有效，所以不能放在角色的对象中。
2. 计时、记录死亡数等。由于 world 不会被销毁，所以可以保证数据的准确性。
3. 初始化游戏变量。尤其是 globalvar 式的全局变量，应在 world 的 create 事件中声明并初始化。
4. 其他的一些暂时没想到的东西。

## 第一个房间

游戏的第一个房间通常是游戏的封面，个人习惯命名为 rTitle。游戏封面的设计就只能靠个人天赋了，我也教不了。

**world 应该在 rTitle 房间放置一个实例。**

其次，rTitle 房间要有**开始游戏**、**继续游戏**、**退出游戏**等选项，最简单的实现方法是制作等量的对象，用鼠标左键事件来判断玩家选了哪个选项。开始游戏的对象的按下鼠标左键事件中，使用 `room_goto(numb);`（切换到名为 numb 的房间）来进入到第一个关卡。继续游戏的对象的鼠标左键事件中，应当有读档的代码，如何存读档马上就会讲，不要着急。退出游戏的对象的鼠标左键事件中，使用 `game_end();` 来退出游戏。

## 传送门

我们做游戏的时候，一般都以一个房间作为一个关卡。那么我们应该做一个传送门对象，用来在不同的关卡（房间）之间跳动。

首先，先确定是否开启了将未初始化的变量初始化为0：

![Global Game Settings](/assets/images/make_your_game/global_game_settings.png)

![Variable Init Zero](/assets/images/make_your_game/variable_init_zero.png)

新建一个 objWarp，给他一个碰撞玩家角色的事件：

![Warp](/assets/images/make_your_game/warp.png)

在里面写上：

```c
if (go)
    room_goto(go);
```

我们在每一个关卡的终点处，摆上一个 objWarp 的实例，然后在实例上按下 ctrl + 鼠标右键，并选择**创建时执行代码**（Creation Code，以后一律简称为 **CC**），如图：

![CC](/assets/images/make_your_game/cc.png)

在 CC 里，填写 `go = 下一个关卡房间名;`，如图所示：

![CC Code](/assets/images/make_your_game/cc_code.png)

同样的，想回到上一关就填写上一关的房间名。这样，当角色触碰到传送门时，就会跳到对应的关卡。

一个房间可以放很多个 objWarp 的实例，每个传送门通往不一样的关卡。

## 选关页

一般而言，一个游戏应该有一个选关页，当然也可以不需要。

最简单的选关页就是通过一个有很多传送门的房间来实现：

![Level Select](/assets/images/make_your_game/level_select.png)

每一个传送门都通往不同的关卡。

接下来我们要让玩家按下 backspace 键回到选关页（假设房间名为 `rStageSelect`）。

打开 `world`，给 world 添加按下 backspace 键事件：

![Backspace Event](/assets/images/make_your_game/backspace_event.png)

给其添加代码：

```c
// room != rTitle是判断现在所在的房间是不是游戏封面。rTitle的名字应根据实际情况修改。
if (room != rTitle)
        room_goto(rStageSelect);
```

## 砖块与贴图

现在，我们要让我们的地图变得花哨一点，比如下面这样：

![Tiles](/assets/images/make_your_game/tiles.png)

如果你想给每一种不同图像的砖块都创建一个 object 的话，那你可不得累死。（当然实际是可以的，只要全部勾选固体属性就行。）

所以，我推荐各位使用**贴图**。怎么使用呢？

首先，先给砖块一个半透明的精灵，比如下面这个：

![Block](/assets/images/make_your_game/block.png)

然后给砖块**取消勾选可见**。

![Invisible](/assets/images/make_your_game/invisible.png)

我们很久以前说过，不可见仅仅只是代表不画出它的图像，但是依然会进行碰撞检测。

然后把砖块会用到的图像存进**背景图片**中。如果是个大张的记得勾选**作为贴图使用**。

![As Tiles](/assets/images/make_your_game/as_tiles.png)

在房间内，用 objBlock 摆好关卡：

![Block Level](/assets/images/make_your_game/block_level.png)

把贴图贴上去。现在它看起来应该是这样的：

![Tile Level](/assets/images/make_your_game/tile_level.png)

运行游戏，由于 objBlock 勾选不可见，所以它的半透明精灵不会被看到。

这样做的好处不仅是方便你不用创建大量对象，而且在复杂的游戏中易于维护。比如有什么地方必须要判定 `if (xxxx(objBlock))` 的话，如果大量创建不同的砖块对象，就得不停地加入 `if (xxxx(objBlock01) || xxxx(objBlock02) || xxxx(objBlock03)....)`。

## 简单的音乐播放

现在，我们要给每一个房间配上一个背景音乐。由于GM8的音乐系统非常的烂，所以我在[后续的章节]({{ site.baseurl }}{% link _tutorials/music.md %})介绍了两个插件：**SuperSound** 和 **MaizeMusic**，如果决定使用这两个插件，可以跳过这一节。

*注意，GM 对音乐格式兼容性很差。如果无法播放音乐，可以试着用 GoldWave 转换成 mp3 或 wav 格式。*

* `sound_play(index)` 指定的声音播放一次。如果声音是背景音乐，当前背景音乐停止播放。
* `sound_loop(index)` 播放指定的声音，不断循环。如果声音是背景音乐，当前背景音乐停止播放。

那么GM如何判断一个音乐到底是音效还是背景音乐呢？

![Sound Type](/assets/images/make_your_game/sound_type.png)

“一般音效”和“3D 音效”被视为音效，即播放音效不会导致其他音效停止播放。“背景 mid 音乐”和“使用媒体播放器”被视为背景音乐，播放背景音乐会打断原有的背景音乐。就我个人而言，我一般给音效勾选“一般音效”，背景音乐勾选“使用媒体播放器”。

现在我们新建一个对象 **objMusic** 来进行音乐播放。首先给它一个音符的精灵以便于识别，然后取消勾选可见（不能给玩家看到）。在它的 step 事件中写上：

```c
if (!sound_isplaying(music))
    sound_loop(music);
```

之后，把它在每一个房间里都放置一个实例，并且给每一个实例的 CC 定义变量 music：

![Music Play](/assets/images/make_your_game/music_play.png)

简背景音乐设置完毕。如果要实现高端的音乐效果，建议使用外接插件而不是GM自带的音乐函数。
