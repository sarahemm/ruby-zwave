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
      @receive_buffer = Array.new
      @next_callback_id = 0
    end
    
    def next_callback_id
      callback_id = @next_callback_id
      @next_callback_id += 1
      @next_callback_id = 0 if @next_callback_id > 0xFF
      callback_id
    end
    
    def protocol_debug=(value)
      @protocol_debug = value
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
    
    # get the constant name for a given value in a given class
    def self.get_constant(constant_class, get_value)
      constant_class.constants.each do |this_name|
        this_value = constant_class.const_get(this_name)
        return this_name if this_value == get_value
      end
      "UNKNOWN".to_sym
    end
    
    def send_byte(byte)
      printf "Sending byte: 0x%02x\n", byte if @protocol_debug
      @port.write byte.chr
    end
    
    def send_bytes(bytes)
      if(@protocol_debug) then
        print "Sending bytes: "
        bytes.each_byte do |byte|
          printf "0x%02x ", byte
        end
        print "\n"
      end
      @port.write bytes
    end
    
    def recv_byte
      begin
        @receive_buffer.concat @port.read_nonblock(255).unpack("C*")
      rescue Errno::EAGAIN
        # try again until we have at least one byte
        # TODO: don't try forever
        retry if @receive_buffer.length == 0
      end
      return nil if @receive_buffer.length == 0
      printf "Receive buffer is #{@receive_buffer.length} bytes long.\n" if @protocol_debug
      byte = @receive_buffer.shift
      printf "Received byte: 0x%02x\n", byte if @protocol_debug
      byte
    end
    
    # TODO: don't retry forever
    def send_cmd(bytes)
      while(true) do
        send_cmd_once bytes
        response = read_response
        return response if response
        debug_msg "ZWave command failed, attempting retry..."
        sleep(RETRY_DELAY / 1000)
      end
    end
    
    def send_cmd_once(bytes)
      # add the length to the bytes we've been given
      bytes.unshift bytes.length + 1
      
      # send the start byte separately
      # we don't include this in @bytes since it doesn't go into the checksum)
      send_byte Constants::Preamble::REQUEST
      
      # send out all the bytes
      send_bytes bytes.pack("C*")
      
      # calculate the checksum (XOR of each byte against 0xFF)
      checksum = 0xFF
      bytes.each {|byte| checksum ^= byte }
      
      # send the checksum
      send_byte checksum
    end
    
    def read_response
      acked = false
      
      status = recv_byte
      if(status != Constants::Preamble::ACK) then
        # first byte should be an ACK, if not then we give up and will retry
        debug_msg "Didn't get ack (got 0x#{status.to_s(16)}), aborting"
        # TODO: should interpret what we get more, NAK vs. RESET, etc.
        return false
      end

      # second byte should say this is a request
      type = recv_byte
      if(type != Constants::Preamble::REQUEST) then
        # don't know how to deal with anything but a REQUEST as i've never seen anything else
        debug_msg "Didn't get expected REQUEST byte (got 0x#{type.to_s(16)}), aborting"
        return false
      end
      
      # third byte is how long the response will be
      length = recv_byte
      debug_msg "Got response length: #{length}"
      
      # i don't understand what the response /is/ but we know how long it is so read/ignore it
      # TODO: there's likely a checksum at the end of responses, we should check it
      response = Array.new
      (1..length).each do |byte_nbr|
        byte = recv_byte
        response.push byte
        debug_msg "Got response byte #{byte_nbr}: 0x#{byte.to_s(16)}"
      end
      
      # we need to ack the response or the controller will keep retrying
      send_byte Constants::Preamble::ACK
      
      # all good!
      response
    end
    
    def dim(unit_id, level)
      debug_msg "Dimming unit #{unit_id} to level #{level}"
      self.send_cmd [
        Constants::Framing::PKT_START,
        Constants::FunctionClass::SEND_DATA,
        unit_id,
        3, # length of command (class, command, one param)
        Constants::CommandClass::BASIC,
        Constants::Command::Basic::SET,
        level,
        next_callback_id
      ]
    end
    
    def get_node_protocol_info(unit_id)
      debug_msg "Getting protocol info for unit #{unit_id}"
      response = self.send_cmd [
        Constants::Framing::PKT_START,
        Constants::FunctionClass::GET_NODE_PROTOCOL_INFO,
        unit_id,
      ]
      
      basic_class = response[5]
      generic_class = response[6]
      specific_class = response[7]
      Node.new basic_class, generic_class, specific_class
    end
  end
  
  class Node
    attr_reader :specific_class
    
    def initialize(basic_class_id = nil, generic_class_id = nil, specific_class_id = nil)
      @basic_class_id = basic_class_id
      @generic_class_id = generic_class_id
      @specific_class_id = specific_class_id
      @specfic_class = [:id => @specific_class_id]
    end
    
    def basic_class
      [
        :id => @basic_class_id,
        :name => ZWave::SerialAPI::get_constant(ZWave::SerialAPI::Constants::BasicClass, @basic_class_id)
      ]
    end
    
    def generic_class
      [
        :id => @generic_class_id,
        :name => ZWave::SerialAPI::get_constant(ZWave::SerialAPI::Constants::GenericClass, @generic_class_id)
      ]
    end
  end
  
  class Switch < Node
    def initialize(controller, unit_id)
      @controller = controller
      @unit_id = unit_id
      
      super
    end
    
    def switch_on
      @controller.dim @unit_id, 255
    end
    
    def switch_off
      @controller.dim @unit_id, 0
    end
    
    def set(level)
      if(level < 0.5) then
        @controller.dim @unit_id, 0
      else
        @controller.dim @unit_id, 255 if level >= 0.5
      end
    end
  end
end