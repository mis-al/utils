#!/usr/bin/env ruby
require 'active_record'

puts "Start!"

ActiveRecord::Base.establish_connection(
  :adapter  => "mysql2",
  :host     => "localhost",
  :username => "root",
  :password => "12345",
  :database => "sctest"
)

class TestLogs < ActiveRecord::Base
end

p TestLogs.all
puts "Finish!"