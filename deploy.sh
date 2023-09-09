hexo generate
cp -R public/* .deploy/dilidonglong.github.io
cd .deploy/dilidonglong.github.io
git add .
git commit -m “update”
git pull --rebase origin master
git push origin master