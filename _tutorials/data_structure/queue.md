---
layout: default
title: 队列
nav_order: 2
parent: 数据结构
---

**队列**（queue）与堆栈相反，是“**先入先出，后入后出**”的数据结构，向队列添加数据，会被置于队列底层，但是读取数据依然是从顶层开始的。因此，先被加入队列的数据就会被先处理，而后被加入队列的数据就后被处理。队列比堆栈更具有通用性，例如消息处理，通信等。

* `ds_queue_create()` 创建一个队列，返回它的索引。
* `ds_queue_destroy(id)` 销毁索引为 id 的队列。一旦你使用完，一定要销毁队列释放内存。
* `ds_queue_clear(id)` 清空索引为 id 的队列内所有数据。
* `ds_queue_copy(dest, src)` 将索引为 src 的队列的数据拷贝到索引为 dest 的队列中。
* `ds_queue_size(id)` 返回索引为 id 的队列储存了多少个数据。
* `ds_queue_empty(id)` 返回索引为 id 的队列是否为空。
* `ds_queue_enqueue(id, val)` 向索引为 id 的队列底层加入数据 val。
* `ds_queue_dequeue(id)` 返回索引为 id 的队列顶层的数据，并且移除这个数据。
* `ds_queue_head(id)` 返回索引为 id 的队列顶层的数据，但是不移除该数据。
* `ds_queue_tail(id)` 返回索引为 id 的队列底层的数据，不移除且不能移除。
* `ds_queue_write(id)` 将索引为 id 的队列转换为字符串，返回这个字符串。通常用于储存到文件中。
* `ds_queue_read(id, str)` 从字符串 str 中读取队列。与上面这个函数配对，用于从文件中读取队列。
