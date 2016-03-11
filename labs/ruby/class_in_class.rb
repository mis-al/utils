#!/usr/bin/env ruby
puts "Start!"

class A
    class B
        def initialize
            @b1 = 1
            @b2 = 2
        end
        def fun1
            puts @a1
            puts @a2
            puts @b1
            puts @b2
        end
    end

    def initialize
        @a1 = 1
        @a2 = 2
        @b = B.new
     end
    def run
	@b.fun1
    end
end

a = A.new
a.run