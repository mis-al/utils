#!/usr/bin/env ruby

require 'drb'
DRb.start_service
remote_obj = DRbObject.new_with_uri('druby://localhost:1234')
p remote_obj
p remote_obj[0]
remote_obj << 'second'