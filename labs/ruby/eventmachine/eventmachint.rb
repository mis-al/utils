#!/usr/bin/env ruby
require 'eventmachine'

puts "Start learning event machine"
class EchoServer < EM::Connection
    def receive_data (data)
    puts "Receive message:#{data}"
    send_data(data)
    end
end

EM.run do

#Signal.trap("INT") {EventMachine.stop}
#Signal.trap("TERM") {EventMachine.stop}

EventMachine.start_server("0.0.0.0", 10000, EchoServer)
end
