#!/usr/bin/env ruby

require 'benchmark'
require 'net/http'
require 'open-uri'

@source = nil

@host = ARGV[1] ||'stackoverflow.com'
@path = ARGV[2] || '/index.html'

if ARGV[0] == 'h'
    puts "Use Net::HTTP"	
else
    puts "Open-uri"
end

Benchmark.bm do |x|
    10.times do |n|
        if ARGV[0] == 'h'
            x.report { @source = Net::HTTP.get(@host,@path ) }
        else
        x.report { @source = open("http://#{@host}"){|f|} }
        end
    end
end

#puts @source
