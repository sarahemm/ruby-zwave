#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'zwave'

zwave = ZWave::SerialAPI.new ARGV[0]
zwave.debug = true
zwave.switch(ARGV[1].to_i).switch_off
sleep 2
zwave.switch(ARGV[1].to_i).switch_on