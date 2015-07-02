
=begin
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
