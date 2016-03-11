#!/usr/bin/env ruby
puts "Start!"

class A
    def initialize
        @a1 = 1
        @a2 = 2
    end
    def aaa
        puts @b1
        puts @b2
    end
end

class B
  def initialize
    @b1 = 1
    @b2 = 2
    @a = A.new
  end
    def test
	@a.aaa
    end
end

b = B.new
b.test