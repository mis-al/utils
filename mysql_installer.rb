#!/usr/bin/env ruby
#encoding: utf-8
require 'fileutils'
require 'log4r'
require 'log4r/yamlconfigurator'
require 'yaml'

# Предварительно надо деинсталировать libmysqlclient18:i386 библиотеку. И возможно использующую ее приложения
class Mysql

  def initialize h
    @ms = h[:list_pkg]
    @tmp_dir = File.join('', 'tmp', srand.to_s)
    @arch = '1ubuntu12.04_amd64.deb'

    cfg = Log4r::YamlConfigurator # shorthand
    cfg['HOME'] = '.'      # the only parameter in the YAML, our HOME directory
    cfg.load_yaml_file('mysql_installer_logger.yaml')
    @log = Log4r::Logger['mysql']
    @log.inf "Initialize"
    prepare
  end

  def prepare
    @log.deb __method__
     unless Dir.exist?(@tmp_dir)
       @log.deb "Create #{@tmp_dir} directory."
       Dir.mkdir(@tmp_dir)
     end
    @list_inst_pkg = `apt --installed list | grep installed | tr -s '/' ' ' | cut -d' ' -f 1`.chomp.split

  end

  def clear
    @log.deb __method__
    @log.deb "Delete temp directory:  #{@tmp_dir}"
    FileUtils.rm_rf (@tmp_dir) if Dir.exist?(@tmp_dir)
  end

  def install_dependency
    @log.deb __method__

    unless @list_inst_pkg.include?('libaio1')
      puts "install libaio1"
      puts `sudo apt-get install libaio1`
    end
    @log.deb (@list_inst_pkg.size - (@list_inst_pkg - @ms).size)

    if @list_inst_pkg.size - (@list_inst_pkg - @ms).size < @ms.size
      @log.inf "Install '5.6.22'?"
      @version = '_' + (!gets.chomp.empty? || '5.6.22') +'-'
      Dir.chdir @tmp_dir do
        puts `wget http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-server#{@version}#{@arch}-bundle.tar`
        puts `tar -xvf  mysql-server#{@version}#{@arch}-bundle.tar`
        @list_inst_pkg = `apt --installed list | grep installed | tr -s '/' ' ' | cut -d' ' -f 1`.chomp

        @ms.each do |name|
          pakage = name + @version + @arch
          unless @list_inst_pkg.include?(name)
            #puts '-------------------------------------'
            @log.inf "Installing #{pakage}".center(50, '-')
            @log.deb `sudo dpkg -i #{pakage}`
          end
        end

      end
    end

    #clear
  end

  def create_databases
    @log.deb __method__
    puts `( echo "UPDATE user SET Password=PASSWORD('12345') where USER='root';"; echo 'FLUSH PRIVILEGES;'; ) | mysql -uroot mysql`
    puts `/etc/init.d/mysql restart`
    #puts `( echo 'create database egmsite character set utf8;'; echo 'create database getfood character set utf8;'; ) | mysql -uroot -p12345`
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

res = Mysql.new :list_pkg => ms
res.install_dependency
res.create_databases
#res.clear



