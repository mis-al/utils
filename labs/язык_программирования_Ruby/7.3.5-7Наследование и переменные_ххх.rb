class Point
  attr_accessor :x, :y

  def initialize()
    @x =7
    # переменные в подклассе НЕ НАСЛЕДУЮТСЯ
    # они создаются методом инициализации для Point3D класса
  end

  def get_x
    @x=4
    @x
  end

  def get_y
    @y
  end
end

class Point3D < Point
  attr_accessor :z

  def initialize(x, y, z)
    super()
    @z = z
    #@x = 1234
  end

  def to_s
    "#{@x} #{@y} #{@z}"
  end

end

#p a =  Point3D.new(1,2,3).x=5
#p a.public_methods(false)
#p a.instance_variables
#p Point.instance_variables

p a = Point3D.new(1, 2, 3)
p a.get_y
p a.y
p a.y='y'
p a.y
