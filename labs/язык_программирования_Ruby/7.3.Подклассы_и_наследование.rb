
Point =  Struct.new(:x, :y, :z)
class Point3D < Point

end

p p2 = Point.new.to_s
p p2 = Point3D.new.to_s
