#!/usr/bin/env ruby
require 'eventmachine'

module EchoServer
  def post_init
    puts "-- someone connected to the echo server!"
  end

  def connection_completed
    puts "#{__method__}"
  end
  def receive_data data
    ##
    send_data ">>>you sent: #{data}"
    close_connection if data =~ /quit/i
  end

  def unbind
    puts "-- someone disconnected from the echo server!"
  end
end

# Note that this will block current thread.
 EM.run do
#   array = (1..100).to_a
#   @b = []
#   tickloop = EM.tick_loop do
#     if array.empty?
#       :stop
#     else
#
#       a = (array.shift)**100000
#       @b << a
#     end
#   end
#
#   tickloop.on_stop {  p @b; EM.stop }

 EventMachine.start_server "127.0.0.1", 8081, EchoServer
#   EventMachine::connect "127.0.0.1", 8081, EchoServer
#   EventMachine::connect "127.0.0.1", 8081, EchoServer
end
