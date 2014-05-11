#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'zwave'

zwave = ZWave::SerialAPI.new ARGV[0]
unit_id = ARGV[1].to_i
zwave.debug = true

zwave.switch(unit_id).switch_off
sleep 0.5
p zwave.get(unit_id, ZWave::SerialAPI::Constants::CommandClass::SWITCH_BINARY)

sleep 2

zwave.switch(unit_id).switch_on
sleep 0.5
p zwave.get(unit_id, ZWave::SerialAPI::Constants::CommandClass::SWITCH_BINARY)
