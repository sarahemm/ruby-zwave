#!/usr/bin/env ruby
# utility to help in reversing, given a list of bytes it will list all the constants each one matches
# this could be made much more efficient, but is a quick hack to make things easier :)

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'zwave/constants'
include ZWave

byte_string = ""
until($stdin.eof?) do
  byte_string += $stdin.read(1024)
end
bytes = Array.new
byte_string.split(/\s+/).each do |byte_text|
  if(/0x[0-9A-Fa-f]{2}/.match(byte_text)) or ARGV[0] == "hex"
    # starts with 0x or user is forcing hex, must be hex
    byte_text.sub!("0x", "")
    bytes.push(byte_text.to_i(16))
  else
    bytes.push(byte_text.to_i(10))
  end
end

bytes.each do |byte|
  matching_constants = Array.new
  SerialAPI::Constants.constants.each do |constant_class|
    SerialAPI::Constants.const_get(constant_class).constants.each do |constant|
      constant_value = SerialAPI::Constants.const_get(constant_class).const_get(constant)
      matching_constants.push "#{constant_class}::#{constant}" if constant_value == byte
    end
  end
  printf "0x%02x\t#{matching_constants.join("\t")}\n", byte
end