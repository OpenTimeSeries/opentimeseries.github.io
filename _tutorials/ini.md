---
layout: default
title: ini
nav_order: 28
---

**ini文件**（initialization file）俗称配置文件，属于一种文本文件，可以直接使用记事本打开查看其中的内容，例如：

![INI File](/assets/images/ini/ini_file.png)

ini文件采用**键值对结构**（即`key=value`）的结构来储存数据，不过ini文件中还有**节**（section）的概念。节是指方括号`[]`所表示的内容，从一个`[section]`的声明开始，下面的键值对全部属于该节，直到遇到下一个`[section]`的声明。分节的好处在于不同节可以有重复的键名，并且阅读性也比较好。

另外，ini文件中可以使用`#`表示**注释**。

ini文件通常用来保存游戏设置，如键位设置，音量，画面设置等。

## 读写ini文件

* `ini_open(fname)` 打开指定名称的ini文件。由于GM8的缺陷，ini文件必须在gmk/exe同一目录下。该函数无返回值，一次只能打开一个ini文件，之后所有ini_系列函数均操作该文件。
* `ini_close()` 关闭已打开的ini文件。
* `ini_read_string(section, key, default)` 从指定的节section中读取键key的值（当值为字符串类型时）。如果在ini文件中找不到该键，则返回default的值。
* `ini_read_real(section, key, default)` 从指定的节section中读取键key的值（当值为实数类型时）。如果在ini文件中找不到该键，则返回default的值。
* `ini_write_string(section, key, value)` 在指定的节section中写入键值对`key=value`，value以字符串写入。
* `ini_write_real(section, key, value)` 在指定的节section中写入键值对`key=value`，value以实数写入。
* `ini_key_exists(section, key)` 返回指定的节section中是否存在键key。
* `ini_section_exists(section)` 返回指定的节section是否存在。
* `ini_key_delete(section, key)` 删除指定节section中的键key。
* `ini_section_delete(section)` 删除指定节section。

如果不喜欢将ini文件强制放在gmk/exe同目录下的话，可以使用[玉米的ini扩展脚本](https://www.magecorn.com/p/248.shtml)，其本质是使用`file_open`来读写，封装成类似ini的接口。
