
class String
  def init()
    self.allocate
  end
end
a =  ''
b = a
p a.class
p a.object_id
p b.object_id
c = a.allocate

