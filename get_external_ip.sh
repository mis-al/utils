#!/bin/bash
# скрипт добавляет в файл .bashrc команду myip, с помощью которой можно получить внешний ip

res=`dpkg --get-selections | grep '^curl' | grep install`
if [ -z "$res" ]
then
    echo "Required installing curl"
    sudo apt-get install curl -y
fi
reset
alias myextip="curl -s 2ip.ru | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | head -n 1"
