---
layout: default
title: 列表
nav_order: 3
parent: 数据结构
---

**列表**（list）可以看做堆栈，队列和数组的功能结合体，列表允许在任意位置插入数据，允许读取任意位置的数据，同样也允许移除任意位置的数据。但是作为代价，列表所占用的内存比堆栈和队列要高出一大截。

* `ds_list_create()` 创建一个列表，返回它的索引。
* `ds_list_destroy(id)` 销毁索引为 id 的列表。一旦你使用完，一定要销毁列表释放内存。
* `ds_list_clear(id)` 清空索引为 id 的列表内所有数据。
* `ds_list_copy(dest, src)` 将索引为 src 的列表的数据拷贝到索引为 dest 的列表中。
* `ds_list_size(id)` 返回索引为 id 的列表储存了多少个数据。
* `ds_list_empty(id)` 返回索引为 id 的列表是否为空。
* `ds_list_add(id, val)` 向索引为 id 的列表的尾部加入数据 val。
* `ds_list_insert(id, pos, val)` 向索引为 id 的列表的指定位置加入数据 val。注意，位置 pos 是从 0 开始的，下同。
* `ds_list_replace(id, pos, val)` 将索引为 id 的列表的指定位置的数据替换为 val。
* `ds_list_delete(id, pos)` 删除索引为 id 的列表中指定位置的数据。
* `ds_list_find_index(id, val)` 在索引为 id 的列表中搜索数据 val，如果存在，则返回 val 的位置，如果不存在，则返回 -1。
* `ds_list_find_value(id, pos)` 返回索引为 id 的列表中位置 pos 的数据。
* `ds_list_sort(id, ascend)` 将索引为 id 的列表排序，ascend 为是否升序排序（false 为降序排序）。
* `ds_list_shuffle(id)` 打乱索引为 id 的列表的数据顺序。
* `ds_list_write(id)` 将索引为 id 的列表转换为字符串，返回这个字符串。通常用于储存到文件中。
* `ds_list_read(id, str)` 从字符串 str 中读取列表。与上面这个函数配对，用于从文件中读取列表。
