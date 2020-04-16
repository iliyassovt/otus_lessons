#!/usr/bin/env bash

readonly X=10
readonly Y=10
readonly remembered_last_line_file=./remembered_last_line.txt
readonly output_file=./output.txt
readonly log_file=./myaccess.log


function extract_ip() {
    echo "$1" | awk -F" " '{print $1}'
}
function extract_url() {
    echo "$1" | awk -F" " '{ if ($7 ~ /^\//) print $7}'
}
function extract_date() {
    echo "$1" | awk -F" " '{print $4}' | sed s/[][]//g
}
function extract_http_code() {
    http_code=`echo "$1" | awk -F" " '
    { for (i = 1; i <= 9; i++) 
        { if ($i ~ /^[1-5][0-9][0-9]$/) 
            { 
                print $i
                break
            }
        }
    }'`
    
    [[ ! "$http_code" =~ ^[1-5][0-9][0-9]$ ]] && ( \
        >&2 \
        echo "ERROR: Could not extract http_code from:" $'\n' "$line" \
    )
    echo "$http_code"
}
function tail_from_line() {
    tail -n +"$1" "$2"
}

# lock
lock_file=/var/tmp/nginx_stats
if [[ -f $lock_file ]]; then
    echo script is already running\!
    exit 6
fi
touch $lock_file
trap 'rm -f "$lock_file"; exit $?' INT TERM EXIT


if [ -f $remembered_last_line_file ]; then
    remembered_last_line=`< $remembered_last_line_file`
else
    remembered_last_line=""
fi

if [[ "$remembered_last_line" == "" ]]; then
    start_from=1
else
    # находим запомненную строчку: начнём обработку файла с неё
    remembered_line_with_num=`grep -Fn "$remembered_last_line" "$log_file"`
    if [[ "$remembered_line_with_num" == "" ]]; then
        start_from=1
    else
        start_from=`echo $remembered_line_with_num | awk -F":" '{print $1}'`
        ((start_from++))

    fi
fi

# обрабатываем файл, начиная с последней + 1 обработанной в прошлый раз строчки
declare -A ip_stats
declare -A url_stats
declare -A http_code_stats
declare -a errors
iterations=0
last_line=""
while IFS='' read -r line || [[ -n "$line" ]]
do
    # если начальной даты временнОго диапазона нашего отчета мы пока не имеем,
    # то берём дату первой обрабатываемой строки,
    if [[ "$report_date" == "" ]]; then
        report_date=`extract_date "$line"`
    fi

    http_code=`extract_http_code "$line"`
    [[ "$http_code" -ge 500 ]] && errors+=("$line")
    ((http_code_stats["$http_code"]++))

    ip=`extract_ip "$line"`
    ((ip_stats["$ip"]++))

    url=`extract_url "$line"`
    if [[ -n "$url" ]]; then 
        ((url_stats["$url"]++))
    fi

    ((iterations++))
    last_line="$line"
done < <(tail_from_line $start_from "$log_file")

# echo $iterations
# если все записи в файле логов прочтены то завершаем скрипт
if [[ "$iterations" == 0 ]]; then
    echo "WARNING - All records already have written or log file is empty or has incorrect format"
    # release lock
    rm -f $lock_file
    trap - INT TERM EXIT
    exit 0
fi

# echo -e "\e[0;33mReport since $report_date\e[0m" > $output_file
echo "Report since $report_date" > $output_file
echo "" >> $output_file

echo "--- Most requests from IPs:" >> $output_file
for ip in "${!ip_stats[@]}"
do
    echo "$ip ${ip_stats[$ip]}"
done | sort -rnk2 | awk -F" " '{print $1 " (" $2 " requests)"}' | head -n$X >> $output_file
echo "" >> $output_file

echo "--- Most popular urls:" >> $output_file
for url in "${!url_stats[@]}"
do
    echo "$url ${url_stats[$url]}"
done | sort -rnk2 | awk -F" " '{print $1 " (" $2 " requests)"}' | head -n$Y >> $output_file
echo "" >> $output_file

echo "--- HTTP codes:" >> $output_file
for http_code in "${!http_code_stats[@]}"
do
    echo "$http_code: ${http_code_stats[$http_code]} times" >> $output_file
done
echo "" >> $output_file

echo "--- Errors:" >> $output_file
IFS=$'\n'; echo "${errors[*]}" >> $output_file

echo "SUCCESS - The result you can see in the file 'output.txt' in current directory"

# запоминаем последнюю обработанную строчку
if [[ "$last_line" != "" ]]; then
    echo "$last_line" > $remembered_last_line_file
fi

# release lock
rm -f $lock_file
trap - INT TERM EXIT
