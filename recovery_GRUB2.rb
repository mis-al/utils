#!/usr/bin/env ruby

#uncomment this string if you realy want to run recovery
#exit 0

# простой способ без использования chroot!
# скрипт выполняется на загруженой LiveCB/USB

class Recovery

  def initialize
    @type_fs = '83' #Linux
    @mount_dir = File.join('','tmp',srand.to_s)
    @root_part = nil
    @select_dev = nil
    @devs = nil
  end

  def prepare
    Dir.mkdir @mount_dir
  end

  def find_parts
    # find boot partition
    @devs = `sudo fdisk -l | grep " #{@type_fs} " | cut -d' ' -f1 | grep -v Disk`.split
    @flag = false
    @devs.each do |f|
      @flag = true if File.exist?(f)
    end
    unless @flag
      clean
      puts "No such devices"
      exit 1
    end
  end

  def select_dev
    while true
      puts `lsblk #{(@devs.map { |e| e[0..-2] }).uniq.join(' ')}`
      printf "Select device to install GRUB(example /dev/sda):"
      @select_dev = gets.chomp
      if @select_dev == 'q'
        puts "Exit!"
        clean
        exit 1
      end
      unless File.exist?(@select_dev)
        puts "No such file #{@select_dev}"
      else
        break
      end
    end
  end

  def grub_install
    @root_part = @devs.join(' ').scan(@select_dev)[0]
    unless File.exist? @root_part
      puts "No such file #{@root_part}"
      clean
      exit 1
    end
    `sudo mount #{@root_part} #{@mount_dir}`
    if $?.exitstatus != 0
      puts "Error mount. Exit status: #{$?.exitstatus}"
      clean
      exit 1
    end
    puts `sudo grub-install --root-directory=#{@mount_dir} #{@select_dev[0..-2]}`
  end

  def update_grub
    if @mount_dir && Dir.exist?(@mount_dir)
      puts `sudo update-grub --output=#{@mount_dir}/boot/grub/grub.cfg`
    end
  end

  def clean
    `sudo umount #{@mount_dir}` if `mount`.include? @mount_dir
    Dir.rmdir(@mount_dir) if Dir.exist?(@mount_dir)
    if @root_part && !`mount | grep #{@root_part}`.empty?
      `sudo umount #{@root_part}`
    end
  end

  # require for debug
  def status_var
    puts "@type_fs:  #{@type_fs}"
    puts "@mount_dir: #{@mount_dir}"
    puts "@root_part: #{@root_part}"
    puts "@select_dev: #{@select_dev}"
  end
end

r = Recovery.new
r.prepare
r.find_parts
r.select_dev
#r.grub_install #uncomment to install grub
#r.update_grub #uncomment to update grub menu
r.clean

