#!/usr/bin/env ruby
puts "Start!"

class A
    def initialize
        @a1 = 1
        @a2 = 2
    end
    def fun(http_type, link, params={})
	p "#{__method__}-->#{params}"
    end
    def fun1(params)
	p "#{__method__}-->#{params}"
    end
    def fun2(params)
	p "#{__method__}-->#{params}"
    end
end

custom_method = :fun1
a = A.new
a.send custom_method, \
    :query => {:a => 1, :b => 2}