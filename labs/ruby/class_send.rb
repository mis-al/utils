#!/usr/bin/env ruby
puts "Start!"

class Test

  def initialize
    @count = 0
  end

  def f1
    puts __method__
  end

  def f2
    @count += 1
    puts __method__
    send :f1
    send :f2 if @count <= 1
  end
end

a = Test.new
a.f2