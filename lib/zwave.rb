require 'rubygems'
require 'serialport'
require 'zwave/constants.rb'

module ZWave
  class SerialAPI
    RETRY_DELAY       = 500
    
    def initialize(port, speed = 115200)
      @port = SerialPort.new(port, speed, 8, 1, SerialPort::NONE)
      @port.read_timeout = 1000
      throw "Failed to open port #{device} for ZWave SerialAPI interface" unless @port
    end
    
    def debug=(value)
      @debug = value
    end
    
    def debug_msg(text)
      puts text if @debug
    end
    
    def switch(unit_id)
      return Switch.new self, unit_id
    end
    
    # TODO: don't retry forever
    def send_cmd(bytes)
      while(true) do
        send_cmd_once bytes
        break if read_response
        debug_msg "ZWave command failed, attempting retry..."
        sleep(RETRY_DELAY / 1000)
      end
    end
    
    def send_cmd_once(bytes)
      # add the length to the bytes we've been given
      bytes.unshift bytes.length + 1
      
      # send the start byte separately
      # we don't include this in @bytes since it doesn't go into the checksum)
      @port.putc Constants::Preamble::REQUEST
      
      # send out all the bytes
      @port.write bytes.pack("C*")
      
      # calculate the checksum (XOR of each byte against 0xFF)
      checksum = 0xFF
      bytes.each {|byte| checksum ^= byte }
      
      # send the checksum
      @port.putc checksum
    end
    
    def read_response
      acked = false
      
      status = @port.getbyte
      if(status != Constants::Preamble::ACK) then
        # first byte should be an ACK, if not then we give up and will retry
        debug_msg "Didn't get ack (got 0x#{status.to_s(16)}), aborting"
        # TODO: should interpret what we get more, NAK vs. RESET, etc.
        return false
      end

      # second byte should say this is a request
      type = @port.getbyte
      if(type != Constants::Preamble::REQUEST) then
        # don't know how to deal with anything but a REQUEST as i've never seen anything else
        debug_msg "Didn't get expected REQUEST byte (got 0x#{type.to_s(16)}), aborting"
        return false
      end
      
      # third byte is how long the response will be
      length = @port.getbyte
      debug_msg "Got response length: #{length}"
      
      # i don't understand what the response /is/ but we know how long it is so read/ignore it
      # TODO: there's likely a checksum at the end of responses, we should check it
      (1..length).each do |byte_nbr|
        byte = @port.getbyte
        debug_msg "Got response byte #{byte_nbr}: 0x#{byte.to_s(16)}"
      end
      
      # we need to ack the response or the controller will keep retrying
      @port.putc Constants::Preamble::ACK
      
      # all good!
      true
    end
    
    def dim(unit_id, level)
      debug_msg "Dimming unit #{unit_id} to level #{level}"
      self.send_cmd [
        Constants::Framing::PKT_START,
        Constants::FunctionClass::SEND_DATA,
        unit_id,
        3, # obtained via reversing, don't know what this is but seems to be 3, maybe ASCII ETX or Basic Slave?
        Constants::CommandClass::BASIC,
        Constants::Command::Basic::SET,
        level,
        5 # obtained via reversing, don't know what this is but seems to be 5, ASCII ENQ but that doesn't make sense here
      ]
    end
  end
  
  class Switch
    def initialize(controller, unit_id)
      @controller = controller
      @unit_id = unit_id
    end
    
    def switch_on
      @controller.dim @unit_id, 255
    end
    
    def switch_off
      @controller.dim @unit_id, 0
    end
  end
end