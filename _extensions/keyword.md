---
layout: default
title: 关键字、运算符一览
nav_order: 1
redirect_from:
- /extensions/
---

# 关键字

<table>
<tr>
<th>关键字</th>
<th>解释</th>
<th>格式</th>
</tr>
<tr>
<td>mod</td>
<td>取模</td>
<td markdown="1">
```c
表达式 mod 表达式
```
</td>
</tr>
<tr>
<td>div</td>
<td>取整</td>
<td markdown="1">
```c
表达式 div 表达式
```
</td>
</tr>
<tr>
<td>if</td>
<td>基于条件的分支结构</td>
<td markdown="1">
```c
if(条件)
    语句;
```
</td>
</tr>
<tr>
<td>else</td>
<td>作为当 if 结构中条件为 false 时的分支</td>
<td markdown="1">
```c
if(条件)
    语句;
else
    语句;
```
</td>
</tr>
<tr>
<td>switch</td>
<td>与 case，break 一起使用的多分支结构</td>
<td markdown="1">
```c
switch (表达式)
{
    case 值1:
        语句;
        break;
    case 值2:
        语句;
        break;
}
```
</td>
</tr>
<tr>
<td>default</td>
<td>作为 switch 结构的默认分支</td>
<td markdown="1">
```c
switch (表达式)
{
    case 值1:
        语句;
        break;

    case 值2:
        语句;
        break;

    default:
        语句;
}
```
</td>
</tr>
<tr>
<td>repeat</td>
<td>最简单的循环结构</td>
<td markdown="1">
```c
repeat(次数)
    语句;
```
</td>
</tr>
<tr>
<td>while</td>
<td>基于条件的循环结构</td>
<td markdown="1">
```c
while(条件)
    语句;
```
</td>
</tr>
<tr>
<td>for</td>
<td>将初始化语句，循环条件，变量自增整合在一起的循环结构</td>
<td markdown="1">
```c
for(初始化语句; 循环条件; 变量自增)
    语句;
```
</td>
</tr>
<tr>
<td>do</td>
<td>与 until 一起使用的循环结构，必定循环一次</td>
<td markdown="1">
```c
do
    语句;
until(条件);
```
</td>
</tr>
<tr>
<td>until</td>
<td>与 do 一起使用的循环结构，必定循环一次</td>
<td markdown="1">
```c
do
    语句;
until(条件);
```
</td>
</tr>
<tr>
<td>with</td>
<td>令其他实例运行一段代码，也属于循环结构的一种</td>
<td markdown="1">
```c
with(对象/实例)
    语句;
```
</td>
</tr>
<tr>
<td>continue</td>
<td>中断本次循环进入到下一次循环</td>
<td></td>
</tr>
<tr>
<td>break</td>
<td>中断循环并跳出</td>
<td></td>
</tr>
<tr>
<td>exit</td>
<td>中断一个脚本或一段代码</td>
<td></td>
</tr>
<tr>
<td>return</td>
<td>退出脚本并返回一个值</td>
<td markdown="1">
```c
return 表达式;
```
</td>
</tr>
<tr>
<td>true</td>
<td>逻辑真，等效于 1</td>
<td></td>
</tr>
<tr>
<td>false</td>
<td>逻辑假，等效于 0</td>
<td></td>
</tr>
<tr>
<td>pi</td>
<td>圆周率</td>
<td></td>
</tr>
<tr>
<td>and</td>
<td>逻辑与，等效于 &&</td>
<td markdown="1">
```c
逻辑表达式 and 逻辑表达式
```
</td>
</tr>
<tr>
<td>or</td>
<td>逻辑或，等效于 ||</td>
<td markdown="1">
```c
逻辑表达式 or 逻辑表达式
```
</td>
</tr>
<tr>
<td>xor</td>
<td>逻辑异或，等效于 ^^</td>
<td markdown="1">
```c
逻辑表达式 xor 逻辑表达式
```
</td>
</tr>
<tr>
<td>not</td>
<td>逻辑否，等效于 !</td>
<td markdown="1">
```c
not 逻辑表达式
```
</td>
</tr>
<tr>
<td>self</td>
<td>值为 -1，表示运行代码的当前实例</td>
<td></td>
</tr>
<tr>
<td>other</td>
<td>值为 -2，表示参与碰撞事件的另一个实例或 with 结构的调用者</td>
<td></td>
</tr>
<tr>
<td>all</td>
<td>值为 -3，表示所有实例</td>
<td></td>
</tr>
<tr>
<td>noone</td>
<td>值为 -4，表示无实例</td>
<td></td>
</tr>
<tr>
<td>global</td>
<td>值为 -5，表示全局变量</td>
<td></td>
</tr>
<tr>
<td>local</td>
<td>值为 -7，表示局部变量</td>
<td></td>
</tr>
<tr>
<td>then</td>
<td>兼容 pascal 语法，无特殊作用</td>
<td markdown="1">
```c
if (条件) then
    语句;
```
</td>
</tr>
<tr>
<td>begin</td>
<td>兼容 pascal 语法，等同于 {，可混用</td>
<td markdown="1">
```c
begin
    语句;
    语句;
end
```
</td>
</tr>
<tr>
<td>end</td>
<td>兼容 pascal 语法，等同于 }，可混用</td>
<td markdown="1">
```c
begin
    语句;
    语句;
end
```
</td>
</tr>
</table>

