---
layout: default
title: 计时器事件
nav_order: 1
parent: 数组
---

现在我们可以来重新审视一下**计时器事件（Alarm Event）**。

![Alarm Event](/assets/images/array/alarm_event.png)

计时器事件在 GM 中也是以数组的形式表现的。

```c
alarm[0] = 50;
```

表示在 50 步之后执行 alarm 0 号事件。

注意：alarm 事件的调用代码也可以写在 alarm 事件，比如在 alarm 0 号事件写 `alarm[0] = 10;`，那么就会循环每隔十步执行一次 alarm 0 号事件。

在我们学习完数组之后，我们就可以让 alarm 事件变得更骚：

```c
alarm[irandom(4)] = 10;
```

上面的代码 10 步之后随机执行 alarm 0~4 号事件。

```c
for(i = 0;i < 3;i += 1)
    alarm[i] = i * 10;
```

上面的代码 10 步之后执行 alarm 0 号事件，20 步之后执行 alarm 1 号事件，30 步之后执行 alarm 2 号事件。即，每隔 10 步执行一个事件。
