# encoding: utf-8
require_relative 'include'
def test
  ms =
      [
          ["Hello:", PtFrame.new(:frame_type => FRAME_TYPE[:hello], :data => {:serial => 55555, :vendor => "belatra", :additional => "qwerasdfz"})],
          ["Keepalive_req:", PtFrame.new(:frame_type => FRAME_TYPE[:keepalive_req])],
          #    ["Keepalive_res:", PtFrame.new(:frame_type => FRAME_TYPE[:keepalive_res])],
          #    ["Message: pt_card_inserted", PtFrame.new(:frame_type => FRAME_TYPE[:message], :data => {:cnt => 123, :cmd => CMDS[:pt_card_inserted], :data => {:num => 7777}})],
          #    ["Message: pt_card_removed", PtFrame.new(:frame_type => FRAME_TYPE[:message], :data => {:cnt => 123, :cmd => CMDS[:pt_card_removed]})],
          #    ["Message: pt_button_pressed", PtFrame.new(:frame_type => FRAME_TYPE[:message], :data => {:cnt => 123, :cmd => CMDS[:pt_button_pressed], :data => {:button => 0x05}})],
          ["Message: pt_set_text", PtFrame.new(:frame_type => FRAME_TYPE[:message], :data => {:cnt => 123, :cmd => CMDS[:pt_set_text], :data => {:str1 => "str123456789", :str2 => "str123456789"}})],
      ]

  ms.each do |m|
    p m[0]
    p m[1].inspect
    p m[1].to_binary_s
  end

end

def test_frame
  ms =
      [
          Frame.new(:frame_type => :keepalive_req),
          Frame.new(:frame_type => :keepalive_res),
          Frame.new(:frame_type => :hello, :serial => 123, :vendor => "b1e2l3a4t5r6a7", :additional => "1+2+3+4+5+6+7+8+9"),
          Frame.new(:frame_type => :message, :cnt => 123, :cmd => :pt_card_inserted, :num => 7777),
          Frame.new(:frame_type => :message, :cnt => 123, :cmd => :pt_card_removed),
          Frame.new(:frame_type => :message, :cnt => 123, :cmd => :pt_set_text, :str1 => "connect", :str2 => "CONNECT"),
          Frame.new(:frame_type => :message, :cnt => 123, :cmd => :pt_button_pressed, :button => '1')
      ]
  ms.each do |f|
    puts f.frame.to_binary_s.inspect
    puts Frame.new.read(f.frame.to_binary_s).to_hash
  end
end
