#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'zwave'

zwave = ZWave::SerialAPI.new ARGV[0]
zwave.debug = true
node = zwave.get_node_protocol_info ARGV[1].to_i
if(!node) then
  puts "\nNo node found at address #{ARGV[1]}"
  exit
end
p node
p node.basic_class
p node.generic_class
p node.specific_class
