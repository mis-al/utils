# public - вызывается отовсюду
# private - вызывается другими экземплярами класса(НЕЛЬЗЯ ВЫЗВАТЬ МЕТОДОМ КЛАССА)
# protected
# методы поумолчанию public (кроме initialize)
#
#
#
#
class Point
  attr_reader :x, :y

  def initialize(x, y)
    @x, @y = x, y
  end

  def self.self_get_x_priv
    f_priv # ОШИБКА!!! из метода класса нельзя вызвтаь private метод
  end

  def get_x_priv
    f_priv
  end


  def f1
    @n # это совсем другая переменная
  end

  def get_f_prot(o=false)
    if o
      o.f_prot
      return
    end
    f_prot
    #puts "#{__method__}"
  end

  private
  def f_priv
    puts "#{__method__}"
  end

  protected
  def f_prot
    puts "#{__method__}: x: #{x}"
  end
end

a = Point.new(10, 2)
#a.get_x_priv
#Point.self_get_x_priv
#a.f_prot
#a.get_f_prot #Point.new(1, 1)

# обход закрытых методово
#a.send :f_priv

#a.public_send :f_priv # не вызовет метод send
a.instance_eval { f_priv }
