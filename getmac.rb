#!/usr/bin/env ruby 

# вытаскивает мак адреса регулярным выражением

ifconfig = `ifconfig eth0`
#p ifconfig = "MatchData 00:24:8c:f7:8a:a3 1:8aMatchData 55:24:8c:f7:7a:a3 1:8a"
res = ifconfig.scan /(\w{2}\:\w{2}\:\w{2}\:\w{2}\:\w{2}\:\w{2})/

puts res.first.join