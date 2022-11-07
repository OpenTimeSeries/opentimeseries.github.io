---
layout: post
title: 配对
nav_order: 4
parent: 数据结构
toc: false
---

**配对**（map）可以看做对列表的功能扩充，在保留列表功能的情况下，允许用户自定义索引（可以是实数也可以是字符串）。通常在配对中，将自定义的索引称为**键**（key），配对数据结构通常也被叫做**键值**（key-value）数据结构。与列表面向小数据不同，配对通常都是面向大数据的管理。比如 windows 的**注册表**，就是十分典型的配对。

* `ds_map_create()` 创建一个配对，返回它的索引。
* `ds_map_destroy(id)` 销毁索引为 id 的配对。一旦你使用完，一定要销毁配对释放内存。
* `ds_map_clear(id)` 清空索引为 id 的配对内所有数据。
* `ds_map_copy(dest, src)` 将索引为 src 的配对的数据拷贝到索引为 dest 的配对中。
* `ds_map_size(id)` 返回索引为 id 的配对储存了多少个数据。
* `ds_map_empty(id)` 返回索引为 id 的配对是否为空。
* `ds_map_add(id, key, val)` 向索引为 id 的配对中添加数据 val，这个数据的键是 key。
* `ds_map_replace(id, key, val)` 将索引为 id 的配对中键为 key 的数据替换为 val。
* `ds_map_delete(id, key)` 删除索引为 id 的配对中键为 key 的数据。如果一个键对应多个数据，只有一个会被移除。话虽这么说，但是一般不建议也不应该给不同的数据分配相同的索引。
* `ds_map_exists(id, key)` 返回索引为 id 的配对中是否存在 key 这个键。
* `ds_map_find_value(id, key)` 返回索引为 id 的配对中键为 key 的数据。
* `ds_map_find_previous(id, key)` 返回在索引为 id 的配对中比 key 小的最大键，注意返回的是键不是值。如果你的一个配对中既有实数键，又有字符串键，那么在排序时，字母按 A-Z 从小到大，不区分大小写，并且字符串键比实数键大。
* `ds_map_find_next(id, key)` 返回索引为 id 的配对中比 key 大的最小键。
* `ds_map_find_first(id)` 返回索引为 id 的配对中最小的键。
* `ds_map_find_last(id)` 返回索引为 id 的配对中最大的键。
* `ds_map_write(id)` 将索引为 id 的配对转换为字符串，返回这个字符串。通常用于储存到文件中。
* `ds_map_read(id, str)` 从字符串 str 中读取配对。与上面这个函数配对，用于从文件中读取配对。
