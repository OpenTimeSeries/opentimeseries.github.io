---
layout: default
title: 栅格
nav_order: 6
parent: 数据结构
---

**栅格**（grid）可以看做列表与二维数组的组合体，它使用两个值来作为数据的索引，正因如此，栅格不能随随便便地改变其大小。

* `ds_grid_create(w, h)` 创建一个宽为 w，高为 h 的栅格。返回创建的栅格的索引。
* `ds_grid_destroy(id)` 销毁索引为 id 的栅格。一旦你使用完，一定要销毁栅格释放内存。
* `ds_grid_copy(dest, src)` 将索引为 src 的栅格的数据拷贝到索引为 dest 的栅格中，注意必须是同种栅格。
* `ds_grid_resize(id, w, h)` 改变索引为 id 的栅格的宽与高，保留栅格内对应位置的数据。
* `ds_grid_width(id)` 返回索引为 id 的栅格的宽。
* `ds_grid_height(id)` 返回索引为 id 的栅格的高。
* `ds_grid_clear(id, val)` 清除索引为 id 的栅格的指定数值 val。
* `ds_grid_set(id, x, y, val)` 设置索引为 id 的栅格中 (x, y) 位置的数据。可以视作二维数组 `arr[x, y] = val`，同样的，栅格的位置从 0 开始计数。
* `ds_grid_get(id, x, y)` 返回索引为 id 的栅格中 (x, y) 位置的数据。
* `ds_grid_add(id, x, y, val)` 将索引为 id 的栅格中 (x, y) 位置的数据与 val 相加并取代原本的数据。如果是字符串，则接在原字符串的后面。
* `ds_grid_multiply(id, x, y, val)` 将索引为 id 的栅格中的 (x, y) 位置的数据与 val 相乘并取代原数据，仅当数据为实数时有效。
* `ds_grid_set_region(id, x1, y1, x2, y2, val)` 将索引为 id 的栅格中，左上角为 (x1, y1) 右下角为 (x2, y2) 的矩形范围内的数据全部设置为 val。
* `ds_grid_add_region(id, x1, y1, x2, y2, val)` 同上，只不过这个函数将其相加。
* `ds_grid_multiply_region(id, x1, y1, x2, y2, val)` 同上，只不过这个函数将其相乘。
* `ds_grid_set_disk(id, xm, ym, r, val)` 将索引为 id 的栅格中，以 (xm, ym) 为中心、r 为半径的圆的所有数据设置为 val。
* `ds_grid_add_disk(id, xm, ym, r, val)` 同上，只不过这个函数将其相加。
* `ds_grid_multiply_disk(id, xm, ym,r, val)` 同上，只不过这个函数将其相乘。
* `ds_grid_get_sum(id, x1, y1, x2, y2)` 返回索引为 id 的栅格中，左上角为 (x1, y1) 右下角为 (x2, y2) 的矩形范围内数据的总和，仅当数据为数字才有效。
* `ds_grid_get_max(id, x1, y1, x2, y2)` 同上，只不过这个函数返回最大的数据。
* `ds_grid_get_min(id, x1, y1, x2, y2)` 同上，只不过这个函数返回最小的数据。
* `ds_grid_get_mean(id, x1, y1, x2, y2)` 同上，只不过这个函数返回范围内数据的平均值。
* `ds_grid_get_disk_sum(id, xm, ym, r)` 返回索引为 id 的栅格中，以 (xm, ym) 为中心、r 为半径的圆的所有数据的总和。
* `ds_grid_get_disk_min(id, xm, ym, r)` 同上，只不过这个函数返回最大的数据。
* `ds_grid_get_disk_max(id, xm, ym, r)` 同上，只不过这个函数返回最小的数据。
* `ds_grid_get_disk_mean(id, xm, ym, r)` 同上，只不过这个函数返回范围内数据的平均值。
* `ds_grid_value_exists(id, x1, y1, x2, y2, val)` 返回索引为 id 的栅格中，左上角为 (x1, y1) 右下角为 (x2, y2) 的矩形范围内是否存在数据 val。
* `ds_grid_value_x(id, x1, y1, x2, y2, val)` 返回索引为 id 的栅格中，左上角为 (x1, y1) 右下角为 (x2, y2) 的矩形范围内数据 val 的 x 索引。
* `ds_grid_value_y(id, x1, y1, x2, y2, val)` 返回索引为 id 的栅格中，左上角为 (x1, y1) 右下角为 (x2, y2) 的矩形范围内数据 val 的 y 索引。
* `ds_grid_value_disk_exists(id, xm, ym, r, val)` 返回索引为 id 的栅格中，以 (xm, ym) 为中心、r 为半径的圆内是否存在数据 val。
* `ds_grid_value_disk_x(id, xm, ym, r, val)` 返回索引为 id 的栅格中，以 (xm, ym) 为中心、r 为半径的圆内数据 val 的 x 索引。
* `ds_grid_value_disk_y(id, xm, ym, r, val)` 返回索引为 id 的栅格中，以 (xm, ym) 为中心、r 为半径的圆内数据 val 的 y 索引。
* `ds_grid_shuffle(id)` 打乱索引为 id 的配对的数据顺序。
* `ds_grid_write(id)` 将索引为 id 的栅格转换为字符串，返回这个字符串。通常用于储存到文件中。
* `ds_grid_read(id, str)` 从字符串 str 中读取栅格。与上面这个函数配对，用于从文件中读取栅格。
