#!/usr/bin/env ruby
puts "Start!"

class A
    def initialize
        @b1 = 1
        @b2 = 2
    end
    def test
	@a.aaa
    end

    def method_missing(sym, *args)
	p sym
	p args
    
    end
end

a = A.new
a.fun1
a.fun2 1
a.fun3 1,2
a.fun4 1,2,3