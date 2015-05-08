#!/bin/bash
# скрипт добавляет в файл .bashrc команду myth0, с помощью которой можно получить eth0 ip

alias myeth0="ifconfig eth0 | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | head -n 1"
reset