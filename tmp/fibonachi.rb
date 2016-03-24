#!/usr/bin/env ruby
require 'fiber'

puts "start!"


def fibonachi(xx=0,yy=1)
    puts "#{__method__}"
    x, y = xx, yy
        
    Fiber.new do
	loop do
	    puts "--->>>"
	    Fiber.yield y
	    x,y = y, x+y
	end
    end
end

res = fibonachi
p res.resume
p res.resume
p res.resume
p res.resume
p res.resume

