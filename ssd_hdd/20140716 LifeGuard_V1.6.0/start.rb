#!/usr/local/bin/ruby
require 'getoptlong'

if `echo $USER`.chomp != 'root'
    puts "ERROR: You must be sudouser"
    exit
end
=begin
parser = GetoptLong.new

parser.set_options(
  ["-s", "--source", GetoptLong::REQUIRED_ARGUMENT]
)

ms =  parser.get
#p ms[1]
if ms[0] == "-s"
    s = ms[1][-1]
else
    puts "Not correct argument"
    exit
end
ss = {}
if s == 'a'
    ss['host'] = 0
    ss['sdX'] = 'a'  
end
p s

=end
puts "Start"

#scan device sata0
#`echo "- - -" > /sys/class/scsi_host/host0/scan`

#read smart for /dev/sda
`./LifeGuard_V1.6.0_for_Linux /dev/sda >> bad_hdd.txt`

#power down the sata ssh
#`echo 1 > /sys/block/sda/device/delete`

puts "Finish"