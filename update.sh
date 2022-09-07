# 如果没有消息后缀，默认提交信息为 `:pencil: update content`
info=$1
if ["$info" = ""];
then info=":pencil: update content"
fi
git add -A
git commit -m "$info"
git push origin hexo
# 更新博客
hexo clean
hexo g
hexo d
# 此后更新的话，只需要在终端执行 sh update.sh 即可。