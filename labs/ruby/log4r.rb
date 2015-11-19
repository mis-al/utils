#!/usr/bin/env ruby
# Here's how to start using log4r right away
$: << File.join('..','lib')                   # path if log4r not installed

require 'log4r/outputter/datefileoutputter'
require "log4r"
$: << File.join('..','lib') # path if log4r is not installed
require 'log4r'
require 'log4r/yamlconfigurator'
# we use various outputters, so require them, otherwise config chokes
require 'log4r/outputter/datefileoutputter'
require 'log4r/outputter/emailoutputter'
require 'log4r/outputter/scribeoutputter'

Log = Log4r::Logger.new("mylogger")        # create a logger
#Log.add Log4r::Outputter.stderr               # which logs to stdout

# do some logging
def do_logging
 Log.debug "debugging"
 Log.info "a piece of info"
 Log.warn "Danger, Will Robinson, danger!"
 Log.error "I dropped my Wookie! :("
 Log.fatal "kaboom!"
end


do_logging

