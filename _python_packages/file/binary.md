---
layout: post
title: 二进制文件流
nav_order: 1
parent: 文件流
---

### 打开文件

* `file_bin_open(file, mode)` 以二进制文件流打开一个文件，参数 file 为文件的完整路径，参数 mode 取 0 表示只读，取 1 表示只写，取 2 表示既读也写。该函数会创建一个二进制文件流，并且返回它的索引。

### 关闭文件

* `file_bin_close(file id)` 关闭索引为 file id 的二进制文件流。

### 写入文件

* `file_bin_write_byte(file id, val)` 将数据 val 写入索引为 file id 的二进制文件流中。注意，一次只能写一个字节，即 val 只能取 0\~255。

如果我们要储存大于 255 的数据，那么就要把它分段储存。例如有一个变量 value，可能的取值范围是 0\~1654558，它可能的最大值大于 65535（256²-1），小于 16777215（256³-1），因此在储存 value 时，我们需要这样写：

```c
var f, temp;
f = file_bin_open(working_directory + "\SaveData", 1);
temp = value;

file_bin_write_byte(f, temp div (256 * 256));
temp -= (temp div (256 * 256)) * 256 * 256;
file_bin_write_byte(f, temp div 256);
temp -= (temp div 256) * 256;
file_bin_write_byte(f, temp);

file_bin_close(f);
```

即把变量 value 拆成 `value = a * 256² + b * 256 + c` 的形式，再分别储存 a，b，c 三个值。

对于任意大小的一个整数，我们都可以把它拆成 `a1 * 256^(n - 1) + a2 * 256^(n - 2) + ...... + an-1 * 256 + an` 一共 n 个数据来储存。

注意，由于上述例子中使用了 `-=`，因此要用 temp 来替代 value 进行操作，否则会改变 value 的值。

### 读取文件

* `file_bin_read_byte(file id)` 从索引为 file id 的二进制流中读出正在处理的那个字节的数据，返回该数据，一定是 0\~255 中的一个数值。

继续上述例子，我们把变量 value 分成了三个 0~255 的字节数据储存在了文件中，那么我们要怎么读出这三个数据还原出 value 呢？

```c
var f;
f = file_bin_open(working_directory + "\SaveData", 0);

value = file_bin_read_byte(f) * 256 * 256;
value += file_bin_read_byte(f) * 256;
value += file_bin_read_byte(f);

file_bin_close(f);
```

注意第一个是 `=`，之后都是 `+=`。可见，**读取数据就是写入数据的反操作**。在这里我们明确的知道我们写入了三个字节来保存 value 变量的值，因此我们可以通过读取三个字节来还原 value 变量的值。但是这并不是硬性的规定，如果你需要，也可以把这三个字节拆成三个数据或两个数据来使用。

### 面向初学者的简化

假如你对二进制感到十分吃力，我们也可以换一种办法来储存实数，那就是不以 256 为拆分点，而是**以 100 为拆分点**。比如 value 的值是 114253，我们可以把它拆成 `114253 = 11 * 10000 + 42 * 100 + 53`，这样我们就得到了三个数据：11，42，53，将这三个数据分别写入二进制文档即可。代码就是：

```c
var f, temp;
f = file_bin_open(working_directory + "\SaveData", 1);
temp = value;

file_bin_write_byte(f, temp div 10000);
temp -= (temp div 10000) * 10000;
file_bin_write_byte(f, temp div 100);
temp -= (temp div 100) * 100;
file_bin_write_byte(f, temp);

file_bin_close(f);
```

对于任何一个数据，都可以隔两位拆分一个数据，例如 655641213 拆成 6，55，64，12，13 一共五个数据来保存。本质上其实与以 256 作为基数储存数据并没有什么不同，硬要说的话就是更占内存了。但是使用我们熟悉的 10 进制拆分数据，比起陌生的 16 进制，可能会更有助于理解二进制文件流。同样的，**在读取数据时，基数 256 也要改为 100**，这里不再累赘的写出完整代码。*注意，你选择的基数可以是 2~256 之间的任意值，但是一定不能大于 256。*

### 储存负数小数

