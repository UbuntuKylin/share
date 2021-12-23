# MIT License
# Copyright (c) [2021] [CodeSH]
# 优麒麟团队祝大家圣诞快乐！

# 加载背景音乐
if [ -f "christmas.mp3" ];then
  mplayer -loop 0 ./christmas.mp3 < /dev/null > /dev/null 2>1 & 
else
  wget https://www.ubuntukylin.com/public/mp3/christmas.mp3 -O christmas.mp3 --no-check-certificate;
  mplayer -loop 0 ./christmas.mp3 < /dev/null > /dev/null 2>1 & 
fi


# 清空屏幕
trap "tput reset; tput cnorm; exit" 
clear

# 获取窗口的行数和列数
LINES=$(tput lines)
COLUMNS=$(tput cols)
strTree=''
declare -A snowflakes
declare -A lastflakes

# 渲染几种不同的树
tree1=''
tree2=''
tree3=''
tree4=''
tree5=''

# 生成树
function tree() {
	# 接收传进来的参数
	flag="$1"
	# 每行前面的空格
	lineSpace=''
	# 初始化树
	strTree=''
	# 生成树的字符串
	for ((i=1; i<$((LINES)); i+=2))
	{
		lineSpace=''
		for ((k=1; k<=$((COLUMNS/2-i)); k++)) {
			lineSpace=$lineSpace'\x20'
		}
		for ((j=1; j<=i*2; j++)) {
			if [ $((RANDOM%8)) -lt 3 ];
				then
					lineSpace=$lineSpace'\033['$((RANDOM%7+30))'mo\033[0m'
			else lineSpace=$lineSpace'\033[32m*\033[0m'
			fi				
		}
		strTree=$strTree'\n'$lineSpace
	}
	
	# 树干以及祝福语
	for ((i=1; i<=6; i++))
	{
		lineSpace=''
		for ((j=1; j<=$((COLUMNS/2-5)); j++)) {
			lineSpace=$lineSpace'\x20'
		}
		if [ $i -lt 5 ];
			then
				strTree=$strTree'\n'$lineSpace'\033[33m*********\033[0m'
		fi
		if [ $i -eq 5 ];
			then
				lineSpace=''
				for ((j=1; j<=$((COLUMNS/2-8)); j++)) {
					lineSpace=$lineSpace'\x20'
				}
				strTree=$strTree'\n'$lineSpace'Merry Christmas'
		fi
		if [ $i -eq 6 ];
			then
				lineSpace=''
				for ((j=1; j<=$((COLUMNS/3-5)); j++)) {
					lineSpace=$lineSpace'\x20'
				}
				strTree=$strTree'\n'$lineSpace'Ubuntu Kylin will be with you forever'
		fi
		
	}

	case "$flag" in
	"1")
		tree1=$strTree
		;;
	"2")
		tree2=$strTree
		;;
	"3")
		tree3=$strTree
		;;
	"4")
		tree4=$strTree
		;;
	"5")
		tree5=$strTree
		;;
	esac
	

}

tree 1
tree 2
tree 3
tree 4
tree 5

# 下雪
function move_flake() {

    i="$1"
    if [ "${snowflakes[$i]}" = "" ] || [ "${snowflakes[$i]}" = "$LINES" ]; then
        snowflakes[$i]=0
    else
        if [ "${lastflakes[$i]}" != "" ]; then
            printf "\033[%s;%sH \033[1;1H " ${lastflakes[$i]} $i
        fi
    fi

	printf "\033[%s;%sH\e[1;30m*\e[0m\033[1;1H" ${snowflakes[$i]} $i

    lastflakes[$i]=${snowflakes[$i]}
    snowflakes[$i]=$((${snowflakes[$i]}+1))
	
}

# 疯狂下雪
while :
do
	# 每次打印一种树
	case "$(($RANDOM%5))" in
	"1")
		echo -e $tree1
		;;
	"2")
		echo -e $tree2
		;;
	"3")
		echo -e $tree3
		;;
	"4")
		echo -e $tree4
		;;
	"5")
		echo -e $tree5
		;;
	esac

    i=$(($RANDOM % $COLUMNS))

    move_flake $i

    for x in "${!lastflakes[@]}"
    do
        move_flake "$x"
    done
    sleep 0.1
	
done
