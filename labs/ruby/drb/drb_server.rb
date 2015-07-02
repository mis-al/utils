#!/usr/bin/env ruby
require 'drb'
front = []
DRb.start_service('druby://localhost:1234', front)
front << 'first'
# если вы запускаете сервер не в консоли, а отдельным скриптом - обязательно добавьте строку
DRb.thread.join