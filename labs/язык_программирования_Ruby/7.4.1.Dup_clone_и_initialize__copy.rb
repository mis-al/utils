
=begin
выделяется память под новый экземпляр класса того объекта
в отношении которого он был вызван
Затем копируется содержимое класса
dup   -
clone - копирует синглтон методы
initialize_copy - вызывается в отношении копируемого объекта
методами dup и clone


=end

class Point

  def initialize(*args)
    @coords = args
  end

  def initialize_copy(orig)
    @coords = @coords.dup
  end

  def to_s
    @coords.object_id
  end
  #
  private :dup, :clone
end

a = Point.new(1,2,3,4,5)

p a
p a.to_s # показываем id
b = a.clone
p b      # id склонированного объекта
p b.to_s
p a
p a.to_s  # показываем id, он остался тем же у а объекта