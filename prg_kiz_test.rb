#!/usr/bin/env ruby
# encoding: utf-8


#
#
#                ВНИМАНИЕ!!!
#        МОЖНО ПОТЕРЯТЬ ВСЕ ДАННЫЕ!!!
#                ВНИМАНИЕ!!!
#
#


=begin
-f      => сканирование устройств и выход
-d      => отключение устройства и выход
--smib  => устройства не сканируются, идет обращение со смибом
--disk  => автосканирование, чтение smart, отключение
--clear => автосканирование, удаление информации, отключение
=end

require 'choice'
require 'fileutils'
require 'yaml'

PROGRAM_VERSION = 1

Choice.options do
  header ''
  header 'Specific options:'

  option :find do
    short '-f'
    desc 'Опеределить жесткий диск.'
  end

  option :delete do
    short '-d'
    desc 'Отключить питание жесткого диска.'
  end

  option :create_symlink do
    long '--symlink='
    desc 'Создает ссылку'
    #default "/usr/bin/s"
    filter do |value|
      puts Dir.exist?(File.dirname(value)).inspect
      if value && Dir.exist?(File.dirname(value))
        value
      else
        puts "ОШИБКА: некорректное значение --symlink."
        exit 0
      end
    end
  end

  option :disk do
    long '--disk'
    desc 'Показывает SMART информацию жесткого диска.'
  end

  option :smib do
    long '--smib'
    desc 'Провериь связь со смибом через COM-порт.'
  end

  option :clear do
    long '--clear'
    desc "Удалить информацию о таблице разделов жесткого диска.\n
            Все данные будут потеряны"
  end

  option :prepare do
    long '--prepare'
    desc 'Помещает в .bashrc альясы для быстрого запуска'
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


