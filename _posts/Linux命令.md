---
title: Linux命令
index_img: /img/index/linux_shell.jpg
tags:
  - shell
abbrlink: 82734d8
date: 2024-02-04 11:27:34
updated: 2024-02-04 16:55:46
copyright: false
---
### 1. ls

| 参数 | 描述 |
| :--: | :--- |
| -a | 显示所有文件及目录 (包括 `.` 开头的隐藏文件) |
| -A | 通 `-a` ，但不列出 `.` 、`..` |
| -F | 列出文件名后加一符号 (可执行文件加 `*` ，目录加 `/` ) |
| -l | 列出详细信息(文件形态、权限、拥有者等) |
| -t | 按照**建立时间**排序(时间越近越靠前) |
| -R | 递归显示当前目录中的所有文件和子目录 |

### 2. cp

| 参数 | 描述 |
| :--: | :--- |
| -a | 在复制目录时使用，它保留链接、文件属性，并复制目录下的所有内容 |

### 3. find

> **[find 详解](https://blog.csdn.net/wq1205750492/article/details/124497195)**

![](22602bf26de9816e5a2503cec3564e1b_MD5.jpeg)

直接输入 `find` ：

![](e1b3c2286a0efb6814362d755a1c1089_MD5.jpeg)

`find` 文件夹：

![](e37fbd3c6f1eeeeb2b71e2f185dda897_MD5.jpeg)

### 4. grep

grep.........

### 5. wget

| 参数 | 描述 |
| :--: | :--- |
| -O | 指定下载的文件名 |
| -b | 下载大文件时使用`-b`后台下载 |
| -i | 下载多个文件 |

#### wget -O

`wget -O frps_linux64.tar.gz https://github.com/fatedier/frp/releases/download/v0.54.0/frp_0.54.0_linux_amd64.tar.gz`

#### wget -b

`wget -b http://www.minjieren.com/wordpress-3.1-zh_CN.zip`

#### wget -i

```sh
$: cat URLlist.txt
$: url1
$: url2
$: url3
$: wget -i URLlist.txt
```

