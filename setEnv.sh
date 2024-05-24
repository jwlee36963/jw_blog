#!/bin/bash

git config --local user.name "jw.lee"
git config --local user.email "jwlee36963@gmail.com"
git config --local core.quotePath false
git config --local core.editor "vim"
git config --local core.autocrlf false

# 保持blog/source_posts为最新
# 检查当前路径是否有blog文件夹,有则切换到blog目录
if [ -d "blog" ]; then
  cd blog/source
else
  if [ -f "blog.zip" ]; then
    unzip blog.zip
    cd blog/source
  else
    echo "ERROR:没有blog文件夹和blog.zip文件"
    exit 1
  fi
fi

# 删除_posts目录
if [ -d "_posts" ]; then
  rm -rf "_posts"
  rm -rf img
else
  echo "source目录下没有_posts目录,无需删除."
fi

# 返回上一级目录
cd ../..

# 将_posts目录复制到blog/source目录
if [ -d "_posts" ]; then
  cp -rfp "_posts" "blog/source"
  cp -rf img blog/source
else
  echo "当前路径下没有_posts目录,无法复制."
fi

echo "blog/source/_posts 已刷新"
