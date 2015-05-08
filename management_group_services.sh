#!/bin/bash

# Скрипт позволяет управлять группой сервисов.
# Например, в каталоге /etc/init есть сервиса group1_s1, group1_s2, group1_s3
# Изменим имя группы для скрипта: sg_name="group1"
# Запускаем: management_group_services.sh


sg_name="group1" #имя группы сервисов

#echo "start!"
if [ `whoami` != 'root' ]
then
    echo "Вы должны быть суперпользователелм"
    echo "Повторите попытку снова добавив 'sudo' перед командой"
    exit 1 
fi

cd /etc/init
if [ "$1" == "start" ] || [ "$1" == "stop" ] || [ "$1" == "restart" ] || [ "$1" == "status" ]
then
    for service in `ls -1 $sg_name* | grep . | tr "." "\n" | grep $sg_name`
    do
	$1  $service
    done
else 
    echo "Неправильный параметр: $1"
    echo "Доступны только 'start' 'stop' 'restart' 'status'  параметры"
fi