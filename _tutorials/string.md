---
layout: default
title: 字符串处理
nav_order: 15
---

# 字符串

我们曾经提到过，**字符串**（String）指的是以双引号包裹的一种常量。形如 `"Punishment this world!"`，`"153.66"`，`"tan(pi/2) is invalid"` 等都是字符串。

在 GM8.0 中，使用单引号和双引号都被视作字符串，即，`'abc'` 和 `"abc"` 是等效的。

在双引号中使用单引号，是不会被视作字符串标记符号的。如：`"I'm a man"` 中出现了单引号，但是字符串会把这个单引号也视为普通的字符，而不是当成字符串的标记符号。反过来也同理，在单引号字符串中出现双引号也会被视为普通字符：

```c
'As the saying goes :"Where there is a will, there is a way."'
```

*注意：GMS2 已停用单引号字符串，使用单引号字符串会报错*。在 GMS2 中想要在字符串里出现双引号，需要使用转义符 `\"`。

另外，字符中有一个特殊的标记符号 `#`，它代表换行，比如：`"First#Second"`，当使用 `show_message` 或者后面讲到的其他输出函数时，读取到 · 就会自动换行，但是 `#` 本身不会被输出。如果你想要直接输出 `#`，那么要使用 `\#` 来代替，它代表正常输出 `#` 而不是作为换行符号来使用。例如 `"First\#Second"` 输出的是 `First#Second`。

# ASCII 与 ANSI 与 Unicode

我们在第十章的时候讲过，电脑以[二进制]({{ site.baseurl }}{% link _tutorials/binary/binary.md %})运行，所以实质上只能储存整数数据，电脑要储存别的类型的数据就必须先把它转换为整数。

**ASCII** 就是一种将字符转换为整数的一种编码方式。

![ASCII Table](/assets/images/string/ascii_table.svg)

注意，ASCII 的范围是 0 到 127，但是只有 32 到 126 输出的是能看到的字符，0 到 31 与 127 被称为**控制符**，即这些编号的字符代表的是一种功能，而不是输出一个可见的字符。制作 GM 游戏基本上不用考虑控制符，故不讲，有兴趣可以自行百度。

你可能注意到，这个表上并没有中文。ASCII 是众多的编码方式的一种，它提出的较早，当时只有欧美国家用得起电脑，所以并未考虑其他语言的字符。而即使是现在，ASCII 也是一种使用频率非常高的编码方式。

中文的编码使用 GBK（或 GB2321），但是这套编码方式只用于中国，外国的电脑是无法识别这种编码方式的，只会显示乱码。同样的，每个国家都为自己的语言文字设计了一套编码方式，这导致了不同国家之间网络交流困难。这类各个国家为自己的语言设计的独有的编码方式，统称 **ANSI**，在中国，ANSI 指 GBK，在台湾，ANSI 指 Big5，在日本，ANSI 指 shift-JIS。

