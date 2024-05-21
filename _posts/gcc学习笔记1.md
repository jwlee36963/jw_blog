---
title: gcc学习笔记1
index_img: /img/index/gnu_gcc.png
banner_img: /img/banner/c_program.jpg
tags:
  - GNU
  - GCC
  - C
categories:
  - gcc学习
abbrlink: 4e3171ca
date: 2024-02-05 15:05:35
updated: 2024-02-05 16:41:04
---

> 此文章是 gcc 学习笔记，[学习视频](https://www.bilibili.com/video/BV1Y8411M7fp/?p=3&spm_id_from=pageDriver&vd_source=d28f6fad4261fe5abca485f4a556dbc1)

## 1 多文件编译

目录结构如下：

![](fc81ec4f3b390a718d9f921c56e31774_MD5.jpeg)

`main.c`（主程序）：

```c
#include <stdio.h>
#include "hello.h"
int main()
{
        hello("呵呵，ojbk");
        return 0;
}
```

`hello.h`（函数的声明）：

```c
void hello(const char* str);
```

`hello.c`（函数的实现）：

```c
#include <stdio.h>
#include "hello.h"
void hello(const char* str)
{
        printf("%s\n", str);
}
```

使用 `gcc -Wall main.c hello.c -o hehe` 命令进行多文件编译：

![](8af5eedd71c05782187f5b0b01ad29ca_MD5.jpeg)

### 1.1 `hello.h`

在文件目录中有 `hello.c`、`hello.h` 和 `main.c`，但是在使用 `gcc` 编译时没有包含 `hello.h`

在 `main.c` 中的第二行 include 了 `hello.h`，`gcc -Wall main.c hello.c -o hehe` 在执行这条命令时，gcc 读取到 `main.c` 源文件中的第二行，就会去找 `hello.h` 文件自动包含进来，所以不用包含头文件。

#### 1.1.1 `" "` 和 `< >`

在 `main.c` 中使用了 `include <stdio.h>` 和 `include "hello.h"`，这两种不同的包含符号有什么区别？

`" "` 表示编译器首先会到当前路径（被编译的源文件所在的路径）下搜索这个头文件，找不到再去**系统头文件目录**。

而 `< >` 是直接去**系统头文件目录**下搜索头文件。

> 头文件目录（对于 Linux 系统）
> /usr/include：系统上的标准头文件目录
> /usr/local/include: 本地安装的软件包可能会将头文件放置在这个目录中

### 1.2 另外

在上述源文件中，`hello.c` 中的 `include "hello.h"` 可以删除，使用 `gcc -Wall main.c hello.c -o hehe` 编译时没有任何问题，为什么？

当 `main.c` 中包含了 `hello.h` 头文件时，这个头文件中的声明 `void hello(const char* str);` 告诉编译器有一个名为 `hello` 的函数，但是并没有提供该函数的具体实现。具体的实现在 `hello.c` 文件中。

编译器在编译 `main.c` 时，会查看 `#include "hello.h"`，这会将 `hello.h` 文件的内容插入到 `main.c` 中。然后编译器会在 `main.c` 中找到函数声明 `void hello(const char* str);`。由于这只是一个声明，编译器并不知道函数的具体实现。

**当你最后执行链接阶段（使用 `gcc main.c hello.c -o hello`）时，编译器会查找 `hello` 函数的实现。** 这时，编译器看到了 `main.c` 中的调用 `hello("呵呵，ojbk");`，然后会在整个工程中搜索包含了 `hello` 函数实现的文件。**由于你同时编译了 `hello.c`，所以编译器找到了 `hello` 函数的实现。** —— *正是因为同时将 `main.c` 和 `hello.c` 放在一起编译（`gcc main.c hello.c -o hello`）所以才不报错。*

最终，链接器将 `main.o` 和 `hello.o` 这两个目标文件合并，生成了可执行文件 `hello`。


