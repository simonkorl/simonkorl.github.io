#!/usr/bin/env sh

# 获取当前日期与时间
current_datetime=$(date +"%Y-%m-%d %H:%M:%S")

git add .
git commit -m "update article at $current_datetime"
git push
