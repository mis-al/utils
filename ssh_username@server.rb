#!/usr/bin/env ruby
# encoding: utf-8

# первый раз скрипт запускается непосредственно сам: ./file_name
# следующи1 запуск осуществляется непосредственно через имя prg_name
# example: s r 39 => ssh root@192.168.4.39
# example: s r 23.39 => ssh root@192.168.23.39
# example: s s test.by => ssh support@test.by

path_to_file = File.expand_path(__FILE__)
prg_name = 's'
run_dir = '/usr/bin/'
prg = run_dir + prg_name
unless File.exist? prg
  `sudo ln -s  #{path_to_file} #{prg}`
  exit 0
end

if ARGV[0].nil? || ARGV[0].nil?
  puts "Error argument"
  exit 1
end

username =
    case ARGV[0]
      when 's', 'support'
        'support'
      when 'r', 'root'
        'root'
      when 'm', 'mis-al'
        'mis-al'
      when /^\w(\w|\-|\_){1,30}[^\-|\_]$/ # user-name_11
        ARGV[0]
      else
        puts "Error argument: #{ARGV[0]}"
        exit 1
    end
server =
    case ARGV[1]
      when /^\d{1,3}$/ # 44
        '192.168.4.' + ARGV[1]
      when /^\d{1,3}\.\d{1,3}$/ # 33.44
        '192.168.' + ARGV[1]
      when /\A(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})\Z/ # 11.22.33.44
        ARGV[1]
      when /^\w(\w|\.|\-|\_){1,30}[^\.\-]$/ # ex-ample.ser_ver
        ARGV[1]
      else
        puts "Error argument: #{ARGV[1]}"
        exit 1
    end
options = ARGV[2] || ''

system "ssh #{username}@#{server} #{options}"


