#!/usr/bin/env ruby
# encode: utf-8

require 'choice'
require 'fileutils'


PROGRAM_VERSION = 1

Choice.options do
  header ''
  header "Program find Gemfile in specified path and run bundle 'action'"
  header ''
  header 'Specific options:'

  option :source, :required => true do
    short '-s'
    long '--source=/path/to/dir'
    desc 'The directory in which to search'
    filter do |value|
      unless Dir.exist? value
        puts "No such directory #{value}"
        exit
      end
      value
    end
  end

  option :action do
    short '-a'
    long '--action=action'
    desc 'Bundle install or updates'
    valid %w[update install]
    default 'install'
  end

  option :examples do
    short '-e'
    desc 'Show examples'
    action do
      puts "gems_action.rb -s /opt/sctest/sctest -a update"
      puts "gems_action.rb -s /opt/myproject -a install"
      exit
    end
  end

  separator ''
  separator 'Common options: '

  option :help do
    long '--help'
    desc 'Show this message'
  end

  option :version do
    short '-v'
    long '--version'
    desc 'Show version'
    action do
      puts "#{__FILE__} v#{PROGRAM_VERSION}"
      exit
    end
  end

end



ms = Dir.glob("#{Choice[:source]}/**/Gemfile")
ms.each do |dir|
  Dir.chdir File.dirname(dir) do
    #puts "bundle #{Choice[:action]}: #{dir}"
    system "bundle #{Choice[:action]}"
  end
end
