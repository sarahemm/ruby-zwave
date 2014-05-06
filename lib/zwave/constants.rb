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
        BASIC                     = 0x20
        # name from Leviton RZC0P programming guide v1.2, value not yet known
        #MULTILEVEL_SWITCH = 
        # names from Electronic Solutions DBMZ v2+1 manual, values not yet known
        #SWITCH_ALL = 
        #MFG_SPECIFIC_GET = 
        # name and value from http://wiki.micasaverde.com/index.php/ZWave_Command_Classes
        ASSOCIATION               = 0x85
        # names and values from BeNext Quick start: Tag Reader EU (www.benext.eu/static/manual/tagreader.pdf)
        SWITCH_BINARY             = 0x25
        USER_CODE                 = 0x63
        CONFIGURATION             = 0x70
        ALARM_V2                  = 0x71
        MANUFACTURER_SPECIFIC_V2  = 0x72
        BATTERY                   = 0x80
        WAKE_UP                   = 0x84
        VERSION                   = 0x86
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
      
      # class name from Leviton RZC0P programming guide v1.2
      class BasicClass
        # these are from Leviton RZC0P programming guide v1.2
        CONTROLLER        = 0x01
        STATIC_CONTROLLER = 0x02
        SLAVE             = 0x03
        ROUTING_SLAVE     = 0x04
      end
      
      # class name from Leviton RZC0P programming guide v1.2
      class GenericClass
        # this is from reversing, portable controllers seem to return this
        # also some things that return STATIC_CONTROLLER for basic return this, what?
        CONTROLLER        = 0x01
        # this is from reversing, controllers built into the wall return this
        STATIC_CONTROLLER = 0x02
        # these are from Leviton RZC0P programming guide v1.2
        THERMOSTAT        = 0x08
        SWITCH            = 0x10
        DIMMER            = 0x11
      end
    end
  end
end