class Kiz

  def initialize
    init
    @enabled = false
    @device = nil
    #SIZE_80_GB = 80026361856
  end

  def disk_devices_find #Choice[:find]
    enable
    puts "Текущие устройства: #{@disks}"
    exit 0
  end

  def disk_device_disable #Choice[:delete]
    if @disks.empty?
      puts "Не обнаружено подключенных дисков"
    else
      disable
    end
    exit 0
  end

  def prepare create_symlink
    if create_symlink
      puts "Создание символьной ссылки..."
      path_cur = File.expand_path(__FILE__)
      begin
        File.symlink(path_cur, Choice[:create_symlink])
      rescue
        puts "ПРЕДУПРЕЖДЕНИЕ: файл #{Choice[:create_symlink]} существует"
      end
      `echo "alias s=\\"#{File.basename(Choice[:create_symlink])} --smib\\"" >> .bashrc`
      `echo "alias d=\\"#{File.basename(Choice[:create_symlink])} --disk\\"" >> .bashrc`
      `echo "alias c=\\"#{File.basename(Choice[:create_symlink])} --clear\\"" >> .bashrc`
    else
      puts "ОШИБКА: укажите параметр --symlink"
    end
    exit 0
  end

  def check_smib #Choice[:smib]
    path_to_bin = 'bin/smib-guard'
    @database = File.join(Dir.pwd, ".database")

    if !File.exist?(@database)
      puts "ОШИБКА: отсутствует файл базы данных"
    else
      # работа с базой данных
      Struct.new("Str", :date, :id)
      @db = YAML.load_file(@database)
      @db ||= []
      #############################################
      Dir.chdir File.dirname(path_to_bin) do
        prg = File.basename(path_to_bin)
        res = `./#{prg} -serial -serialdev=/dev/ttyS1 -dstfile=/dev/null`
        r = res.scan(/(([0-9a-fA-F]{2}[:]){5}[0-9a-fA-F]{2})/)
        2.times { r = r.first unless r.empty? }

        if false #r.nil? || r.empty?
          puts "Ошибка связи"
        else
          puts "Связь установлена. Получен идентификатор #{r}"
          str = Struct::Str.new(Time.now, r)
          res1_ms = @db.select { |e| e.id == str.id && e.date.yday == str.date.yday }
          #puts "За сегодня #{res1_ms.count}-й тест" unless res1_ms.empty?
          res2_ms = @db.select { |e| e.id == str.id && e.date.yday != str.date.yday }
          unless res2_ms.empty?
            puts "Данный smib проверялся:"
            res2_ms.uniq! { |o| o.date.yday }
            res2_ms.each do |s|
              puts "Дата: #{s.date}"
            end
          end
          @db << str
          File.open(@database, 'w') { |f| f.write @db.to_yaml } #Store
        end
      end
    end
  end

  # выполнить операцию чтения SMART информации
  def disk_show_smart #Choice[:disk]
    enable
    select_disk_device
    path_to_bin = '20140716 LifeGuard_V1.6.0/LifeGuard_V1.6.0_for_Linux'

    Dir.chdir File.dirname(path_to_bin) do
      prg = File.basename(path_to_bin)
      puts `sudo ./#{prg} #{@device}`
    end
    disable
  end

  def disk_clear #Choice[:clear]
    # операция затирания первых 10мб жесткого диска
    enable
    select_disk_device
    puts "Удаление данных..."
    `sudo dd if=/dev/zero of=#{@device} bs=1M count=10`
    `sync`
    disable
  end

  private

  def init
    # инициализация переменных
    disk_root = `mount | grep " / " | cut -d' ' -f1`.chomp[0..-2]
    @disk_root = `lsblk -dno NAME,SIZE #{disk_root}`.lines.map { |d| d.chomp.split }.to_h
    # поиск устройств жестких дисков
    @disks = `lsblk -dno NAME,SIZE`.lines.map { |d| d.chomp.split }.to_h
    # исключение диска с которого была загружена операционная система
    @disks.delete @disk_root.keys.first
  end

  def enable
    if !@enabled
      scan
      sleep 3
      init
      if @disks.empty?
        puts "Устройство не обнаружено"
        exit 0
      end
      @enabled = true
    end
  end

  def scan
    puts "Поиск жесткого диска..."
    #scan device sata0
    list = `sudo ls /sys/class/scsi_host/host?/scan`
    list.lines do |l|
      l.chomp!
      #puts "scanning #{l.inspect}"
      `sudo su -c "echo '- - -' > #{l}"`
    end
  end

  def disable
    if @enabled || ARGV.include?("-d")
      puts "Отключение питания жесткого диска..."
      #power down the sata ssd
      if @device.nil?
        select_disk_device
      end
      Dir['/sys/block/sd?'].each do |d|
        d.chomp!
        if d.split('/')[-1] == @device.split('/')[-1]
          #puts "Удаление!!!!!!!!!! #{d.inspect}"
          res = d + '/device/delete'
#    	    `sudo su -c "echo 1 > /sys/block/sda/device/delete"`
          `sudo su -c "echo 1 > #{res}"`
        end
      end
      @enabled = false
    end
  end

  def select_disk_device
    @device =
        if @disks.count > 1
          select
        elsif @disks.count == 1
          @disks.keys.first.to_s
        else
          "some_error"
        end
    @device = "/dev/" + @device

    unless File.exist? @device
      puts "ОШИБКА: Файл устройства #{@device} не найден"
      exit 0
    end
  end

  def select
    while true
      puts "Выбери устройство:"
      @disks.each_with_index do |d, i|
        puts "#{i+1}:   #{d.first} #{d.last}"
      end
      STDIN.flush
      res = STDIN.gets.chomp
      if !res.match(/\A[0-9]{1}\Z/) || !(1..@disks.count).include?(res.to_i)
        puts "Ошибка!"
        next
      end
      res_dev = @disks.keys[res.to_i - 1].to_s
      return res_dev
    end
  end

end


####################################################################################
####################################################################################


puts "Start!!!"
kiz = Kiz.new

if Choice[:find]
  kiz.disk_devices_find
  exit
end

if Choice[:delete]
  #kiz.disk_device_disable
  exit
end

if Choice[:prepare]
  kiz.prepare Choice[:create_symlink]
  exit
end

if Choice[:smib]
  kiz.check_smib
end

if Choice[:disk]
  kiz.disk_show_smart
end

if Choice[:clear]
  #kiz.disk_clear
end
