
# переменные класса видны методам класса и методам экземпляра класса,
# а так же коду определения класса, и используется совместно
class Point
  attr_reader :x, :y
  @@n =0 # переменная класса
  @@totalX = 0
  @@totalY = 0

  def initialize(x, y)
    @x, @y = x, y
    @@n += 1
    @@totalX += x
    @@totalY += y
  end

  def self.report
    p @@n
    p @@totalX
    p @@totalY
  end
end

p Point.new(10, 2)
p Point.new(11, 3)
p Point.new(12, 4)
 Point.report