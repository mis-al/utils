#!/usr/bin/env ruby
require 'fiber'
puts "Start!"


=begin
# простой пример
f = Fiber.new do  
    puts "fiber"
    a = Fiber.yield 72 
    puts a
    73
end
f1 = f.resume 1
puts "f1 = #{f1}"
p f.alive?
f2 = f.resume 2
puts "f2 = #{f2}"
p f.alive?
=end

f1 = Fiber.new do  
    puts "fiber1"
#    a = Fiber.yield
end

f2 = Fiber.new do  
    puts "fiber2"
    f1.transfer
    puts "fiber2 finish"
#    a = Fiber.yield 72 
end
f3 = Fiber.new do  
    puts "fiber3"
#    a = Fiber.yield 72 
end

f2.resume