#!/usr/bin/env ruby

require 'net/ssh'
require 'net/scp'

ip = '172.16.0.214'
user = 'root'

Net::SSH.start(ip, user) do |ssh|
  # capture only stdout matching a particular pattern
  stdout = ""
  ssh.exec!("ruby -e \"puts 'y'\"") do |channel, stream, data|
    stdout << data if stream == :stdout
  end
  puts stdout
=begin
  # run multiple processes in parallel to completion
  ssh.exec "ping tut.by -c 1"
  ssh.exec "ping tut.by -c 5"
  ssh.exec "ping tut.by -c 10"
  ssh.loop

  # open a new channel and configure a minimal set of callbacks, then run
  # the event loop until the channel finishes (closes)
  channel = ssh.open_channel do |ch|
    ch.exec "/usr/local/bin/ruby /path/to/file.rb" do |ch, success|
      raise "could not execute command" unless success

      # "on_data" is called when the process writes something to stdout
      ch.on_data do |c, data|
        $stdout.print data
      end

      # "on_extended_data" is called when the process writes something to stderr
      ch.on_extended_data do |c, type, data|
        $stderr.print data
      end

      ch.on_close { puts "done!" }
    end
  end

  channel.wait
  # forward connections on local port 1234 to port 80 of www.capify.org
  #ssh.forward.local(1234, "www.capify.org", 80)
  #ssh.loop { true }
=end
end
Net::SCP.upload!(tablo_ip, tablo_user, "./test02_synthetic.rb", '/tmp')
#p File.exist? "/tmp/test_1"
#Net::SCP.upload!(ip, user, "/tmp/test_1", '/tmp')
#Net::SSH.start(ip, user) do |ssh|
#  ssh.exec "ls /tmp/"
#end






tests = [
    {:cmd => "test02_synthetic.rb", :params => ''},
    {:cmd => "test02_wi_fi.rb", :params => 'eth'},
    {:cmd => "test01_net.rb", :params => 'eth'},
    {:cmd => "test01_net.rb", :params => 'tun'},
    {:cmd => "test01_net.rb", :params => 'wlan'}
]

tablo_user = 'root'
tablo_ip = '172.16.0.191'
tests_dir = './'
dst_dir = '/tmp/tests'


