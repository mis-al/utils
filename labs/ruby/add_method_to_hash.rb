#!/usr/bin/env ruby

puts "Start!"

class Hash 

    def f1 
	puts "__method__"
    end

    def self.f2 
	puts "__method__"
    end
end



h  =  {}
p Hash::f1
p Hash::f2
p h.f1
p h.f2