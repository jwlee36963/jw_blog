---
title: frp内网穿透--使用记录
index_img: /img/index/frp_index.png
banner_img: /img/banner/frp_banner.png
tags:
  - frp
  - 内网穿透
  - ssh
  - systemd
categories:
  - DIY
abbrlink: 75cc0c49
date: 2024-02-01 13:56:42
updated: 2024-02-01 14:11:02
---

> 使用内网穿透进行远程 ssh 访问

如果A、B电脑不在同一局域网的情况下，并且都没有公网IP，A、B之间要想访问就需要内网穿透了

一种方案是购买服务商提供的内网穿透工具，如 cpolar：

![](3c199aac7cbfd9da40b7b055fc837520_MD5.jpeg)

固定端口号套餐149/年，不用折腾。

另一种方案是购买一个有公网 IP 的服务器做“桥梁”，但是最低配的轻量应用服务器价格都在一百左右，不是特别划算。最近年底腾讯云和阿里云活动，入门的轻量应用服务器价格60几块，果断入手~~~

![](114f2d6e1fe7bfce68d305524913e43c_MD5.jpeg)

## 1. 事先准备

- 具有公网 IP 的服务器(ubuntu) —— 👌
- 发起访问的电脑(windows) —— 👌
- 被访问的电脑(Ubuntu) —— 👌

## 2. 下载 frp

frp GitHub 项目地址： https://github.com/fatedier/frp

![](833eaec4fe82ab68b6b75e32e30e49ea_MD5.jpeg)

分别针对 `具有公网IP的服务器` 和 `被访问的电脑` 下载相应的 frp 系统版本。我这里的两个主机都是 Ubuntu 系统，所以下载 `frp_0.53.2_linux_amd64.tar.gz` 到两个主机上，*注意：每个主机上都有一个相同版本的 `frp_0.53.2_linux_amd64.tar.gz`。*

解压后，对于 `具有公网IP的服务器` 使用的是 frps (frp server)：

![](5ee686c92f4042c799cc21d7b58e6761_MD5.jpeg)

对于 `被访问的电脑` 使用的是 frpc (frp client)：

![](6ab1a7e48358d10033cd8c100bee4dbb_MD5.jpeg)

## 3. 修改 frp 配置文件

### 3.1 `具有公网IP的服务器` 的 `frps.toml`

![](afd713590a8abd299f012d8d7932c42d_MD5.jpeg)

默认的就行~

### 3.2 `被访问的电脑` 的 `frpc.toml`

![](b53fa024875ecaa01d19bbf7c1ed6e0e_MD5.jpeg)

- `serverAddr`：修改为 `具有公网IP的服务器` 的 IP
- `name`：随意填
- `type`：ssh 访问填 **tcp** 
- `remotePort`：默认的 6000 就行

![](cb48e711cc8de269bbc0f3592df21c0a_MD5.jpeg)

## 4. 设置开机自启

使用 `frps -c frps.toml`、`frpc -c frpc.toml` 来运行 frp 服务。但是每次开机后都要在两台主机上分别运行 frp 服务，比较麻烦。使用 systemd 来实现 frp 服务的开机自启。

分别在 `具有公网IP的服务器` 和 `被访问的电脑` 的主机上使用 systemd 配置各自的 frp 开机自启服务。

### 4.1 `具有公网IP的服务器` 的 `frps.service`

`sudo vim /etc/systemd/system/frps.service`

```txt
[Unit]
Description=frp server
After=network.target network-online.target syslog.target
Wants=network.target 

[Service]
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/你的路径/frps -c /你的路径/frps.toml

[Install]
WantedBy=multi-user.target
```

>只需要针对你的路径修改 \[Service\] 下的 `ExecStart`，其余的不用修改

![](fc984d1f1c751c24e90b6b1c29fb4b93_MD5.jpeg)

然后运行 `sudo systemctl daemon-reload` 和 `sudo systemctl enable --now frps.service` 以启用 frps 开机自启。

### 4.2 `被访问的电脑` 的 `frpc.service`

`sudo vim /etc/systemd/system/frpc.service`

```txt
[Unit]
Description=frp client 
After=network.target network-online.target syslog.target
Wants=network.target 

[Service]
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/你的路径/frpc -c /你的路径/frpc.toml

[Install]
WantedBy=multi-user.target
```

>只需要针对你的路径修改 \[Service\] 下的 `ExecStart`

![](35b5acb29b8ff252d159c3106436a010_MD5.jpeg)

然后运行 `sudo systemctl daemon-reload` 和 `sudo systemctl enable --now frpc.service` 以启用 frpc 开机自启。

## 5. 添加端口规则

需要在 `具有公网IP的服务器` 的控制台防火墙里放行 6000、7000 端口：

![](38e6254556ea3130f974c07fc9701bbe_MD5.jpeg)

## 6. 登录使用

在 `发起访问的电脑` 端远程 ssh 访问 `被访问的电脑` 端。

在 `发起访问的电脑` 端使用 ssh 工具登录 `具有公网IP的服务器` 。**注意：登录地址是你购买的服务器的 IP，用户名是 `被访问的电脑` 端的用户名，密码是 `被访问的电脑` 端的密码，端口是 `6000` 。**

例如：

![](36ec4a0fd428863e0efeee2536b28cde_MD5.jpeg)
