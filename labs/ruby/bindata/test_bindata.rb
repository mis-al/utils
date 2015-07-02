#!/usr/bin/env ruby
# encoding: utf-8
require_relative 'include'
class HelloFrame < BinData::Record
  endian :little
  uint32 :serial
  string :vendor, :length => 8
  string :additional, :length => 8
end

class KeepaliveFrame < BinData::Record
  endian :little
end

class KeepaliveReqFrame < KeepaliveFrame
end

class KeepaliveResFrame < KeepaliveFrame
end

###########DATA###########
class DataLow < BinData::Record
  endian :little
end

# команды для фрэйма типа message
class PtSetText < DataLow
  string :str1, :length => 16
  string :str2, :length => 16
end

class PtCardInserted < DataLow
  uint32 :num
end

class PtCardRemoved < DataLow
end

class PtButtonPressed < DataLow
  uint8 :button
end

class PtTestTestovich < DataLow
  uint8 :test
  string :testovich, :length => 10
end


class MessageFrame < BinData::Record
  endian :little
  uint32 :cnt
  uint8 :cmd
  choice :data, :selection => :cmd do # тип data зависит от конкретной команды
    pt_set_text CMDS[:pt_set_text]
    pt_card_removed CMDS[:pt_card_removed]
    pt_card_inserted CMDS[:pt_card_inserted]
    pt_button_pressed CMDS[:pt_button_pressed]
    pt_test_testovich CMDS[:pt_test_testovich]
  end
end

class PtFrame < BinData::Record
  endian :little
  uint32 :len, :value => lambda { data.to_binary_s.size + 4 + 1 } # длинна фрэйма
  uint8 :frame_type # тип фрэйма
  choice :data, :selection => :frame_type do # тип data зависит от типа фрэйма
    hello_frame FRAME_TYPE[:hello]
    keepalive_req_frame FRAME_TYPE[:keepalive_req]
    keepalive_res_frame FRAME_TYPE[:keepalive_res]
    message_frame FRAME_TYPE[:message]
  end
  uint32 :crc32, :value => :crc32_, :onlyif => :not_keepalive_frame?

  def not_keepalive_frame?
    # перечисляются фрэймы для которых не надо считать crc
    !FRAME_TYPE.values_at(:keepalive_req, :keepalive_res).include?(frame_type)
  end

  def crc32_
    Zlib::crc32([len].pack('L') + [frame_type].pack('C') + data.to_binary_s)
  end
end

# оптимизация!!!
# оптимизация!!!
# оптимизация!!!

class Frame

  attr_reader :frame

  def initialize *msg
    @exclude_methods = ['len', 'data', 'crc32']

    if msg.empty?
      @frame = PtFrame.new
      return
    end

    msg = msg[0]
    p msg
    puts "FrameTypeError" unless FRAME_TYPE[msg[:frame_type]] #FRAME_TYPE.values.include? msg[:frame_type]
    frame_type = msg[:frame_type]
    @frame = PtFrame.new(:frame_type => FRAME_TYPE[frame_type])
    if @frame.methods.include? :data
      frame_class = (frame_type.to_s.split('_').collect(&:capitalize).join + "Frame").to_sym
      cmd = Kernel.const_get(frame_class).new # например будет создат клас  MessageFrame
    end
    check cmd, msg
    if cmd.methods.include? :cmd
      cmd_class = CMDS.key(cmd.cmd).to_s.split('_').collect(&:capitalize).join.to_sym
      cmd2 = Kernel.const_get(cmd_class).new # например будет создат клас  MessageFrame
      check cmd2, msg
      cmd.data = cmd2
    end
    @frame.data = cmd
    #p @frame.inspect
  end

  def check frame, msg
    # проверка присутствуют ли методы в хэше msg, присвоение и удаление из хэша если присутствуют
    must_be_methods = frame.field_names - @exclude_methods # получаем список полей для заполнения
    must_be_methods.each do |m|
      val = msg[m.to_sym]
      if m == 'cmd' || m == :cmd
        eval "frame.#{m} = #{CMDS[val]}"
      elsif m == 'button' || m == :button
        eval "frame.#{m} = #{BUTTONS.key(val)}"
      elsif val.class == String
        eval "frame.#{m} = '#{val}'"
      elsif val
        eval "frame.#{m} = #{val}"
      else
        raise FrameTypeError
      end
    end
  end

  def to_binary_s
    @frame.to_binary_s
  end

  def read io
    @frame = PtFrame.read io
    self
  end

  def to_hash
    return nil unless @frame
    h = eval(@frame.snapshot.to_s)
    while h['data']
      tmp = h['data']
      h.delete('data')
      h.merge!(tmp)
    end
    h
  end

  def crc32
    if self.to_hash['crc32']
      f_crc = self.to_hash['crc32']
      #self.frame.data.cnt = 11
      new_crc = self.frame.crc32
      f_crc == new_crc
    else
      puts "Not require crc for  #{self.to_hash['frame_type']}"
    end
  end

end

#test
#test_frame
a = Frame.new :frame_type => :message, :cnt => 10, :cmd => :pt_test_testovich, :test => 255, :testovich => "fffff"
#p a.to_binary_s
p a.to_hash
p a.crc32