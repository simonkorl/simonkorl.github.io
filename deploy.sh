#!/usr/bin/env sh

# ��ȡ��ǰ������ʱ��
current_datetime=$(date +"%Y-%m-%d %H:%M:%S")

git add .
git commit -m "update article at $current_datetime"
git push
