# 依赖 
# brew install ripgrep
# install jq https://stedolan.github.io/jq/

## 杀死之前的进程，alfred自带，不用了
# pid="$(cat pid.txt)"
# nohup kill -9  $pid&>log.log&
# echo $$ > pid.txt

re="$(/usr/local/bin/rg --max-count 1 --ignore-case  --type md --json $1 $search_path |/usr/local/bin/jq '.data.path.text' | grep -v null)"

echo "{\"items\":["
IFS=$'\n'
n=0
for line in $re
do
  n=$((n+1))
  mod=$((n%3))
  if [ $mod = 2 ]; then
    ## 去掉两边的引号
    line="$(echo $line | sed 's/^\"//g')"
    line="$(echo $line | sed 's/\"$//g')"
    ## 文件名
    filename=${line##*/}
    echo "{\"type\": \"file\",\"title\": \"${filename}\",\"subtitle\": \"${line}\",\"arg\": \"${line}\"},"
  fi
done
#if [ $n = 0 ]; then
#  echo "{\"title\": \"没有找到符合条件的文档\"}"
#fi
echo "]}"

# echo re | xargs
#     echo "{\"title\": \"没有找到符合条件的文档\"}"
