#!/usr/bin/env ruby
require 'fiber'
puts "Start!"

class Aaa

    attr_accessor :var, :b

    def initialize
	@var=1
    end
    def fun1
	@b = Fiber.new do
	    while true
	        puts "var: #{@var}"
	        sleep 1
	    end
	end
	@b.resume
    end
end

@a = Aaa.new
#p @a.b.alive?

Thread.new do 
    puts "start thread"
    puts "alive?:#{@a.b.alive?}"
    while true
    sleep 1
    #@a.var=10
    puts "alive?: #{@a.b.alive?}"
    end
end

@a.fun1
#p @a.b.alive?

#sleep 5
#a.var = 10
