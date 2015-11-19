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

  option :mysql_v do
    short '-v'
    desc 'Specify mysql version. Default 5.6.22'
    default '5.6.22'
    filter do |value|
      res = /^\d+\.\d+\.\d+\z/.match(value)
      if res
        value
      else
        puts "Wrong value -v"
        exit
      end
    end
  end

  option :install_dep do
    short '-d'
    desc 'Install dependency mysql.'
  end

  option :remove do
    short '-r'
    desc 'Remove old version mysql.'
  end

  option :save do
    short '-s'
    desc 'Save downloading pkg'
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

# Предварительно надо деинсталировать libmysqlclient18:i386 библиотеку. И возможно использующую ее приложения

class Mysql

  attr_accessor :arch, :tmp_dir

  def initialize h

    initialize_logger
    @log.info "Initialize"

    @ms = h[:list_pkg] # список пакетов, поторые необходимо поставить
    @tmp_dir = h[:download_dir] || File.join('', 'tmp', srand.to_s)
    @arch = h[:arch] || '1ubuntu12.04_amd64'
    @arch += '.deb'
    @version = '_' + h[:version] +'-'
    prepare
  end

  def prepare
    unless Dir.exist?(@tmp_dir)
      @log.debug "Create #{@tmp_dir} directory."
      Dir.mkdir(@tmp_dir)
    end
    @list_inst_pkg = `apt --installed list | grep installed | tr -s '/' ' ' | cut -d' ' -f 1`.chomp.split
  end


  def clear
    @log.debug "Delete temp directory:  #{@tmp_dir}"
    FileUtils.rm_rf (@tmp_dir) if Dir.exist?(@tmp_dir)
  end

  def install_dependency

    unless @list_inst_pkg.include?('libaio1')
      @log.debug "Install libaio1"
      @log.debug `sudo apt-get install libaio1`
    end
  end

  def install
    @log.debug "Пакетов к установке: #{(@list_inst_pkg.size - (@list_inst_pkg - @ms).size)} "

    if @list_inst_pkg.size - (@list_inst_pkg - @ms).size < @ms.size
      #@log.info "Install '5.6.22'?"
      #@version = '_' + @version +'-'
      Dir.chdir @tmp_dir do
        @log.debug `wget http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-server#{@version}#{@arch}-bundle.tar`
        @log.debug `tar -xvf  mysql-server#{@version}#{@arch}-bundle.tar`
        @list_inst_pkg = `apt --installed list | grep installed | tr -s '/' ' ' | cut -d' ' -f 1`.chomp

        @ms.each do |name|
          pakage = name + @version + @arch
          unless @list_inst_pkg.include?(name)
            @log.info pakage.center(10, '-')
            res = `sudo dpkg -i #{pakage}`
            unless $? && $?.exitstatus.zero?
              @log.debug res
            end

          end
        end

      end
    end
  end

  def remove add_pkg
    @log.debug __method__
    rm_pkg << add_pkg.flatten if !add_pkg.nil? and add_pkg.kind_of? Array
    rm_pkg = @list_inst_pkg & @ms
    @log.info rm_pkg
    rm_pkg.reverse.each do |pkg|
      @log.info pkg.center(10, '-')
      res = `sudo dpkg -r #{pkg}`
      unless $? && $?.exitstatus.zero?
        @log.debug res
      end
    end
  end

  def create_databases
    @log.debug __method__
    puts `( echo "UPDATE user SET Password=PASSWORD('12345') where USER='root';"; echo 'FLUSH PRIVILEGES;'; ) | mysql -uroot mysql`
    puts `sudo /etc/init.d/mysql restart`
    #puts `( echo 'create database egmsite character set utf8;'; echo 'create database getfood character set utf8;'; ) | mysql -uroot -p12345`
  end

  private

  def initialize_logger
    Log4r::Logger.root.level = Log4r::DEBUG #WARN
    @log = Log4r::Logger.new("mysql")
    Log4r::StderrOutputter.new 'console'
    @log.add 'console'
  end

end


#
# main
#

ms =
    [
        "mysql-common",
        "libmysqlclient18",
        "libmysqlclient-dev",
        "libmysqld-dev",
        "mysql-client",
        "mysql-community-client",
        "mysql-community-server"
    ]

apt_get_install =
    [
        'mc',
        'git'
    ]

gem_install =
    [
        "bundler -v '1.8.2'"
    ]


#puts Choice[:mysql_v]

mysql = Mysql.new :list_pkg => ms, :version => Choice[:mysql_v]
if Choice[:install_dep]
  mysql.install_dependency
end

if Choice[:remove]
  mysql.remove nil
  exit
end

mysql.install

if Choice[:save]
  puts "Directory pkg: #{mysql.tmp_dir}"
  exit
end
mysql.clear
puts "Finish"