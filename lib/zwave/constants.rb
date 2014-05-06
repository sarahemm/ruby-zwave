module ZWave
  class SerialAPI
    class Constants
      # obtained from reversing
      class Preamble
        # sending device is requesting something from the other end
        # all requests must be ACK/NAKed or are re-sent
        # a response seems to just be a request from controller -> PC
        REQUEST = 0x01  # ASCII SOH
        # received successfully
        ACK     = 0x06  # ASCII ACK
        # some kind of error, haven't figured out exactly how this works yet
        NAK     = 0x21  # ASCII NAK
        # seems analagous to TCP RST
        # sent when things get out of sync, says to stop what you're doing
        # and start over from scratch
        RESET   = 0x18  # ASCII CAN
      end
      
      # obtained from reversing, guessing it's a fixed start byte?
      class Framing
        PKT_START = 0x00
      end
      
      # name from Z-Way API manual Dec 2012
      class FunctionClass
        # value from reversing
        SEND_DATA = 0x13
        # value from reversing
        GET_NODE_PROTOCOL_INFO = 0x41
      end
      
      # name from Electronic Solutions DBMZ v2+1 manual
      class CommandClass
        # name from Leviton RZC0P programming guide v1.2, value from reversing
        BASIC = 0x20
        # name from Leviton RZC0P programming guide v1.2, value not yet known
        #MULTILEVEL_SWITCH = 
        # names from Electronic Solutions DBMZ v2+1 manual, values not yet known
        #CONFIGURATON = 
        #SWITCH_ALL = 
        #MFG_SPECIFIC_GET = 
        # name and value from http://wiki.micasaverde.com/index.php/ZWave_Command_Classes
        ASSOCIATION = 0x85
      end
      
      class Command
        # names from Leviton RZC0P programming guide v1.2, values from reversing
        class Basic
          SET = 0x01
          GET = 0x02
        end

        # via reversing
        class Association
          SET = 0x01
          GET = 0x02
        end
        
        # names from Electronic Solutions DBMZ v2+1 manual, values not yet known
        class MultilevelSwitch
          #GET                = 
          #SET                = 
          #START_LEVEL_CHANGE = 
          #STOP_LEVEL_CHANGE  = 
        end
      end
      
      # from Leviton RZC0P programming guide v1.2
      class BasicClass
        CONTROLLER        = 0x01
        STATIC_CONTROLLER = 0x02
        SLAVE             = 0x03
        ROUTING_SLAVE     = 0x04
      end
      
      # from Leviton RZC0P programming guide v1.2
      class GenericClass
        THERMOSTAT        = 0x08
        SWITCH            = 0x10
        DIMMER            = 0x11
      end
    end
  end
end
