#!/usr/bin/env ruby

puts "Start!"

puts  File.readlines(__FILE__)
return

SCRIPT_LINES__ = {}
require 'active_record'
def fun1
#    puts "fun1"
    puts __method__
    puts Kernel.caller
end

class Aaa

    def inherited(с)
	puts "Class Aaa"
    end
end

class Bbb < Aaa
end

Aaa.new
puts Kernel.caller(0)
a = Bbb.new
fun1

puts "++++++++++"
p SCRIPT_LINES__.keys.count