#!/bin/bash

# 参数：目录的绝对路径；例如：'西==瓜[[豆==芽'
# 功能：生成'西==瓜[[豆==芽.file'，其中包含该目录的所有子目录
function genSubdirOfNameToFile() {
	G_PARAM1=${1//[[//}
	G_PARAM=${G_PARAM1//==/\\ }	
	G_PREFIX=$1
	G_FILENAME=${1##*[[}
# 将路径前缀存入文件的首行
	echo $G_PREFIX > $G_FILENAME.file
	echo $G_PARAM | xargs bypy list > tmp
	sed -i 1d tmp
	sed -i s/\ $//g tmp
	sed -i s/\ /==/g tmp
	cat tmp | awk -F == '{$NF=$(NF-1)=$(NF-2)=""; print $0}' &>> $G_FILENAME.file && rm -f tmp
}

# 参数：西__瓜[[豆__芽
# 功能：生成'西__瓜[[豆__芽.file'中每一行目录对应的文件
function recursion() {
	genSubdirOfNameToFile $1

	R_FILE=${1##*[[}.file
	sed 1d $R_FILE | while read line; do
		R_FLAG=${line:0:1}
		R_DIRNAME1=${line:2}
		# 特殊字符处理
		R_DIRNAME2=${R_DIRNAME1// /==}
		R_DIRNAME3=${R_DIRNAME2////[[}
		R_DIRNAME=${R_DIRNAME3//\'/\\\'}

		R_FILENAME=${1##*[[}
		R_PREFIX=`head -1 $R_FILENAME.file`

		if [ $R_FLAG == 'D' ]; then
			R_WHOLEDIRNAME=$R_PREFIX[[${R_DIRNAME//\ /\\ }
			recursion $R_WHOLEDIRNAME
		else
			echo $R_PREFIX[[$line | awk '{$NF=""; print $0}' >> /opt/WangKe.txt
		fi
	done
}

#ROOTDIR='西==瓜[[豆==芽'
#ROOTDIR='17年赛普健身学院文件'
ROOTDIR='test'
if [ ! -d WangKe-tmp ]; then
	mkdir WangKe-tmp
fi
pushd WangKe-tmp
#genSubdirOfNameToFile $ROOTDIR
recursion $ROOTDIR
popd
