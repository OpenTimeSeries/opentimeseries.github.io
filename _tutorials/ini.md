---
layout: default
title: ini
nav_order: 28
---

**ini 文件**（initialization file）俗称配置文件，属于一种文本文件，可以直接使用记事本打开查看其中的内容，例如：

![INI File](/assets/images/ini/ini_file.png)

ini文件采用**键值对结构**（即`key=value`）的结构来储存数据，不过 ini 文件中还有**节**（section）的概念。节是指方括号 `[]` 所表示的内容，从一个 `[section]` 的声明开始，下面的键值对全部属于该节，直到遇到下一个 `[section]` 的声明。分节的好处在于不同节可以有重复的键名，并且阅读性也比较好。

另外，ini 文件中可以使用 `#` 表示**注释**。

ini 文件通常用来保存游戏设置，如键位设置，音量，画面设置等。

### 读写 ini 文件

* `ini_open(fname)` 打开指定名称的 ini 文件。由于 GM8 的缺陷，ini 文件必须在 gmk/exe 同一目录下。该函数无返回值，一次只能打开一个 ini 文件，之后所有 ini_系列函数均操作该文件。
* `ini_close()` 关闭已打开的 ini 文件。
* `ini_read_string(section, key, default)` 从指定的节 section 中读取键 key 的值（当值为字符串类型时）。如果在 ini 文件中找不到该键，则返回 default 的值。
* `ini_read_real(section, key, default)` 从指定的节 section 中读取键 key 的值（当值为实数类型时）。如果在 ini 文件中找不到该键，则返回 default 的值。
* `ini_write_string(section, key, value)` 在指定的节 section 中写入键值对 `key=value`，value 以字符串写入。
* `ini_write_real(section, key, value)` 在指定的节 section 中写入键值对 `key=value`，value 以实数写入。
* `ini_key_exists(section, key)` 返回指定的节 section 中是否存在键 key。
* `ini_section_exists(section)` 返回指定的节 section 是否存在。
* `ini_key_delete(section, key)` 删除指定节 section 中的键 key。
* `ini_section_delete(section)` 删除指定节 section。

如果不喜欢将 ini 文件强制放在 gmk/exe 同目录下的话，可以使用[玉米的 ini 扩展脚本](https://www.magecorn.com/p/248.shtml)，其本质是使用 `file_open` 来读写，封装成类似 ini 的接口。
