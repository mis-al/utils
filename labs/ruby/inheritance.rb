class A

  attr_reader :state_a

  def initialize(*a)
    @state_a = 1
    puts "I am is A #{a}"
  end

  def test
    puts "I an is A.test"
  end

  def test_state_b
    puts @state_b
  end

end

class B < A

  attr_reader :state_b

  def initialize(*a)
    super()
    @state_b = 2
    puts "I am is B #{a}"
  end

  # def test
  #   #super
  #   puts "I an is B.test"
  # end
end


a = B.new 11, 22
a.test
p a.state_a
a.test_state_b