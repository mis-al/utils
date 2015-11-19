#!/usr/bin/env ruby

# сканирует и выводит список ip адресов хостов подключенных к сети
# сканирование происходит дважды.  С подключенным устройством, ip которого надо узнать
# и с отключенным от сети устройством.

range = ARGV[0] || 255
puts "Connect ethernet cable to computer port and press any key"
STDIN.gets
f1 =  `nmap -sP 192.168.4.1-#{range}`.scan(/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/)

puts "Remove ethernet cable from computer port and press any key"
STDIN.gets
f2 = `nmap -sP 192.168.4.1-#{range}`.scan(/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/)

puts "List detected ip address: #{f1 - f2}"