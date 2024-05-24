---
title: Vscode、Clangd、RemoteSSH——环境配置
index_img: /img/index/clangd.png
banner_img: /img/banner/vscode.jpg
date: 2024-05-24 17:01:21
updated: 2024-05-24 17:01:21
tags:
- clangd
- lsp
categories:
- DIY
---

> 使用场景：Windows 端 Vscode 使用 RemoteSSH 插件远程连接到 fedora 系统，并且项目源码是在 fedora 上。

## 1 安装 bear

`sudo dnf install bear`

![](7c7eb2ee8ae3d4cb5f21a19fc1085371_MD5.jpeg)

## 2 安装 clang、clangd

`sudo dnf install clang`

`sudo dnf install clang-tools-extra`

![](9b3d43fdbf79395f56ea1a63d0976da1_MD5.jpeg)

## 3 配置 VScode Clangd 插件

> 需要先将 VScode 中的所有 C/C++ 插件禁用或卸载

在 VScode 中打开设置：

![](911d5ef43a63ee4d32ac535e675f78c1_MD5.jpeg)

我是在远程中设置的，打开远程的 settings. json 文件，配置如下：

```json
{
    "clangd.path": "/usr/bin/clangd",
    "clangd.arguments": [
        "--background-index",
        "--compile-commands-dir=/home/jw/develop/linux",
        "-j=4",
        "--query-driver=/usr/bin/aarch64-linux-gnu-gcc",
        "--clang-tidy",
        "--clang-tidy-checks=performance-*,bugprone-*",
        "--all-scopes-completion",
        "--completion-style=detailed",
        "--header-insertion=iwyu",
        "--pch-storage=disk",
        "--compile-commands-dir=${workspaceFolder}",
        "--background-index",
        "--completion-style=detailed",
        "--header-insertion=never"
    ],
    "clangd.fallbackFlags": [
        "-I/home/jw/develop/linux/include",
        "-I/home/jw/develop/linux/arch/arm64/include",
        "-I/home/jw/develop/linux/arch/arm64/include/generated/"
    ]
}
```

- "clangd.path" 使用 `which clangd` 命令查看：![](878188bbfc108b4d84d3c3e79ceded27_MD5.jpeg)
- "clangd.arguments" 的 --compile-commands-dir 填你的项目源码根目录
- "clangd.arguments" 的 --query-driver 填交叉编译器路径
- "clangd.fallbackFlags" 中 `/home/jw/develop/linux` 替换成你的项目路径
- "clangd.fallbackFlags" 中 `arch/arm64/include` 、`arch/arm64/include/generated/` 使用 arm64 架构，根据自己的开发板架构来

## 4 编译项目生成 `compile_commands.json` 文件

重新编译 kernel 镜像，先 clean 项目再编译：

```shell
make distclean
make bcm2712_defconfig    //根据你的开发板而定
bear -- make Image -j8    //Image、zImage还是uImage根据你的开发板而定
```

编译完后会在项目根目录下生成 `compile_commands.json` 文件：

![](e66215266218dbfc3e0ae4402749022f_MD5.jpeg)

将所有的 `/usr/bin/gcc` 替换成你的交叉编译器，我的是 `/usr/bin/aarch64-linux-gnu-gcc` VIM 中使用 `:%s#/usr/bin/gcc#/usr/bin/aarch64-linux-gnu-gcc#g` 命令替换。

### 4.1 创建 `.clangd` 文件

在项目根目录下创建 `.clangd` 文件，内容如下：

```txt
CompileFlags:
    Add:
        [-I, "/usr/include"]
    Remove: 
        [
            -fno-allow-store-data-races,
            -fconserve-stack,
            -mabi=lp64
        ]
```

其中的 Remove 是为了忽略 gcc 和 clang 编译器不兼容而出现的错误。

## 5 VScode 打开项目

使用 VScode 打开项目：

![](77b2fe94fef24678a77591234969a3f5_MD5.jpeg)

ok，此时就可以代码提示和补全了！

### 5.1 处理一些问题

如果配置后不起效，可以在 clangd 的 log 中查看哪里的问题：

![](f195d476a19cf7c2c9d44011984dc37f_MD5.jpeg)

![](42df14c724748d944e53139e38785f60_MD5.jpeg)

具体的问题可以在网上搜索下。

> 参考文章：[VSCode 使用 clangd 构建 Linux 驱动开发环境](https://blog.csdn.net/Telly_/article/details/134289358)、[clangd: Couldn‘t build compiler instance](https://blog.csdn.net/zhanzheng520/article/details/135103043)
