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
        SEND_DATA               = 0x13
        # values from reversing
        GET_INTERFACE_IDS       = 0x20
        GET_NODE_PROTOCOL_INFO  = 0x41
        DEVICE_UPDATE           = 0x49
      end
      
      # name from Electronic Solutions DBMZ v2+1 manual
      class CommandClass
        # name from Leviton RZC0P programming guide v1.2, value from reversing
        BASIC                     = 0x20
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
        # names and values from BeNext Quick start: Internet Gateway EU (www.benext.eu/static/manual/internetgateway.pdf)
        SWITCH_ALL                = 0x27
        METER                     = 0x32
        MULTI_CMD                 = 0x8F
        MULTI_CHANNEL_ASSOCIATION = 0x8E
        MULTI_CHANNEL             = 0x60
        POWER_LEVEL               = 0x73
        PROTECTION                = 0x75
        SCREEN_ATTRIBUTES         = 0x93
        SENSOR_BINARY             = 0x30
        SENSOR_MULTILEVEL         = 0x31
        SWITCH_MULTILEVEL         = 0x26
        # names and values from Zipato Micro Motor Controller Quick Install Guide v1.2 (http://www.homecontrols.com/homecontrols/products/pdfs/ZP-Zipato/ZPWTMMMCUS_Installation.pdf)
        NAMING_AND_LOCATION       = 0x77
        INDICATOR                 = 0x87
        SCENE_ACTIVATION          = 0x2B
        SCENE_ACTUATOR_CONFIG     = 0x2C
        # things we've seen in reversing but don't know what they are yet
        COMMAND_CLASS_UNKNOWN_1   = 0x91 # seen on the Leviton VRCS4-MRZ
        COMMAND_CLASS_UNKNOWN_2   = 0x2D # seen on the Leviton VRCS4-MRZ
        COMMAND_CLASS_UNKNOWN_3   = 0x7C # seen on the Leviton VRCS4-MRZ
        COMMAND_CLASS_UNKNOWN_4   = 0x82 # seen on the Leviton VRCS4-MRZ
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
      
      # names made up, values from reversing
      class DeviceUpdate
        STATUS_UPDATE     = 0x84
      end
    end
  end
end
