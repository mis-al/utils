# encoding: utf-8

BUTTONS = {
    0x00 => '0',
    0x01 => '1',
    0x02 => '2',
    0x03 => '3',
    0x04 => '4',
    0x05 => '5',
    0x06 => '6',
    0x07 => '7',
    0x08 => '8',
    0x09 => '9',
    0x0A => 'ok',
    0x0B => 'cancel',
    0x0C => 'up',
    0x0D => 'down',
    0x0E => nil,
    0x0F => nil
}

FRAME_TYPE = {
    :keepalive_req => 0x00,
    :keepalive_res => 0x01,
    :hello => 0x02,
    :message => 0x03
}

CMDS = {
    :pt_card_inserted => 0x00,
    :pt_card_removed => 0x01,
    :pt_button_pressed => 0x02,
    :pt_set_text => 0x03,
    :pt_test_testovich => 0x04
}