Struct.new('Point')
class Point
  attr_reader :x, :y

  def self.sum(*points)
    x = y = 0
    points.each { |p| x += p.x; y += p.y }
    Point.new(x, y)
  end

  def initialize(x, y)
    @x,@y = x,y
  end
end

p Point.new(1, 1)
p Point.sum(Point.new(1, 1), Point.new(1, 1), Point.new(1, 1))

# еще один способ определения методов класса
class << Point
  def sum1(*points)
    x = y = 0
    points.each { |p| x += p.x; y += p.y }
    Point.new(x, y)
  end
end

p Point.sum1(Point.new(1, 1), Point.new(1, 1), Point.new(1, 1))

class Point
  # определение методов экземпляра класса
  class << self
    # определение методов класса
  end
end
