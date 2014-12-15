#!/usr/bin/ruby

#
#
#
require 'fileutils'

p imgsize = 300 # in MB
p imgversion = "version"
p imgname = "./image/bootloader-#{(IO.read("./#{imgversion}").to_i + 1)}"
p booter_tmp = "/tmp/" + rand(99999).to_s
p loader_tmp = "/tmp/" + rand(99999).to_s
p booter_dir = "./booter"
p loader_dir = "./loader"
puts "Start"


puts "Create img file"
if imgsize > 1000 || imgsize < 100
  puts "ERROR: big file!"
  exit
end

`sudo dd if=/dev/zero of="#{imgname}" bs=1M count="#{imgsize}"`
exit if 0 != $?.exitstatus

# если вдруг разделы примонтированы
#puts "Umount devices"
#`sudo umount "#{sdcard}1"`
#`sudo umount "#{sdcard}2"`
#`sudo dd if=/dev/zero of="#{sdcard}" count=1 bs=4M`

puts "Create part1"
`(echo o; echo n; echo p; echo 1; echo 8192; echo +20M; echo w) | sudo fdisk "#{imgname}"`

puts "Create part2"
`(echo n; echo p; echo 2; echo 49152; echo "+#{imgsize-30}M"; echo w) | sudo fdisk "#{imgname}"`
`partprobe`


puts "Attached to the file /dev/*****"
dev = `sudo losetup -f --show "#{imgname}"`.chomp
if dev.include? "/dev/loop"
  `sudo kpartx -a "#{dev}"`
  if !$?.exitstatus
    puts "ERROR: kpartx"
    exit
  end
else 
  puts "ERROR: losetup"
  `sudo losetup -d "#{dev}"`
  exit
end

#p `kpartx -d "#{dev}"`
#p `partprobe`
#p `sudo kpartx -a "#{dev}"`
#if !$?.exitstatus
##  puts "ERROR: kpartx"
 # exit
#end
#  
ch_dev = "/dev/mapper/" + dev.split('/')[-1]
puts "Format part"
`sudo mkfs.vfat "#{ch_dev}p1" -F 16 -n BOOTER`
`(echo a; echo 1; echo t; echo 1; echo c; echo w) | sudo fdisk "#{dev}"`
`partprobe`
`sudo mkfs.ext3 "#{ch_dev}p2" -L LOADER`
`partprobe`
puts "Mount"
FileUtils.mkdir booter_tmp unless Dir.exist? booter_tmp
FileUtils.mkdir loader_tmp unless Dir.exist? loader_tmp 

if !File.exist?( booter_dir ) || !File.exist?( loader_dir )
  puts "Error path #{booter_tmp} or #{loader_tmp}"
  return
end
if `mount`.include? ch_dev
  `sudo umount "#{ch_dev}p1"`
  if `mount`.include? ch_dev
    `sudo umount "#{ch_dev}p2"`
  end
end

puts "Mount part1"
p `sudo mount "#{ch_dev}p1" "#{booter_tmp}"`
if !$?.exitstatus
  puts "ERROR: mount"
  exit
end
puts "Mount part1"
p `sudo mount "#{ch_dev}p2" "#{loader_tmp}"`
if !$?.exitstatus
  puts "ERROR: mount"
  exit
end

puts "Copy files"
`sudo cp -R "#{booter_dir}"/* "#{booter_tmp}"`
`sudo cp -R "#{loader_dir}"/* "#{loader_tmp}"`

puts "umount!"
p `sudo umount "#{ch_dev}p1"`
p `sudo umount "#{ch_dev}p2"`
sleep 3
p `kpartx -d "#{dev}"`
p `losetup -d "#{dev}"`

puts "Delete tmp dir"

FileUtils.rmdir booter_tmp if Dir.exist? booter_tmp
FileUtils.rmdir loader_tmp if Dir.exist? loader_tmp 

puts "Increment number version"
File.open("./version","r+") {|f| f.puts (IO.read("./#{imgversion}").to_i + 1)}
puts "OK"







