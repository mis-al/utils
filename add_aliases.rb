#!/usr/bin/env ruby
#encoding: utf-8
require 'fileutils'
require 'log4r'
require 'yaml'
require 'choice'

PROGRAM_VERSION = 1

Choice.options do
  header ''
  header 'Specific options:'

  option :file_aliases do
    short '-f'
    desc 'Specify file aliases. Default ./add_aliases.yml'
    default './add_aliases.yml'
  end

  option :once do
    short '-o'
    desc 'Add only one aliase.'
  end

  option :user do
    short '-u'
    desc "Specify user. Default: result command `whoami`: #{`whoami`.chomp}"
    default `whoami`.chomp!
  end

  option :other_bashrc do
    short '-b'
    desc "Specify other then default ./.bashrc file"
  end


  separator ''
  separator 'Common options: '

  option :help do
    long '--help'
    desc 'Show this message'
  end

  option :version do
    long '--version'
    desc 'Show version'
    action do
      puts "#{__FILE__} v#{PROGRAM_VERSION}"
      exit
    end
  end
end


class Aliase

  def initialize h
    initialize_logger
    @log.info "Start"
    @file_aliases = h[:file_aliases]
    @once = h[:once]
    @user = h[:user]
    @custom_bashrc = h[:other_bashrc]
    @bashrc = nil

    if @user.nil?
      @log.error "Not specify user"
    end

    if @once.nil? && !File.exist?(@file_aliases)
      @log.error "No such file #{@file_aliases}"
      exit
    end
  end

  def check_user
    d_home = Dir.chdir('/home') do
      Dir.glob('*').select { |f| File.directory? f }
    end
    f_passwd = `cat /etc/passwd | grep -v false | grep -v nologin | cut -f 1 -d':'`.split

    users = d_home & f_passwd

    unless users.include? @user
      @log.error "Wrong username"
      @log.error "Allowed only #{users.join(', ')}"
      exit
    end
  end

  def bashrc
    @log.debug "user: #{@user}"
    home_path = `cat /etc/passwd | grep -v false | grep -v nologin | grep #{@user}| cut -f 6 -d':'`.chomp
    @bashrc = File.join(home_path, @custom_bashrc || './.bashrc')
    unless File.exist? @bashrc
      @log.warn "No such file #{@bashrc}"
    end
  end

  def run_once
    return if @once.nil?
    #@bashrc = "/tmp/zzzzz"
    @log.debug "Run command"
    @log.debug "bashrc file: #{@bashrc}"
    `echo "alias #{@once.split('=')[0]}=\'#{@once.split('=')[1..-1].join}\'" >> #{@bashrc}`
    exit
  end

  def run_from_file
    unless File.exist? @file_aliases
      @log.error "No such file #{@file_aliases}"
      exit
    end
    #@bashrc = "/tmp/zzzzz"
    @log.debug "bashrc file: #{@bashrc}"
    exist =  `cat #{@bashrc} | grep alias | cut -f2 -d' '| cut -d'=' -f1`.split.uniq
    aliases = YAML.load_file(@file_aliases)
    aliases.each do |k, v|
      @log.info "Add aliase #{k}"
      if exist.include? k
        @log.warn "Already exist"
      end
      `echo "alias #{k}=\'#{v}\'" >> #{@bashrc}`
    end
  end

  private

  def initialize_logger
    Log4r::Logger.root.level = Log4r::DEBUG #WARN
    @log = Log4r::Logger.new("aliase")
    Log4r::StderrOutputter.new 'console'
    @log.add 'console'
  end

end

params = {}
params[:file_aliases] = Choice[:file_aliases]
params[:once] = Choice[:once]
params[:user] = Choice[:user]
params[:other_bashrc] = Choice[:other_bashrc]

#p params

a = Aliase.new params
a.check_user
a.bashrc
a.run_once
a.run_from_file
