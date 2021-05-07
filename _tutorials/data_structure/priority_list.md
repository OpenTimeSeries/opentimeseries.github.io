---
layout: default
title: 优先队列
nav_order: 5
parent: 数据结构
---

**优先队列**（priority list）与队列不同，不是以加入的时间顺序作为索引，而是以优先级作为索引。这种数据结构可以帮助你根据数据的重要程度来决定数据的处理顺序。

* `ds_priority_create()` 创建一个优先队列，返回它的索引。
* `ds_priority_destroy(id)` 销毁索引为 id 的优先队列。一旦你使用完，一定要销毁优先队列释放内存。
* `ds_priority_clear(id)` 清空索引为 id 的优先队列内所有数据。
* `ds_priority_copy(dest, src)` 将索引为 src 的优先队列的数据拷贝到索引为 dest 的优先队列中。
* `ds_priority_size(id)` 返回索引为 id 的优先队列储存了多少个数据。
* `ds_priority_empty(id)` 返回索引为 id 的优先队列是否为空。
* `ds_priority_add(id, val, prio)` 向索引为 id 的优先队列中添加数据 val，这个数据的优先级是 prio。
* `ds_priority_change_priority(id, val, prio)` 将索引为 id 的优先队列中数据 val 的优先级更改为 prio。
* `ds_priority_find_priority(id, val)` 返回索引为 id 的优先队列中数据 val 的优先级。
* `ds_priority_delete_value(id,val)` 删除索引为 id 的优先队列中的数据 val。
* `ds_priority_delete_min(id)` 返回索引为 id 的优先队列中优先级最小的数值并移除它。
* `ds_priority_delete_max(id)` 返回索引为 id 的优先队列中优先级最大的数值并移除它。
* `ds_priority_find_min(id)`  返回索引为 id 的优先队列中优先级最小的数值但是不移除它。
* `ds_priority_find_max(id)`  返回索引为 id 的优先队列中优先级最大的数值但是不移除它。
* `ds_priority_write(id)` 将索引为 id 的优先队列转换为字符串，返回这个字符串。通常用于储存到文件中。
* `ds_priority_read(id, str)` 从字符串 str 中读取优先队列。与上面这个函数配对，用于从文件中读取优先队列。
