#!/usr/bin/env ruby
require 'fiber'

puts "start!"

class A
    def self.start_clinet(x,y,&b)
	'12345'
    end
end

class B < A

    def self.start_client(x,y)
	p f = Fiber.current
	res = super(x,y) do
		p f.resume 'ok'
	end
#	res = super
        
    end
end


B::start_client 1, 2


