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
  @timer1 = EM.add_timer(6) do
    puts "t1"
  end

  @timer2 = EM.add_timer(3) do
    puts "t2"
    EM.cancel_timer @timer1
  end

  EM.add_periodic_timer(1) do
    puts "Execute periodic timer1"
  end

  EM.add_periodic_timer(3) do
    puts "Execute periodic timer2"
  end

  EventMachine.start_server("0.0.0.0", 10000, EchoServer)

end

