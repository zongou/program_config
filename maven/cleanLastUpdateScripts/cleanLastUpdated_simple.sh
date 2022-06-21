# create by NettQun  
  
# 这里写你的仓库路径  
REPOSITORY_PATH=~/Documents/tools/repository  
echo 正在搜索...  
find $REPOSITORY_PATH -name "*lastUpdated*" | xargs rm -fr  
echo 搜索完 