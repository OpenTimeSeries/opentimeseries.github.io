---
layout: default
title: 存档与读档
nav_order: 5
parent: Make Your Game!
---

本节无需理解，只要照着做就行了。

存档与读档，不可避免地要使用到[数据结构]({{ site.baseurl }}{% link _tutorials/data_structure/data_structure.md %})，而数据结构，即使是学 C++ 的人都感觉头疼不已。GM 提供的数据结构有栈（stack），队列（queue），列表（list），配对（map），优先队列（priority）和栈格（grid）六种，无需记忆，只要了解一下就行。

本节我们通过[配对（map）]({{ site.baseurl }}{% link _tutorials/data_structure/map.md %})来实现存读档，但并不是只有配对才能存读档。

首先，我们创建 **saveGame**，**loadGame** 和 **saveDeathTime** 三个脚本。为什么要独立创建一个 saveDeathTime？因为，在横版类 STG 类音乐弹幕类等游戏中，在游戏角色死亡后，需要立即储存死亡数和游戏时间，不然玩家就可以退出游戏重开，以此刷低死亡数和游戏时间。但是这时候 player 已经死亡，一般的存档又要同时储存 objPlayer 的 x 和 y 坐标，这就冲突了。

当然这也是根据实际情况而定的，saveDeathTime 只是给出一个例子，告诉你如何只储存一部分数据而不影响其他数据。

写脚本之前，我们要确定一下存档文件的名字及它的路径，在本节中，统一以 **save.dat** 作为文件名进行教程。如果是储存在和游戏本体 exe 相同的路径，那么它的路径就是：

```c
working_directory + "\save.dat"
```

`working_directory` 会自动获取游戏本体 exe 所在的路径。

如果你想让游戏资源有层次，如下图所示，在游戏本体目录下新建一个 Data 文件夹，把存档文件放在里面：

![Data Folder](/assets/images/make_your_game/data_folder.png)

那么路径就是：

```c
working_directory + "\Data\save.dat"
```

以此类推。

请记住你的路径名，本节中一律使用 `working_directory + "\save.dat"` 来讲解，你应当把代码中所有这个路径改成自己的路径。

# saveGame

现在，打开你的 saveGame，写上：

```c
{
    var _file, _map;
    _file = file_text_open_write(working_directory + "\save.dat");
    _map = ds_map_create();

    ds_map_add(_map, "room", room);
    ds_map_add(_map, "death", world.death);
    ds_map_add(_map, "time", world.time);
    ds_map_add(_map, "score", world.score);

    file_text_write_string(_file, ds_map_write(_map));
    ds_map_destroy(_map);
    file_text_close(_file);
}
```

*注意，这只是一个模板，请勿盲目地复制粘贴*。我刻意把代码分成了三个部分，第一部分和第三部分是不需要理解的，照搬就行。我们只需要搞懂第二部分。

第二部分就是我们所需要修改的地方了，这个部分所用到的只有一个函数：`ds_map_add(id, key, value)`，这个函数需要三个参数，其中 **id 填 _map** 就行，无需改动。**value 填所需要储存的数据**，上述例子中用了四个数据作了示范，实际使用请根据自身需求。而**参数 key，可以理解为是一种记号**，比如，我给 `world.death` 标注一个记号 "death"，那么我在存档文件中寻找 "death" 这个记号时，存档文件就会把储存的 `world.death` 的值输出给我，所以，**绝对不能出现相同的记号**（即 key）。但是，记号用啥是随意的，你想用啥就用啥，你可以用 "a" 对应 `room`，"b" 对应 `world.death` 等，只要不重复就没问题。但是，从使用的角度来看，还是建议按对应关系来标记。

# loadGame

接下来打开我们的 loadGame。

但是在写入代码之前，我们有个问题要处理一下。这个问题仅出现在横版类游戏和 RPG 中，做其他类型的游戏大概并不需要要考虑。

这个问题就是如何在读取房间并切换房间的同时，读取 `objPlayer.x` 和 `objPlayer.y` 并赋值给 objPlayer 呢？做横版游戏和 RPG 的时候，如果存档是在上一个房间中，那么在这个房间死亡，读档就应该返回上一个房间，并且还要读取存档的 objPlayer 的坐标。仔细思考一下，虽然我们存档可以直接 `ds_map_add(map, "room", room);` 来存档，但是读档不能直接给 `room` 赋值啊，`room` 是一个不可改变的 GM 自带变量！我们只能先用变量来储存存档中的房间，然后使用函数 `room_goto(xxx);` 来切换房间。但是，有一个很大的问题，在 GM8 的机制中，`room_goto()` 被调用的时，并不是立即生效的，而是要等当前的代码段全都执行完毕才会生效。也就是说，即使你先 `room_goto(xxx)`，再从存档中读出数据赋值给 `objPlayer.x` 和 `objPlayer.y`，也只是赋值给了房间切换前的 objPlayer，新的房间里的 objPlayer 并没有收到指令，所以还是出现在最初的位置，而不是存档所保存的位置。

