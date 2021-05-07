---
layout: default
title: 使用 C++ 为 GM8 生成 dll
nav_order: 2
---

# 环境

[Visual Studio 2019 Community](https://visualstudio.microsoft.com/zh-hans/vs/community/)（下称 VS），需要安装“使用 C++ 的桌面开发”组件。

![VS](/assets/images/dll/vs.png)

# 生成 dll

首先，打开 VS，新建一个“具有导出项的动态链接库”项目，我们以生成一个 base64 的 dll 为例：

![New Project](/assets/images/dll/new_project1.png)

![New Project](/assets/images/dll/new_project2.png)

![New Project](/assets/images/dll/new_project3.png)

删除 Base64.h 和 Base64.cpp 示例代码（即下图红框部分）：

![New Project](/assets/images/dll/new_project4.png)

![New Project](/assets/images/dll/new_project5.png)

由于 GM8 的数据类型只有两种，实数和字符串，因此，我们给 GM8 提供的函数接口只能使用 `double` 和 `char *` 类型，并且 GM8 不接受类接口，只能接受全局函数，因此，我们在 Base64.h 做以下定义：

![Type](/assets/images/dll/type.png)

由于 C++ 在编译时会修改函数的名字（因为函数重载的存在），因此我们需要在声明函数时使用 `extern "C"` 声明为 C 式函数接口，当然，这样也就不允许进行函数重载了。不过不要认为 C 式接口就只能用 C 的方式写，这只是为了保护函数名字不被修改罢了，不影响函数内部正常使用 C++ 的类。

另外，所有提供给外部的接口都需要声明为 `BASE64_API`，在第八行我们知道它的定义是 `__declspec(dllexport)`，不同的项目定义的宏名字不同，因此你直接写 `__declspec(dllexport)`也是可以的。不使用 `BASE64_API` 或者 `__declspec(dllexport)`前缀的函数为 dll 的私有函数，只能在 dll 内部使用。

![Declare](/assets/images/dll/declare.png)

接下来在 Base64.cpp 里加入这两个函数的定义，此时既不需要 `extern "C"` 也不需要 `BASE64_API`。

```cpp
// Base64.cpp : 定义 DLL 应用程序的导出函数。

#include "pch.h"
#include "framework.h"
#include "Base64.h"
#include <string>

const unsigned char Base64EncodeMap[64] =
{
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
    'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
    'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
    'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3',
    '4', '5', '6', '7', '8', '9', '+', '/'
};

const unsigned char Base64DecodeMap[256] =
{
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0x3E, 0xFF, 0xFF, 0xFF, 0x3F,
    0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B,
    0x3C, 0x3D, 0xFF, 0xFF, 0xFF, 0x00, 0xFF, 0xFF,
    0xFF, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06,
    0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E,
    0x0F, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16,
    0x17, 0x18, 0x19, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F, 0x20,
    0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28,
    0x29, 0x2A, 0x2B, 0x2C, 0x2D, 0x2E, 0x2F, 0x30,
    0x31, 0x32, 0x33, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
};

GM_String base64_encode(GM_String str)
{
    size_t bytes = strlen(str);
    std::string strEncode;
    unsigned char Tmp[4] = { 0 };
    int LineLength = 0;
    for (int i = 0; i < (int)(bytes / 3); i++)
    {
        Tmp[1] = *str++;
        Tmp[2] = *str++;
        Tmp[3] = *str++;
        strEncode += Base64EncodeMap[Tmp[1] >> 2];
        strEncode += Base64EncodeMap[((Tmp[1] << 4) | (Tmp[2] >> 4)) & 0x3F];
        strEncode += Base64EncodeMap[((Tmp[2] << 2) | (Tmp[3] >> 6)) & 0x3F];
        strEncode += Base64EncodeMap[Tmp[3] & 0x3F];
        if (LineLength += 4, LineLength == 76) { strEncode += "\r\n"; LineLength = 0; }
    }

    int Mod = bytes % 3;
    if (Mod == 1)
    {
        Tmp[1] = *str++;
        strEncode += Base64EncodeMap[(Tmp[1] & 0xFC) >> 2];
        strEncode += Base64EncodeMap[((Tmp[1] & 0x03) << 4)];
        strEncode += "==";
    }
    else if (Mod == 2)
    {
        Tmp[1] = *str++;
        Tmp[2] = *str++;
        strEncode += Base64EncodeMap[(Tmp[1] & 0xFC) >> 2];
        strEncode += Base64EncodeMap[((Tmp[1] & 0x03) << 4) | ((Tmp[2] & 0xF0) >> 4)];
        strEncode += Base64EncodeMap[((Tmp[2] & 0x0F) << 2)];
        strEncode += "=";
    }

    char *output = new char[strEncode.size() + 1];
    memset(output, '\x000', strEncode.size() + 1);
    strEncode.copy(output, strEncode.size());

    return output;
}

GM_String base64_decode(GM_String str)
{
    size_t bytes = strlen(str);
    size_t outBytes = 0u;
    std::string strDecode;
    int nValue;
    int i = 0;
    while (i < bytes)
    {
        if (*str != '\r' && *str != '\n')
        {
            nValue = Base64DecodeMap[*str++] << 18;
            nValue += Base64DecodeMap[*str++] << 12;
            strDecode += (nValue & 0x00FF0000) >> 16;
            outBytes++;
            if (*str != '=')
            {
                nValue += Base64DecodeMap[*str++] << 6;
                strDecode += (nValue & 0x0000FF00) >> 8;
                outBytes++;
                if (*str != '=')
                {
                    nValue += Base64DecodeMap[*str++];
                    strDecode += nValue & 0x000000FF;
                    outBytes++;
                }
            }
            i += 4;
        }
        else
        {
            str++;
            i++;
        }
    }

    char *output = new char[strDecode.size() + 1];
    memset(output, '\x000', strDecode.size() + 1);
    strDecode.copy(output, strDecode.size());

    return output;
}
```

设置生成配置为 Release，点击生成：

![Target](/assets/images/dll/target.png)

![Generate](/assets/images/dll/generate.png)

前往生成路径寻找 dll 文件，并复制到 gmk 目录。

![File](/assets/images/dll/file.png)

# 调用 dll

打开 gmk，我们要为每一个 dll 中的函数声明一个脚本来调用。

* `external_define(dll, name, calltype, restype, argnumb, arg1type, arg2type, ...)` 该函数加载一个 dll 中的函数并返回其索引。参数 dll 为 dll 文件名或路径。参数 name 为函数在 dll 中的名字。calltype 为参数的压栈方式，可选 `dll_cdecl` 或者 `dll_stdcall`，对应C++中的关键字 `__cdecl` 和 `__stdcall`。参数 restype 即 result type，代表返回值类型，可选 `ty_real` 或者 `ty_string`，代表返回值为 `double` 或者 `char *`。参数 argnumb 为函数所需参数的数量。参数 arg1type, arg2type, ... 是函数各个参数的类型，可选值也是 `ty_real` 或者 `ty_string`，argnumb 是多少，就要填多少个 argtype。
* `external_call(id, arg1, arg2, ...)` 调用 dll 中的函数。参数 id 为 `external_define` 的返回值。参数 arg1, arg2, ... 为具体参数。
* `external_free(dll)` 释放 dll。

依然以 base64 为例，首先创建脚本 `base64_init` 初始化 dll：

```c
// base64_init()
{
    // dll 的路径。如果不在 gmk/exe 同路径下，请修改路径。
    global.base64DllPath = "Base64.dll"
    global.__base64_encode = external_define(global.base64DllPath, "base64_encode", dll_stdcall, ty_string, 1, ty_string);
    global.__base64_decode = external_define(global.base64DllPath, "base64_decode", dll_stdcall, ty_string, 1, ty_string);
}
```

然后为每个 dll 中的函数创建一个脚本。比如本例中，我们创建脚本 `base64_encode` 和脚本 `base64_decode`：

```c
// base64_encode(str)
{
    return external_call(global.__base64_encode, argument0);
}
```

```c
// base64_decode(str)
{
    return external_call(global.__base64_decode, argument0);
}
```

最后创建一个 `base64_free` 释放 dll：

```c
// base64_free()
{
    external_free(global.base64DllPath);
}
```

这样所有步骤就完成了。在使用 dll 的函数之前，首先要调用 init 函数来加载 dll 文件，最后不需要的时候使用 free 函数释放 dll。

使用简单的代码验证 dll 是否可用：

```c
base64_init();
str = "I wanna be the guy";
str = base64_encode(str);
show_message(str);
str = base64_decode(str);
show_message(str);
base64_free();
```

![Result](/assets/images/dll/result1.png)

![Result](/assets/images/dll/result2.png)

# 句柄

如果你想用 WinAPI 开发更强大的 dll，那么你大概很需要知道 GameMaker 游戏的主窗口句柄。

* `window_handle()` 返回主要窗口的句柄。

传递给 dll 时，句柄作为一个 real 类型（即 double 类型）数据传输。在 C++ 中，需要进行两次强制类型转换才能得到 C++ 的句柄类型：

```c
HWND hWnd = (HWND)(DWORD)handle;
```

其中 handle 为 `window_handle()` 传入 dll 中的 double 值。

本文不讲解如何使用 WinAPI 以及句柄，这属于 C++ 的知识，不属于 GM8 的知识。不过这里举一个简单的例子，使用 WinAPI 创建消息框取代 GM8 的 `show_message(str)` 函数：

```c
GM_Real showMessage(GM_Real handle, GM_String title, GM_String str)
{
    HWND hWnd = (HWND)(DWORD)handle;
    MessageBoxA(hWnd, str, title, MB_OK);
    return true;
}
```

其中第一个参数用来接收 `window_handle()`。当然，第一个参数也可以选择填 `0`，但是填 `0` 的情况下 MessageBox 不属于游戏窗口，这会导致 MessageBox 不能保持在游戏窗口的置顶。
