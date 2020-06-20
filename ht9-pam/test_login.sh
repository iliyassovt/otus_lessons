#!/usr/bin/env bash

prazdniki=(1511 0101 0201 0301 0401 0501 0601 0701 0801 2302 \
2402 2502 0803 0903 1003 1103 2904 3004 0105 0205 0905 \
1006 1106 1206 0311 0411 0511 3012 3112)

user_group=`id $PAM_USER | awk ' {print $3} ' | awk -F"(" ' {print $2} ' | awk -F")" ' {print $1} '`

if [[ $user_group = "admin" ]]
  then
    exit 0
elif [[ $user_group = "myusers" ]]
  then
    if [[ " `date +%u` " > " 5 " ]]
      then
        exit 1
    elif [[ " ${prazdniki[@]} " =~ " `date +%d%m` " ]]
      then
        exit 1
    else
      exit 0
    fi
else
  exit 1
fi