现在有这么几种解决方法：

## 规避问题

即，让每一个房间只有一个存档，并且存档就在 objPlayer 的初始位置。这样就没必要去储存 objPlayer 的坐标，只需要储存 room 就行了，因而避开了这个问题。这可能是最简单粗暴的解决方案了。

如果你做的游戏和上述问题无关，或者你打算采用规避问题的方法来解决，那么就使用下面这个 loadGame 的模板：

```c
{
    var _file, _map, _room;
    _file = file_text_open_read(working_directory + "\save.dat");
    _map = ds_map_create();
    ds_map_read(_map, file_text_read_string(_file));

    _room = ds_map_find_value(_map, "room");
    world.death = ds_map_find_value(_map, "death");
    world.time = ds_map_find_value(_map, "time");
    world.score= ds_map_find_value(_map, "score");

    // 此处的 room_goto(_room); 根据需求保留，如果你并不需要储存 room，就不需要 room_goto，同样的，var 后面也要删掉 _room。
    room_goto(_room);
    ds_map_destroy(_map);
    file_text_close(_file);
}
```

同样的，第一部分和第三部分，除了 `room_goto` 根据实际情况决定是否保留外，其余部分照搬即可。

在第二部分，我们使用了函数 `ds_map_find_value(id, key)`，同样的，**参数 id 只需要填 _map** 就行。而**参数 key，则是和 saveGame 互相对应**。也就是说，saveGame 的格式是：`ds_map_add(_map, 标记, 变量名);`，那么在 loadGame 的格式则是：`变量名 = ds_map_find_value(_map, 标记);`。例如 saveGame 中写 `ds_map_add(_map, "death", world.death);`，那么 loadGame 中写 `world.death = ds_map_find_value(_map, "death");`。值得注意的是，由于 `room` 是不可改变的自带变量，所以我们只能用一个其他变量来接受数据，比如例子中的 `_room`，然后用 `room_goto(_room);` 切换房间。

## world 跨房间传递数据

首先在 **world** 的 create 事件中初始化两个变量，本节中假设为 `loadx` 和 `loady`，然后初始化为 0（因为 objPlayer 一般不可能出现在 (0, 0) 位置）。在脚本 loadGame 中，用 `world.loadx` 和 `world.loady` 来分别接收存档中 objPlayer 的 x 和 y。

然后在 objPlayer 的 create 事件里加上这些代码：

```c
if (world.loadx || world.loady)
{
    x = world.loadx;
    y = world.loady;
    world.loadx = 0;
    world.loady = 0;
}
```

## player 临时持续法

方法和之前所讲的 room 持续大同小异，让 player 仅在读档的时候持续，读完档便不再持续。

读档的代码要改成：

```c
...省略其他部分
with (objPlayer) instance_destroy();
with (instance_create(0, 0, objPlayer))
{
    persistent = 1;
    // key参数根据实际情况修改
    x = ds_map_find_value(_map, "x");
    y = ds_map_find_value(_map, "y");
}
...省略其他部分
```

objPlayer 的 create 事件添加（如果 alarm 0 事件已被占用，换成其他 alarm 事件）：

```c
if (instance_number(object_index) > 1)
    instance_destroy();
alarm[0] = 1;
```

然后在 alarm 0 事件里写上：

```c
persistent = 0;
```

即可。

方法还有很多，考虑到本节字数关系，就讲这三种。

# saveDeathTime

最后，我们看到我们的 saveDeathTime 脚本。这个脚本的目的是学会如何**部分存档**，并不是一定要单独储存 death 和 time，根据实际情况决定。

下面是部分存档的模板：

```c
{
    var _file, _map, _room;
    _file = file_text_open_read(working_directory + "\save.dat");
    _map = ds_map_create();
    ds_map_read(_map, file_text_read_string(_file));

    ds_map_replace(_map, "death", world.death);
    ds_map_replace(_map, "time", world.time);

    file_text_close(_file);
    _file = file_text_open_write(working_directory + "\save.dat");
    file_text_write_string(_file, ds_map_write(_map));
    ds_map_destroy(_map);
    file_text_close(_file);
}
```

这里用到了函数 `ds_map_replace(id, key, value)`，参数和 ds_map_add 是一样的，只要 key 和 value 的对应关系保持和 saveGame 一致就行。

由于存档会重写存档文件，因此为了确保其他数据不会丢失，要做很多额外的工作。如果是**部分读档**的话，那就十分简单了，因为它不会改变存档文件的内容，所以不用考虑其他的数据，和 loadGame 一样的脚本格式读取其中部分数据就行了。