GM 的二进制流储存的是**单字节无符号的整数**，并不提供储存负数和小数，因此，我们需要自己来实现这个功能。如果一个变量 value 既可能是正数也可能是负数，取值范围假设是 -1654558~1654558，那么需要这样来储存：

```c
var f, temp;
f = file_bin_open(working_directory + "\SaveData", 1);
temp = abs(value);

file_bin_write_byte(f, sign(value) + 1);
file_bin_write_byte(f, temp div (256 * 256));
temp -= (temp div (256 * 256)) * 256 * 256;
file_bin_write_byte(f, temp div 256);
temp -= (temp div 256) * 256;
file_bin_write_byte(f, temp);

file_bin_close(f);
```

即**占用一个字节来储存 value 的正负**，而 temp 则取 value 的绝对值。

注意，由于 `sign(value)` 的返回值为 -1（value 为负数），0（value==0），1（value 为正数），而 -1 本身依然是个负数，不能用来储存，因此我们要储存 `sign(value) + 1`，即用 0 来代表负数，1 代表 0，2 代表正数。

同样的，在读取这个数据时，我们也需要自行判断 value 的正负：

```c
var f, sig;
f = file_bin_open(working_directory + "\SaveData", 0);

sig = file_bin_read_byte(f);
value = file_bin_read_byte(f) * 256 * 256;
value += file_bin_read_byte(f) * 256;
value += file_bin_read_byte(f);
if (!sig)
value = -value;

file_bin_close(f);
```

而对于储存小数，个人建议使用数据结构 + 文本文件流，但是要用二进制流储存也不是没有办法。

（此段不重要，可跳过不看，将在[二进制]({{ site.baseurl }}{% link _tutorials/binary/data.md %}#小数)中更详细地介绍）在其他语言中，通常将小数拆分为四部分：**阶符**，**阶码**，**数符**，**数码**。数符就是指整个数据的正负，而阶符是指阶码的正负。阶码和数码如何构成数据？假设为 a，b，则数据 = `1.b * 2^a`。1.b 表示把 b 的数据放在小数点后，小数点后补 1，比如假设 b 的二进制是 `10110`，那么 `1.b` 就是 `1.10110`，这个数据就是二进制的小数，可以类比十进制来理解。由于二进制下第一位一定是 1，所以第一位 1 通常都不写。a 表示 2 的多少次方，a 的正负由阶码决定。不知道各位是否学过科学计数法，即用 `x * 10^y` 来表示一个数，其中 a 是整数部分只有一位的实数，用科学计数法可以表示任意整数和小数。`1.a * 2^b` 就是二进制形式下的科学计数法了，同样可以表示出任意整数和小数。

但是这种表示方法实在不适合初学者，因此这里给出一种十分简单的方法：**放缩**。说白了，就是把小数乘 1000...（省略多个 0），**让这个小数变成一个整数**，或者虽然还不是整数，但是得到的整数部分已经足够精确了，然后**再把得到的整数储存在文件中**。例如假设 value 的取值范围变成了 0~100 之间的任意小数，要求储存的小数的小数点后至少有六位，那么就把 value 放大 1000000 倍，变成 0~100000000 之间的一个很大的数，这个很大的数的小数部分则不再考虑，接下来把这个很大的数按照上面的办法拆为 256 的倍数和储存在文件中即可。而在读取这个数据时，只要在读取数据结束后，再执行 `value = value / 1000000` 即可还原原本的小数。

### 判断文件结束

一般来讲由于二进制文件流写入和读出有极大的关联性，要精确读出每一个数据，就必须知道写入每一个数据的字节数，所以很少会出现要手动判断文件结束的情况，不过姑且还是说一说比较好。

* `file_bin_size(file id)` 返回索引为 file id 的二进制文件流所处理的文件的大小(字节)。
* `file_bin_position(file id)` 返回索引为 file id 的二进制文件流正在处理第几个字节（注意，从 0 开始）。

判断二进制文件流结束的标准就是 `file_bin_position(f) == file_bin_size(f)`。

### 定位

* `file_bin_seek(file id, pos)` 令索引为 file id 的二进制文件流从 pos 位置的字节处理。与 `file_bin_position` 一样，是从 0 开始的。
