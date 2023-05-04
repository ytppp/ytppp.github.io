#!/usr/bin/env sh

# 确保脚本抛出遇到的错误
set -e

# 生成静态文件
npm run build

# 登录腾讯云
tcb login

# 上传腾讯云静态网站托管
tcb hosting deploy public -e blog-0gleoc95ae6da80d

# 删除部署文件
rm -rf public

# 提交修改代码
msg="deploy"
git add .
git commit -m "${msg}"
git push origin main