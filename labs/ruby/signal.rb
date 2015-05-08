#!/usr/bin/env ruby
require 'eventmachine'

def fun_stop(params)
    puts "обработано прерывание #{params['signame']}"
    exit
end

Signal.trap("INT") {fun_stop 'signame' => "INT"}
Signal.trap("TERM") {fun_stop 'signame' => "TERM"}

sleep 10000
