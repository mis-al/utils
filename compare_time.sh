#!/bin/bash
# Сравнение времен серверов посредством получения его через ssh.
# Предварительно настроет доступ по ключу
my_login='root'
my_netw='172.17.0.'
#echo ""
# ssh "$my_login"@"$my_netw"22 'date' &>/dev/null &
# ssh "$my_login"@"$my_netw"26 'date' &>/dev/null &
ssh "$my_login"@"$my_netw"22 'date' &
ssh "$my_login"@"$my_netw"26 'date' &
wait