#!/bin/bash
puts "Start"

#scan device sata0
# физический номер подключенного диска
# sata0 = host0
# иногда нумерация sata на мат. плате начинается с 1
# тогда sata1 = host0
#`echo "- - -" > /sys/class/scsi_host/hostX/scan`

#read smart for /dev/sda
`./LifeGuard_V1.6.0_for_Linux /dev/sdX

#power down the sata
echo 1 > /sys/block/sdX/device/delete

puts "Finish"