为了解决这种一个国家一种编码的问题，**Unicode** 应运而生，这是一种几乎把全世界所有可能用到的字符都考虑进去的一种编码方式，所以进入 21 世纪之后，大部分国家（包括中国）开始陆陆续续地使用与推广 Unicode，方便了不同国家之间的网络交流。如果你想了解 Unicode 的字符与整数的对应关系，可以在 [Unicode® 字符百科](https://unicode-table.com/cn/)中查询。

现在回到 GM8，事实上它只支持 ASCII。你可能注意到 GM8 的代码框中可以输入中文，但这全是汉化组的功劳，如果你使用的是原装的 GM8，写入中文只能得到乱码。如果使用 `show_message()` 输出一段中文字符串，那么实际输出什么就和系统有关了。大部分情况下中国的电脑会正常地显示中文。但是日本电脑使用 shift-JIS 编码，这就导致很多日本制作的 GM8 的游戏，在中国玩会显示乱码，如下图：

![Justice CN](/assets/images/string/justice_cn.png)

但是如果把系统转换到日本地区，就能正常显示了：

![Justice JP](/assets/images/string/justice_jp.png)

所以使用中文需慎重，最好使用世界通用语言英语。为什么使用英语不会产生乱码问题呢？因为后期诞生的编码方式，基本上都向 ASCII 兼容，即前 127 位保持和 ASCII 完全一样，往后面再加自己的字符。这样，不管系统使用什么编码方式，都能正常读取英文字符。

# 字符串的处理

本节位于 GML 汉化文档第 18 页。

需要注意一点的是，GM8 的字符串的索引比较特立独行，从 1 开始。其他的索引均从 0 开始。

* `chr(val)` 返回实数 val 对应的 ASCII 字符的字符串。
* `ord(str)` 返回字符串中第一个字符的 ASCII 码。在[键盘检测]({{ site.baseurl }}{% link _tutorials/keyboard_mouse.md %}#键盘检测)中，为了方便使用 `keyboard_check` 系列函数，将字母按键和 ASCII 码互相匹配，所以可以用 `ord()` 来代表字母按键。同样的，你也可以用 ASCII 码来表示按键，比如按键 A 对应 65，所以你可以用 `keyboard_check(65)` 来检测 A 键。
* `real(str)` 返回字符串中的真实数值。注意这个函数与上一个函数的区别，`ord('1')` 返回的是字符 `'1'` 的 ASCII 码 49，而 `real("1")` 则返回 1。`real` 是在字符串中寻找数值，比如 `real("-356")` 返回 -356。注意，`real()` 函数的参数必须是一个只包含有效数值的字符串，这个字符串可以有负号，小数点，以及 `E` 和 `e`（代表10的多少次幂），例如 `real("-26.32e3")` 返回 -26320。注意，符号 `^` 是位运算符不是幂函数符，不被视作有效数字的一部分。
* `string(val)` 与 `real()` 相反，把真实数值转换为字符串。注意，参数会自动进行运算，比如 `string(5 + 6)` 返回 `"11"` 而不是`"5 + 6"`。
* `string_format(val, tot, dec)` 同样是把真实数值转换为字符串，但是可以自己控制格式。tot 是 total 的缩写，指数据的总位数，dec 是 decimal 的缩写，指小数点后的位数。tot 参数可能不好理解，举个例子，`string_format(1234.56, 12, 5)`，返回字符串 `"　　1234.56000"`，注意前面有两个空格（由于 Markdown 不显示连续的两个半角空格，此处用全角空格代替），两个空格加上数字本身的字符数（小数点也算一个），刚好是 12 个字符，这就是参数 tot 的意义。tot 只有在大于数据的字符数时才会生效，例如，`string_format(123.456789, 3, 3)`，返回字符串 `"123.457"`，此时的 tot 参数毫无意义。
* `string_length(str)` 返回字符串中字符的个数。
* `string_pos(substr, str)` 返回字符串 str 中子字符串 substr 的位置。如 `string_pos("ab", "abcd")` 返回 1。如果不存在，则返回 0。
* `string_copy(str, index, count)` 返回字符串 str 从第 index 个字符开始长度为 count 的字符串。例如：`string_copy("123456", 2, 3)` 返回 `"234"`。
* `string_char_at(str, index)` 返回字符串 str 第 index 个字符。
* `string_delete(str, index, count)` 返回字符串 str 从第 index 个字符开始删除长度为 count 的字符串后剩下的字符串。注意，字符串 str 本身不会被改变。例如：`string_delete("abcdef", 3, 2)` 返回 `"abef"`。
* `string_insert(substr, str, index)` 返回在位置 index 处添加子串 substr 后的 字符串 str。
* `string_replace(str, substr, newstr)` 返回字符串 str 的一份拷贝，为字符串中子串 substr 第一次出现的地方开始被字符串 newstr 替换后的内容。
* `string_replace_all(str, substr, newstr)` 返回字符串 str 的一份拷贝，为字符串中子串 substr 所有出现的地方开始被字符串 newstr 替换后的内容。
* `string_count(substr, str)` 返回子串 substr 在字符串 str 中出现的次数。
* `string_lower(str)` 返回小写格式的字符串 str。
* `string_upper(str)` 返回大写格式的字符串 str。
* `string_repeat(str, count)` 返回由 count 个字符串 str 组成的新字符串 str。
* `string_letters(str)` 返回只包含字母的字符串 str。
* `string_digits(str)` 返回只包含数字的字符串 str。
* `string_lettersdigits(str)` 返回包含字母和数字的字符串 str。
* `clipboard_has_text()` 返回剪贴板中是否存在任何文本。
* `clipboard_get_text()` 返回当前剪贴板内文本内容。
* `clipboard_set_text(str)` 将字符串 str 送入剪贴板。

# execute_string

GM8 专属函数，GMS2 已删除。作用是将字符串作为**代码**执行。

例如：

```c
execute_string("a = 5;");
```

就会执行代码 `a = 5;`。

如果只是直接填一个字符串作为参数，那么用这个函数是没有意义的。但是记住 string 是可以相加的，也可以通过函数来编辑，这就令 `execute_string` 变得十分有趣。

例如，你要设计一个可以更换风格的游戏，于是你准备了三套 spr，分别对应命名，比如 sprGrass1，sprGrass2，sprGrass3 来代表三种风格中草的 spr，那么你就可以通过 `execute_string()` 快速的更换画风（假设 `global.style` 变量用来储存画风的编号）：

```c
with(all)
{
    var spr;
    spr = string_delete(sprite_get_name(sprite_index), string_length(sprite_get_name(sprite_index)), 1) + string(global.style);
    execute_string("sprite_index = " + spr + ";");
}
```

再比如，你想让用户输入精灵名，他输入什么就使用同名精灵，那么你可以：

```c
spr = get_string("Which sprite you want to use?", sprite_get_name(sprite_index));
execute_string("sprite_index = " + spr + ";");
```

这个函数总是能起到一些奇奇怪怪的作用，当你卡壳的时候，说不定使用 `execute_string` 会带来新的思路。

*扩展：带参数的 `execute_string`*

事实上，`execute_string` 的真正形态是 `execute_string(str, arg0, arg1, arg2 ...)`。这是一种将字符串 str 作为脚本来执行的一种方法。例如：

```c
execute_string("sprite_index = argument0;", sprBall);
```

在执行代码 `sprite_index = argument0;` 时，会将 sprBall 作为 argument0 的参数传递给字符串，最终执行代码 `sprite_index = sprBall;`。
