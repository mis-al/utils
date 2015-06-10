#!/usr/bin/env ruby 

module Aaa

    class Bbb
        def m1
            puts __method__
        end

        def self.m2
            puts __method__
        end
    end
end

include Aaa
a = Bbb.new
a.m1
a.m2 # нету такого метода
Bbb.m2