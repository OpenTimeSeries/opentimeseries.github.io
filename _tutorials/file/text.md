---
layout: default
title: 文本文件流
nav_order: 2
parent: 文件流
---

### 打开文件

* `file_text_open_read(file)` 以文本文件输入流打开一个文件。参数 file 为文件完整路径，返回该文件流的 id。
* `file_text_open_write(file)` 以文本文件输出流打开一个文件。参数 file 为完整路径，如果不存在则会被创建，如果存在，则会先清空原文件的内容。返回该文件流的 id。
* `file_text_open_append(file)` 以文本文件输出流打开一个文件。参数 file 为完整路径，如果不存在则会被创建，与上面的函数不同的是，如果存在文件，则会把数据接在原文件数据的后面，而不是清空原文件。返回该文件流的 id。

### 关闭文件

* `file_text_close(file id)` 关闭索引为 file id 的文本文件流。

### 写入文件

* `file_text_write_string(file id, str)` 将字符串 str 写入到索引为 file id 的文本文件流中。
* `file_text_write_real(file id, val)` 将一个实数写入到索引为 file id 的文本文件流中。注意，与二进制文件流不同的是，文本文件流将实数转换为 ASCII 码的形式储存，比如，实数 255 在二进制流中只占一个字节，但是在文本文件流中会被转化为 "255" 字符串来储存，每个字符占一个字节，所以一共占四个字节（还有一个多出来的字节是 ASCII 码为 20 的字符，这个字符不会被显示，GM8 用它来隔断不同的实数）。
* `file_text_writeln(file id)` 向文件索引写入一个换行符。

这里我不得不骂一句 Overmars 萨比，因为 GM8 在写入字符串的时候**并不会写入任何分割符**。也就是说，如果你写入三个字符串，在读取的时候却会被当做一整个字符串读取出来。因此，这就迫使 GMer 在写入字符串的时候，**每写一个字符串都要写一个换行符才行**。你以为这就结束了？Too young！你在读取字符串的时候，GM8 确实会以换行符作为分界线，但是，**它不会自动跳行**，也就是说，**你读完一个字符串之后，还要手动调用函数跳过换行符**。意不意外？惊不惊喜？另外还有一点，读取字符串并不会因为遇到了数字字符，或者 ASCII 码为 20 的字符而停止，因此，你甚至有可能会把写入的实数附在字符串里给一并读取出来。

但是，不管 Overmars 多么的萨比，我们机智的 GMer 总有办法可以拯救一波。

### 读取文件

* `file_text_read_string(file id)` 从索引为 file id 的文本文件流中读取一个字符串。字符串以换行符作为结束标志。
* `file_text_read_real(file id)` 从索引为 file id 的文本文件流中读取一个实数。一个实数是指一串连续的字符，且均为 `0`~`9`，`.`，`-` 中的某一个。当遇到这些字符以外的字符时，GM 会认为属于这个实数的字符结束了。
* `file_text_readln(file id)` 跳过一行字符串。正如前文所述，你在读取完一行字符串之后，不得不手动跳行来读取下一行的字符串。

### 判断文件结束

* `file_text_eof(file id)` 判断索引为 file id 的文本文件流是否已经结束。

### 数据结构 + 文本文件流

GM8 的文本文件流可以说是差到令人失望，标准的文本文件流应当是逐字符处理，而不是逐字符串处理，再加上 GM8 并不是按照传统的以 ASCII 码为 0 的字符作为字符串的结束，而是以 ASCII 码为 10 的换行符，这就导致 GM8 的文本文件流几乎无法和其他语言的文本文件流交互，你用其他语言写的文本文件 GM8 读不来，你用 GM8 写的文本文件其他语言也读不来。

但是我这并不是在说二进制文件流比文本文件流好，事实上，只要没有跳过二进制文件流一节的人都能看出来二进制文件流的操作十分不便，典型的牺牲代码换取效率。

因此，这一节就是我们要讲的重点，如何活用文本文件流来储存数据。

不知道还有多少人还记得我们在介绍[存档读档]({{ site.baseurl }}{% link _tutorials/make_your_game/save_load.md %})时说过不需要搞懂原理，只要会用就行。而现在，就到了搞懂它的原理的时候了。

为了方便阅读，我将当时写的 `saveGame()` 脚本与 `loadGame()` 脚本全部搬过来：

```c
// saveGame();
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

```c
// loadGame();
{
    var _file, _map, _room;
    _file = file_text_open_read(working_directory + "\save.dat");
    _map = ds_map_create();
    ds_map_read(_map, file_text_read_string(_file));

    _room = ds_map_find_value(_map, "room");
    world.death = ds_map_find_value(_map, "death");
    world.time = ds_map_find_value(_map, "time");
    world.score= ds_map_find_value(_map, "score");

    room_goto(_room);
    ds_map_destroy(_map);
    file_text_close(_file);
}
```

只要没有跳过[数据结构]({{ site.baseurl }}{% link _tutorials/data_structure/map.md %})，应该就能很轻松的看出这两个脚本的原理：

* saveGame:
  1. 以文本文件流打开一个文件
  2. 创建一个数据结构
  3. 将数据写入数据结构
  4. 将数据结构转换为字符串
  5. 将字符串写入文件中
  6. 销毁数据结构
  7. 关闭文件
* loadGame:
  1. 以文本文件流打开一个文件
  2. 创建一个数据结构
  3. 从文本文件流中读取出字符串
  4. 从字符串中读取数据结构
  5. 从数据结构中读取数据
  6. 销毁数据结构
  7. 关闭文件

这就是GM8文本文件流的真正用法。

使用数据结构的好处有两点，第一，**同一个数据结构能同时储存字符串和实数**，第二，**一个数据结构只转换为一个字符串，因此不需要考虑换行符的问题**。当然，使用数据结构也有一个缺点，那就是**文件大小很大**，因为数据结构转换为字符串后，要保证读取出来还是同一个数据结构，因此会添加许多格式控制符，甚至比数据结构本身的数据内存还大。

这里偷偷的再说一下，GM8 数据结构用 **ASCII 码的 ASCII 码**来储存字符串，假设一个字符串 `"fuck"`，储存进数据结构，会先转换为 ASCII 码 `66 75 63 6B`（此处以十六进制代表，每两位为一个字节），然后再把 `"6675636B"` 当成字符串转换为 ASCII 码 `36 36 37 35 36 33 36 42`（十六进制）来储存。因此，储存四个字符的 `"fuck"`，硬生生的占用了八个字节。再加上一些格式控制符，用 GM8 的数据结构向文件中只写入一个 `"fuck"`，文件大小足足有 56 个字节。以此**牺牲文件大小来换取便利**。

另外，不同的数据结构储存相同的数据转换为字符串的大小也是不一样的，上面的 `"fuck"` 例子中使用的是 list。
