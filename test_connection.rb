#!/usr/bin/env ruby

require 'benchmark'
require 'net/http'

@source = nil

@host = ARGV[0] ||'stackoverflow.com'
@path = ARGV[1] || '/index.html'
Benchmark.bm do |x|
  x.report { @source = Net::HTTP.get(@host,@path ) }
end

#puts @source


