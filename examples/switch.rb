#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'zwave'

zwave = ZWave::SerialAPI.new "/dev/tty.KeySerial1"
zwave.debug = true
zwave.switch(2).switch_off