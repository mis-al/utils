#!/usr/bin/env ruby
#

# Блок - синтаксическая структура. Блок не является объектом.
# proc, lambda - объекы, представляющие блок.
# proc, lambda - экземпляры объекта Proc.

# создание proc обекта(не lambda)
def makeproc(&b)
  b
end

res =
    makeproc do
      a = 10
      puts a
      a = a -1
      a
    end
#res.call()
#res.call()
#res.call()
#p res.inspect
##########
# создание proc обекта(не lambda)
p = Proc.new { |x, y| x+y }


##########
# lambda - ведет себя как глобальная функция
# метод lambla не предполагает использования аргументов, но с вызовом должен быть связан какой-нибудь блок
x = 1
y = 2
l1 = lambda { |x| x+1 }
l2 = ->(x) { x+1 } # выражения эквивалентны
l3 = ->(x, y: i, j, k) { x+1 } # i,j,k - локальные переменные
l4 = -> x, y: i, j, k { x+1 } # i,j,k - локальные переменные

# Композиция из 2-х lambda объектов
def compose(f, g)
  ->(x) { f.call(g.call(x)) }
end

succOfSquare = compose(-> x { x+a }, -> x { x*x })
succOfSquare.call(4)
# сортировка массива используя блок и lambda
data = (1..100).to_a.shuffle
data.sort { |a, b| b-a }
data.sort &->(a, b) { b-a }

# .call - приводит к выполнению кода исходного блока

