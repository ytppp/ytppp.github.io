#!/usr/bin/env sh

# 确保脚本抛出遇到的错误
set -e

# 生成静态文件
npm run build

# 进入生成的文件夹
cd docs/.vuepress/dist

# 登录腾讯云
tcb login

# 上传腾讯云静态网站托管
tcb hosting deploy ./ ./ -e ytpblog-7gkzqqeq731410c7

# 退回开始所在目录
cd -

# 删除部署文件
rm -rf docs/.vuepress/dist

# 提交修改代码
msg="提交修改文章"
git add .
git commit -m "${msg}"
git push origin master