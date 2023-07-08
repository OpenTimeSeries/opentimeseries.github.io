---
layout: post
title: 注册表
nav_order: 29
---

## 注册表

**注册表**（registry）是 Windows 系统下的一个重要数据库。要查看注册表，我们可以借助 Windows 自带的工具**注册表编辑器**（regedit）。按下快捷键 Win + R，输入 regedit 后按回车，即可打开注册表编辑器。

![Regedit](/assets/images/registry/regedit.png)

注册表的结构包含**根**（root），**键**（key），**名称**（name），**类型**（type）和**数据**（data）。

根又叫**主键**（host key），即为最上层的五个键，注意根本身也是一种键：

* `HKEY_CLASSES_ROOT` 用于管理文件系统，主要记录文件的尾缀名对应的图标以及打开方式。
* `HKEY_CURRENT_USER` 记录当前用户的信息，如用户名，SSID，环境变量，临时文件夹目录，以及各个应用程序所写下的注册表信息。
* `HKEY_LOCAL_MACHINE` 记录计算机上所有硬件设备信息，与用户无关。
* `HKEY_USERS` 管理计算机上所有的用户，记录用户的口令和标识等。
* `HKEY_CURRENT_CONFIG` 记录当前用户的系统配置，如桌面配置，自启动程序等。

![Example](/assets/images/registry/example.png)

以上图为例，`\HKEY_CURRENT_USER\Environment` 是一个键，在这个键下有很多名称-类型-数据的三元结构对，我们暂时不去理解类型这个概念，只关注名称-数据，这么一来，注册表的键-名称-数据关系，就很类似 ini 文件中的节-键-值关系了。

### 安全的注册表读写

GM8 提供一些安全的注册表读写函数，它们只能读写键 `\HKEY_CURRENT_USER\Software\Game Maker\游戏 ID` 下的数据。你的游戏 ID 可以在**全局设定->装载处**查看：

![Game ID](/assets/images/registry/game_id.png)

提供的函数包含：

* `registry_write_string(name, data)` 写入一个名称-数据对，数据类型是字符串。
* `registry_write_real(name, data)` 写入一个名称-数据对，数据类型是实数。
* `registry_read_string(name)` 读取名称 name 对应的数据，数据类型是字符串。若不存在，则返回空字符串。
* `registry_read_real(name)` 读取名称 name 对应的数据，数据类型是实数。 若不存在，则返回 0。
* `registry_exists(name)` 返回指定名称 name 是否存在。

### 完整的注册表读写

GM8 也提供完整的注册表读写函数，但是使用这些函数要非常注意，除非你确切地知道自己在做什么，否则不要轻易的进行“写”操作。

默认情况下，GM8 的注册表读写函数工作在根 `\HKEY_CURRENT_USER`下，你可以用下面这个函数改变根：

* registry_set_root(root) 设定读取注册表的根目录，使用以下数值:
  * 0 `\HKEY_CURRENT_USER`
  * 1 `\HKEY_LOCAL_MACHINE`
  * 2 `\HKEY_CLASSES_ROOT`
  * 3 `\HKEY_USERS`

因此，我们提供的键时不包括根的部分，例如你想要读取 `\HKEY_CURRENT_USER\Environment` 键中 TEMP 的值，那么你需要提供的键为 `\Environment`。

* `registry_write_string_ext(key, name, data)` 在键 key 中写入一个名称-数据对，数据类型是字符串。如果键不存在，则创建。
* `registry_write_real_ext(key, name, data)` 在键 key 中写入一个名称-数据对，数据类型是实数。如果键不存在，则创建。
* `registry_read_string_ext(key, name)` 读取键 key 中名称 name 对应的数据，数据类型是字符串。若不存在，则返回空字符串。
* `registry_read_real_ext(key, name)` 读取键 key 中名称 name 对应的数据，数据类型是实数。 若不存在，则返回 0。
* `registry_exists_ext(key, name)` 返回指定键 key 中指定名称 name 是否存在。
