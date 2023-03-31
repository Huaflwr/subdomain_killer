#!/bin/bash
#Author:the_whovian
#EditDateForFirstTime:2023-03-30
#LastModifiedDate:2023-03-31

startTime=$(TZ=UTC-8 date +%s)
workPath=`pwd`

divider='echo -e "\n-------------------------我是分割线-------------------------\n"'
eval $divider
echo -e "[*] 使用方法：-d [domain] 或 -f [DOMAIN_FILE]"
echo -e "[*] 作者：the_whovian"
echo -e "[*] 仓库地址，关注更新：https://github.com/Huaflwr/subdomain_killer \n"
echo "[*] 当前时间是：$(TZ=UTC-8 date +%F-%T)"
eval $divider
echo -e "[*] 开始更新扫描器poc模板..."
$workPath/nuclei -ut

function lookingForSubdomainAssets(){
    #爬取域名部分
    eval $divider
    echo -e "[*] 当前扫描目标：$1"
    echo -e "[*] 开始爬取 $1 子域名..."
    mkdir $1
    #$workPath/ksubdomain e -d $1 -od --silent -o $1/subs.txt
    $workPath/subfinder -d $1 --silent -o $1/subs_found.txt
    echo -e "\n[+] $1 找到子域名 $(wc -l < $1/subs_found.txt) 个"

    #探测存活部分
    eval $divider
    echo -e "[*] 开始获取 $1 子域名的标题..."
    $workPath/httpx -l $1/subs_found.txt -title -tech-detect -status-code -exclude-cdn -no-color -follow-redirects -fl 0 -mc 200,302 -o $1/subs_title.txt
    echo -e "\n[+] $1 找到存活的子域名 $(wc -l < $1/subs_title.txt) 个"
    ##只保存存活的域名本身，不包含标题等信息，因为nuclei等扫描器只接受域名/IP输入
    grep -E -o "http.+? " $1/subs_title.txt | sed 's/ //g' > $1/subs_lived.txt

    #漏洞扫描部分
    eval $divider
    echo -e "[*] 开始扫描 $1 子域名的漏洞..."
    ##可以在这里添加其他扫描器，建议输出的扫描结果文件格式为：$1/vul_[SCANNER_NAME].txt
    $workPath/nuclei -l $1/subs_lived.txt -as -rl 200 -bs 35 -c 30 -mhe 10 -severity medium,high,critical -o $1/vul_nuclei.txt
    
    ##这里汇总扫描器的扫描结果
    cat $1/vul*.txt | grep -E "MEDIUM|HIGH|CRITICAL|medium|high|critical" > $1/vul_all.txt
    if [ -s $1/vul_all.txt ];then
        eval $divider
        echo -e "[*] $1 子域名的漏洞如下："
        cat $1/vul_all.txt
    else
        eval $divider
        echo -e "[-] 没有发现子域名的漏洞"
    fi
}


if [[ "$1" == "-d" ]];then
    lookingForSubdomainAssets $2
elif [[ "$1" == "-f" ]];then
    for line in `cat $2`
    do
        lookingForSubdomainAssets $line
    done
else
    echo -e "\n[-] 请输入目标域名或含目标的文件。使用方法：-d [domain] 或 -f [DOMAIN_FILE]"
fi

endTime=$(TZ=UTC-8 date +%s)
sumTime=$[ $endTime - $startTime ]
eval $divider
echo -e "[*] $2 扫描已结束，脚本共运行 $sumTime 秒"