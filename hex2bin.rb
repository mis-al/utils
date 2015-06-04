#!/usr/bin/env ruby
# encoding: utf-8

# convert hex to bin
# idea: Alexandr Fedorenko

unless ARGV[0]
    puts "Error argument!"
    puts "Example: ./#{__FILE__} HEXSTRING [file_for_save_bin_key]"
    exit 1
end

KEY_FILENAME = ARGV[1] || 'key'
str = ARGV[0]
str.scan(/../).map(&:hex)
res = [str].pack('H*').unpack('C*').pack('C*')
if res
    File.open("#{KEY_FILENAME}.bin", 'w') do |f|
        f.write res
    end
else 
    puts "Wrong argument: #{res}"
    exit 1
end
