class Point
  attr_reader :x, :y

  def initialize(x, y)
    @x, @y = x, y
  end

  ORIGIN = Point.new(0, 0)

end

p Point.new(1, 1)
p Point::ORIGIN