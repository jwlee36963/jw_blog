## 项目介绍

### 项目结构

博客的主要部分由 `_posts` 文件夹和 `blog.zip` 压缩包构成。

### 使用方法

1. 在当前目录解压 `blog.zip` 得到 `blog` 文件夹。

2. 在 Obsidian 软件中打开 `_posts` 文件夹，然后进行写作。

3. 最后将 `_posts` 文件夹替换掉 `blog` 中的相应文件夹，在 `blog` 下的 `_posts` 文件夹环境中进行文章的测试部署。 

### 注意事项

- 博客资源分为文章 `_posts` 和站点 `blog.zip`。
- 对于文章资源的修改保存在 `_posts` 文件夹中，每次修改后都要 commit、push。
- 对于站点资源的修改，比如：修改网站的背景图、首页 slogan 和 icon 等，都要将修改后的 `blog` 文件夹压缩为新的 `blog.zip` 替换掉原来的 `blog.zip`，再进行 commit、push。
- git 仓库设置了 gitignore 忽略掉了 `blog` 文件夹。
- `jdeploy_git` `jnew_post` 等 shell 脚本的操作需要安装 nodejs、nodejs/hexo、git 等环境。
- 在 `_posts` 和 `blog/source/_posts` 之间使用 `cp` 命令时应加上 `-p` 选项以保留脚本的权限属性，例如：`cp -rfp _posts blog/source`。