# 运算符

<table>
<tr>
<th>运算符</th>
<th>解释</th>
<th>格式</th>
</tr>
<tr>
<td>+</td>
<td>正号</td>
<td markdown="1">
```c
+表达式
```
</td>
</tr>
<tr>
<td>+</td>
<td>算术加号</td>
<td markdown="1">
```c
表达式 + 表达式
```
</td>
</tr>
<tr>
<td>+=</td>
<td>算术加号及赋值</td>
<td markdown="1">
```c
变量 += 表达式;
```
</td>
</tr>
<tr>
<td>-</td>
<td>负号</td>
<td markdown="1">
```c
-表达式
```
</td>
</tr>
<tr>
<td>-</td>
<td>算术减号</td>
<td markdown="1">
```c
表达式 - 表达式
```
</td>
</tr>
<tr>
<td>-=</td>
<td>算术减号及赋值</td>
<td markdown="1">
```c
变量 -= 表达式;
```
</td>
</tr>
<tr>
<td>*</td>
<td>算术乘号</td>
<td markdown="1">
```c
表达式 * 表达式
```
</td>
</tr>
<tr>
<td>*=</td>
<td>算术乘号及赋值</td>
<td markdown="1">
```c
变量 *= 表达式;
```
</td>
</tr>
<tr>
<td>/</td>
<td>算术除号</td>
<td markdown="1">
```c
表达式 / 表达式
```
</td>
</tr>
<tr>
<td>/=</td>
<td>算术除号及赋值</td>
<td markdown="1">
```c
变量 /= 表达式;
```
</td>
</tr>
<tr>
<td>=（或:=）</td>
<td>赋值等号</td>
<td markdown="1">
```c
变量 = 表达式;
```
</td>
</tr>
<tr>
<td>==（或:=或=）</td>
<td>逻辑等号</td>
<td markdown="1">
```c
表达式 == 表达式;
```
</td>
</tr>
<tr>
<td>!=（或<>）</td>
<td>不等号</td>
<td markdown="1">
```c
表达式 != 表达式;
```
</td>
</tr>
<tr>
<td>></td>
<td>大于号</td>
<td markdown="1">
```c
表达式 > 表达式
```
</td>
</tr>
<tr>
<td><</td>
<td>小于号</td>
<td markdown="1">
```c
表达式 < 表达式
```
</td>
</tr>
<tr>
<td>>=</td>
<td>大于等于号</td>
<td markdown="1">
```c
表达式 >= 表达式
```
</td>
</tr>
<tr>
<td><=</td>
<td>小于等于号</td>
<td markdown="1">
```c
表达式 <= 表达式
```
</td>
</tr>
<tr>
<td>&&</td>
<td>逻辑与</td>
<td markdown="1">
```c
逻辑表达式 && 逻辑表达式
```
</td>
</tr>
<tr>
<td>||</td>
<td>逻辑或</td>
<td markdown="1">
```c
逻辑表达式 || 逻辑表达式
```
</td>
</tr>
<tr>
<td>^^</td>
<td>逻辑异或</td>
<td markdown="1">
```c
逻辑表达式 ^^ 逻辑表达式
```
</td>
</tr>
<tr>
<td>!</td>
<td>逻辑否</td>
<td markdown="1">
```c
!逻辑表达式
```
</td>
</tr>
<tr>
<td>$</td>
<td>十六进制符</td>
<td markdown="1">
```c
$十六进制串
```
</td>
</tr>
<tr>
<td>,</td>
<td>逗号，用以区分函数参数</td>
<td markdown="1">
```c
函数名(参数1, 参数2, 参数3)
```
</td>
</tr>
<tr>
<td>,</td>
<td>逗号，用以区分数组维度</td>
<td markdown="1">
```c
数组名[第一维, 第二维]
```
</td>
</tr>
<tr>
<td>;</td>
<td>分号，用以结束语句</td>
<td markdown="1">
```c
语句;
```
</td>
</tr>
<tr>
<td>(...)</td>
<td>括号，用以确定运算符的执行顺序</td>
<td markdown="1">
```c
(表达式)
```
</td>
</tr>
<tr>
<td>(...)</td>
<td>括号，构成函数调用</td>
<td markdown="1">
```c
函数名(参数列表)
```
</td>
</tr>
<tr>
<td>[...]</td>
<td>数组运算符</td>
<td markdown="1">
```c
数组名[表达式]
```
</td>
</tr>
<tr>
<td>{...}</td>
<td>块表达式，将多个语句视作一个语句</td>
<td markdown="1">
```c
{
    语句1;
    语句2;
}
```
</td>
</tr>
<tr>
<td>"（或 '）</td>
<td>构成字符串表达式的边界</td>
<td markdown="1">
```c
"字符串值"
```
</td>
</tr>
<tr>
<td>.</td>
<td>成员运算符，访问其他实例的变量</td>
<td markdown="1">
```c
实例.变量
```
</td>
</tr>
<tr>
<td>&</td>
<td>按位与</td>
<td markdown="1">
```c
表达式 & 表达式
```
</td>
</tr>
<tr>
<td>&=</td>
<td>按位与及赋值</td>
<td markdown="1">
```c
变量 &= 表达式
```
</td>
</tr>
<tr>
<td>|</td>
<td>按位或</td>
<td markdown="1">
```c
表达式 | 表达式
```
</td>
</tr>
<tr>
<td>|=</td>
<td>按位或及赋值</td>
<td markdown="1">
```c
变量 |= 表达式
```
</td>
</tr>
<tr>
<td>^</td>
<td>按位异或</td>
<td markdown="1">
```c
表达式 ^ 表达式
```
</td>
</tr>
<tr>
<td>^=</td>
<td>按位异或及赋值</td>
<td markdown="1">
```c
变量 ^= 表达式
```
</td>
</tr>
<tr>
<td>~</td>
<td>按位取反</td>
<td markdown="1">
```c
~表达式
```
</td>
</tr>
<tr>
<td><<</td>
<td>按位左移</td>
<td markdown="1">
```c
表达式 << 表达式
```
</td>
</tr>
<tr>
<td>>></td>
<td>按位右移</td>
<td markdown="1">
```c
表达式 >> 表达式
```
</td>
</tr>
<tr>
<td>//</td>
<td>行注释的标识</td>
<td markdown="1">
```c
// 注释内容
```
</td>
</tr>
<tr>
<td>/*...*/</td>
<td>块注释的标识</td>
<td markdown="1">
```c
/* 
注释内容1
注释内容2
注释内容3 
*/
```
</td>
</tr>
</table>
