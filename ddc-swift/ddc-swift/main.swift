//
//  main.swift
//  ddc-swift
//
//  Created by Philipp on 21.10.19.
//  Copyright © 2019 Philipp. All rights reserved.
//

import Foundation
import CoreGraphics

import IOKit



// ------------------------------------------------------------------
enum DDC_CI_OpCode: UInt8 {
    case IDENTIFICATION_REQUEST = 0xF1
    case IDENTIFICATION_REPLY = 0xE1
    case CAPABILITIES_REQUEST = 0xF3
    case CAPABILITIES_REPLY = 0xE3
    case DISPLAY_SELF_TEST_REQUEST = 0xB1
    case DISPLAY_SELF_TEST_REPLY = 0xA1
    case TIMING_REQUEST = 0x07
    case TIMING_REPLY = 0x06
    case VCP_REQUEST = 0x01
    case VCP_REPLY = 0x02
    case VCP_SET = 0x03
    case VCP_RESET = 0x09
    case TABLE_READ_REQUEST = 0xE2
    case TABLE_READ_REPLY = 0xE4
    case TABLE_WRITE = 0xE7
    case ENABLE_APPLICATION_REPORT = 0xF5
    case SAVE_CURRENT_SETTINGS = 0x0C
}

// Virtual Control Panel Codes (see VESA MCCS standard)
enum VCP_OpCode: UInt8 {
    // Preset Operations
    case CODE_PAGE = 0x00
    case RESET = 0x04
    case RESET_BRIGHTNESS_AND_CONTRAST = 0x05
    case RESET_GEOMETRY = 0x06
    case RESET_COLOR = 0x08
    case RESET_TV = 0x0A
    case SETTINGS = 0xB0

    // --------------------------------
    // Image Adjustment
    
    case CUSTOM_COLOR_TEMP_INCR = 0x0B
    case CUSTOM_COLOR_TEMP = 0x0C
    
    case CLOCK = 0x0E
    case LUMINANCE = 0x10
    case FLESH_TONE_ENHC = 0x11
    case CONTRAST = 0x12
    //case BACKLIGHT_CTRL = 0x13 // deprecated!
    case SELECT_COLOR_PRESET = 0x14     // Presets: 1=sRGB, 2=Display native, 3=4000K, 4=5000K, 5=6500K, 6=7500K, 7=8200K, 8=9300K, 9=10000K, 10=11500K, 11 = Custom 1, 12 = Custom 2, 13 = Custom 3
    case RED_GAIN = 0x16
    case USER_COLOR_VISION_COMPENSATION = 0x17
    case GREEN_GAIN = 0x18
    case BLUE_GAIN = 0x1A
    case FOCUS = 0x1C
    case AUTO_SETUP = 0x1E
    case AUTO_COLOR_SETUP = 0x1F
    case GRAY_SCALE_EXPANSION = 0x2E
    case CLOCK_PHASE = 0x3E
    case HORIZONTAL_MOIRE_CANCEL = 0x56
    case VERTICAL_MOIRE_CANCEL = 0x58
    case SIX_AXIS_SATURATION_CTRL_RED = 0x59
    case SIX_AXIS_SATURATION_CTRL_YELLOW = 0x5A
    case SIX_AXIS_SATURATION_CTRL_GREEN = 0x5B
    case SIX_AXIS_SATURATION_CTRL_CYAN = 0x5C
    case SIX_AXIS_SATURATION_CTRL_BLUE = 0x5D
    case SIX_AXIS_SATURATION_CTRL_MAGENTA = 0x5E
    case BACKLIGHT_LEVEL_WHITE = 0x6B
    case VIDEO_BACKLEVEL_RED = 0x6C
    case BACKLIGHT_LEVEL_RED = 0x6D
    case VIDEO_BACKLEVEL_GREEN = 0x6E
    case BACKLIGHT_LEVEL_GREEN = 0x6F
    case VIDEO_BACKLEVEL_BLUE = 0x70
    case BACKLIGHT_LEVEL_BLUE = 0x71
    case GAMMA = 0x72
    case LUT_SIZE = 0x73
    case SINGLE_POINT_LUT_OP = 0x74
    case BLOCK_LUT_OP = 0x75
    case ADJUST_ZOOM = 0x7C
    case SHARPNESS = 0x87
    case VELOCITY_SCAN_MODULATION = 0x88
    case COLOR_SATURATION = 0x8A
    case TV_SHARPNESS = 0x8C
    case TV_CONTRAST = 0x8E
    case HUE = 0x90
    case TV_BLACK_LEVEL_LUMNINANCE = 0x92
    case SIX_AXIS_HUE_CTRL_RED = 0x9B
    case SIX_AXIS_HUE_CTRL_YELLOW = 0x9C
    case SIX_AXIS_HUE_CTRL_GREEN = 0x9D
    case SIX_AXIS_HUE_CTRL_CYAN = 0x9E
    case SIX_AXIS_HUE_CTRL_BLUE = 0x9F
    case SIX_AXIS_HUE_CTRL_MAGENTA = 0xA0
    case AUTO_SETUP_TOGGLE = 0xA2
    case WINDOW_MASK_CTRL = 0xA4
    case WINDOW_SELECT = 0xA5
    case WINDOW_SIZE = 0xA6
    case WINDOW_TRANSPARENCY = 0xA7
    case SCREEN_ORIENTATION = 0xAA
    case STEREO_VIDEO_MODE = 0xD4
    case DISPLAY_APPLICATION = 0xDC

    // --------------------------------
    // Display Control
    case HORIZONTAL_FREQUENCY = 0xAC
    case VERTICAL_FREQUENCY = 0xAE
    case SOURCE_TIMING_MODE = 0xB4
    case SOURCE_COLOR_CODING = 0xB5
    case DISPLAY_USAGE_TIME = 0xC0
    case DISPLAY_CONTROLLER_ID = 0xC8
    case DISPLAY_FIRMWARE_LEVEL = 0xC9
    case OSD_BUTTON_EVENT_CONTROL = 0xCA
    case OSD_LANG = 0xCC
    case POWER_MODE = 0xD6
    case IMAGE_MODE = 0xDB
    case VCP_VERION = 0xDF

    // --------------------------------
    // Geometry
    case HORIZONTAL_POS = 0x20
    case HORIZONTAL_SIZE = 0x22
    case HORIZONTAL_PINCUSHION = 0x24
    case HORIZONTAL_PINCUSHION_BALANCE = 0x26
    case HORIZONTAL_CONVERGENCE_RB = 0x28
    case HORIZONTAL_CONVERGENCE_MG = 0x29
    case HORIZONTAL_LINEARITY = 0x2A
    case HORIZONTAL_LINEARITY_BALANCE = 0x2C
    case VERTICAL_POS = 0x30
    case VERTICAL_SIZE = 0x32
    case VERTICAL_PINCUSHION = 0x34
    case VERTICAL_PINCUSHION_BALANCE = 0x36
    case VERTICAL_CONVERGENCE_RB = 0x38
    case VERTICAL_CONVERGENCE_MG = 0x39
    case VERTICAL_LINEARITY = 0x3A
    case VERTICAL_LINEARITY_BALANCE = 0x3C
    case HORIZONTAL_PARALLELOGRAM = 0x40
    case VERTICAL_PARALLELOGRAM = 0x41
    case HORIZONTAL_KEYSTONE = 0x42
    case VERTICAL_KEYSTONE = 0x43
    case ROTATION = 0x44
    case TOP_CORNER_FLARE = 0x46
    case TOP_CORNER_HOOK = 0x48
    case BOTTOM_CORNER_FLARE = 0x4A
    case BOTTOM_CORNER_HOOK = 0x4C
    case HORIZONTAL_MIRROR = 0x82
    case VERTICAL_MIRROR = 0x84
    case DISPLAY_SCALING = 0x86
    case WINDOW_POS_TOP_LEFT_X = 0x95
    case WINDOW_POS_TOP_LEFT_Y = 0x96
    case WINDOW_POS_BOTTOM_RIGHT_X = 0x97
    case WINDOW_POS_BOTTOM_RIGHT_Y = 0x98
    case SCAN_MODE = 0xDA

    // --------------------------------
    // Misc functions
    case DEGAUSS = 0x01
    case NEW_CTRL_VALUE = 0x02
    case SOFT_CONTROLS = 0x03
    case ACTIVE_CONTROL = 0x52
    case PERFORMANCE_PRESERVATION = 0x54
    case INPUT_SELECT = 0x60
    case AMBIENT_LIGHT_SENSOR = 0x66
    case REMOTE_PROCEDURE_CALL = 0x76
    case DISPLAY_IDENTIFICATION_DATA_OP = 0x78
    case TV_CHANNEL_UP_DOWN = 0x8B
    case FLAT_PANEL_SUB_PIXEL_LAYOUT = 0xB2
    case DISPLAY_TECHNOLOGY_TYPE = 0xB6
    case DISPLAY_DESCRIPTOR_LENGTH = 0xC2
    case TRANSMIT_DISPLAY_DESCRIPTOR = 0xC3
    case ENABLE_DISPLAY_OF_DISPLAY_DESCRIPTOR = 0xC4
    case APPLICATION_ENABLE_KEY = 0xC6
    //case DISPLAY_ENABLE_KEY = 0xC7 // Deprecated
    case STATUS_INDICATORS = 0xCD
    case AUXILIARY_DISPLAY_SIZE = 0xCE
    case AUXILIARY_DISPLAY_DATA = 0xCF
    case OUTPUT_SELECT = 0xD0
    case ASSET_TAG = 0xD2
    case AUXILIARY_POWER_OUTPUT = 0xD7
    case SCRATCH_PAD = 0xDE

    // --------------------------------
    // Audio
    case AUDIO_SPEAKER_VOLUME = 0x62
    case AUDIO_SPEAKER_SELECT = 0x63
    case AUDIO_MICROPHONE_VOLUME = 0x64
    case AUDIO_JACK_CONNECTION_STATUS = 0x65
    case AUDIO_MUTE = 0x8D
    case AUDIO_TREBLE = 0x8F
    case AUDIO_BASS = 0x91
    case AUDIO_BALANCE_LR = 0x93
    case AUDIO_PROCESSOR_MODE = 0x94

    // --------------------------------
    // DPVL Support
    case MONITOR_STATUS = 0xB7
    case PACKET_COUNT = 0xB8
    case MONITOR_X_ORIGIN = 0xB9
    case MONITOR_Y_ORIGIN = 0xBA
    case HEADER_ERROR_COUNT = 0xBB
    case BODY_CRC_ERROR_COUNT = 0xBC
    case CLIENT_ID = 0xBD
    case LINK_CONTROL = 0xBE
    
    // --------------------------------
    // Manufacturer specific: 0xE0 to 0xFF
}

struct DDCWriteCommand
{
    let control : VCP_OpCode
    let new_value : UInt16
}

struct DDCReadCommand
{
    let control : VCP_OpCode
    var success = false
    var max_value : UInt16 = 0
    var current_value : UInt16 = 0
}

struct DDCDisplayInfo {
    let displayID : CGDirectDisplayID
    let name : String
    let serial : Int
    let width : Int
    let height : Int
    let isMain : Bool
    let isBuiltin : Bool
}

// ------------------------------------------------------------------
func DDCGetDisplayList() -> [DDCDisplayInfo] {
    var displayList = [DDCDisplayInfo]()
    var numberOfDisplays: CGDisplayCount = 0

    // get number of active display
    if CGGetActiveDisplayList(0, nil, &numberOfDisplays) != .success {
        fatalError("Unable to get list of active display")
    }

    // Allocate memory for the IDs
    let displayIDsPointer = UnsafeMutablePointer<CGDirectDisplayID>.allocate(capacity: Int(numberOfDisplays))
    displayIDsPointer.initialize(repeating: 0, count: Int(numberOfDisplays))
    if CGGetActiveDisplayList(numberOfDisplays, displayIDsPointer, &numberOfDisplays) != .success {
        fatalError("Unable to get list of active display")
    }

    // Iterate over the IDs and create a list of DDCDisplay
    let bufferPointer = UnsafeBufferPointer(start: displayIDsPointer, count: Int(numberOfDisplays))
    for (_, displayID) in bufferPointer.enumerated() {
        let bounds = CGDisplayBounds(displayID)
        let display = DDCDisplayInfo(displayID: displayID, name: "", serial: 0, width: Int(bounds.width), height: Int(bounds.height), isMain: CGDisplayIsMain(displayID)>0, isBuiltin: CGDisplayIsBuiltin(displayID)>0)

        displayList.append(display)
    }
    return displayList
}


// ------------------------------------------------------------------
func IOFramebufferPortFromCGDisplayID(displayID: CGDirectDisplayID) -> io_service_t {
    print("IOFramebufferPortFromCGDisplayID(\(displayID)):")
    var iter = io_iterator_t()
    var servicePort : io_service_t = 0

    let err = IOServiceGetMatchingServices(kIOMasterPortDefault, IOServiceMatching(IOFRAMEBUFFER_CONFORMSTO), &iter)
    if (err != KERN_SUCCESS) {
        return 0
    }
    
    let displayVendorNumber = CGDisplayVendorNumber(displayID)
    let displayModelNumber = CGDisplayModelNumber(displayID)
    let displaySerialNumber = CGDisplaySerialNumber(displayID)
    print("Searching for\n    vendor=\(displayVendorNumber) product=\(displayModelNumber) serial=\(displaySerialNumber)")

    var serv : io_service_t
    repeat {
        serv = IOIteratorNext(iter)
        if (serv == MACH_PORT_NULL) {
            print("End of list")
            continue
        }
        
        var deviceNameCString: [CChar] = Array(repeating: 0, count: 128)
        let deviceNameResult = IORegistryEntryGetName(serv, &deviceNameCString)
        
        if(deviceNameResult != kIOReturnSuccess) {
            print("Skipping display: Error getting device name")
            continue
        }
        
        let deviceName = String(cString: &deviceNameCString)
        
        // Get info dictionnary for our display device
        if let info = IODisplayCreateInfoDictionary(serv, IOOptionBits(kIODisplayOnlyPreferredName)).takeUnretainedValue() as? [String: AnyObject], info[kIODisplayLocationKey] as! String != "unknown" {
            
//            for key in info.keys.sorted() {
//                print("\(key) : \(info[key]!)")
//            }
            let serialNumber = info[kDisplaySerialNumber] as? Int ?? 0
            let vendorID = info[kDisplayVendorID] as? Int ?? 0
            let productID = info[kDisplayProductID] as? Int ?? 0
            let productName = (info[kDisplayProductName] as! [String:String])["en_US"]!
            
            // Check whether we can access the I2C bus
            var busCount = IOItemCount()
            IOFBGetI2CInterfaceCount(serv, &busCount)
            
            if busCount < 1 {
                print("Skipping display without I2C bus")
                continue
            }
            if CGDisplayIsBuiltin(displayID) != 0 {
                print("Skipping display: is built-in")
                continue
            }
            
            if vendorID != displayVendorNumber || productID != displayModelNumber || serialNumber != displaySerialNumber {
                print("Skipping display: not searched monitor")
                continue
            }
            
            print("Device Name: \(deviceName) \(productName)")
            print("    vendor=\(vendorID) product=\(productID) serial=\(serialNumber)")
            servicePort = serv
            break
        }
        else {
            print("Skipping display: Unable to create info dictionnary")
            continue
        }
        
    } while(serv != MACH_PORT_NULL)
    
    IOObjectRelease(iter)
    
    return servicePort
}


// ------------------------------------------------------------------
func DisplayRequest(displayID: CGDirectDisplayID, request: inout IOI2CRequest) -> Bool {
//    dispatch_semaphore_t queue = DisplayQueue(displayID)
//    dispatch_semaphore_wait(queue, DISPATCH_TIME_FOREVER)

    var result = false

    // Find io port for given CGDirectDisplayID
    let io_port = IOFramebufferPortFromCGDisplayID(displayID: displayID)
    if io_port > 0 {
        var i2cBusCount = IOItemCount()
        if IOFBGetI2CInterfaceCount(io_port, &i2cBusCount) == KERN_SUCCESS {
            print("io_port=\(io_port) i2cBusCount=\(i2cBusCount)")
            for i in 0..<i2cBusCount {
                var interface = io_service_t()
                if IOFBCopyI2CInterfaceForBus(io_port, IOOptionBits(i), &interface) != KERN_SUCCESS {
                    continue
                }

                var connect = IOI2CConnectRef(bitPattern: 0)
                if IOI2CInterfaceOpen(interface, IOOptionBits(), &connect) == KERN_SUCCESS {
                    result = (IOI2CSendRequest(connect, IOOptionBits(), &request) == KERN_SUCCESS)
                    print("D: Sent request to I2C bus result=\(result) request.result=\(request.result)")
                    IOI2CInterfaceClose(connect, IOOptionBits())
                }

                IOObjectRelease(interface)
                if result {
                  break
                }
            }
        }
        IOObjectRelease(io_port)
    }
    if (request.replyTransactionType == kIOI2CNoTransactionType) {
        usleep(20000)
    }
//    dispatch_semaphore_signal(queue)
    return result && request.result == KERN_SUCCESS
}


// ------------------------------------------------------------------
func DDCRead(displayID: CGDirectDisplayID, read: inout DDCReadCommand) -> Bool {
    
    let kMaxRequests = 3

    for i in 1...kMaxRequests {
        var result = false

        // Allocate data memory
        let reply_data = [UInt8](repeating: 0, count: 11)
        var data = [UInt8](repeating: 0, count: 128)

        var request = IOI2CRequest()
        request.commFlags           = 0
        request.sendAddress         = 0x6E // Destination address: Display
        request.sendTransactionType = IOOptionBits(kIOI2CSimpleTransactionType)
        request.sendBuffer          = vm_address_t(bitPattern: OpaquePointer(data))
        request.sendBytes           = 5

        // Certain displays / graphics cards require a long-enough delay to give a response.
        // Should correspond to atleast 40ms
        request.minReplyDelay        = 100  // too short can freeze kernel
        
        data[0] = 0x51  // Source address: Host
        data[1] = 0x82  // Length
        data[2] = DDC_CI_OpCode.VCP_REQUEST.rawValue  // VCP Request op code
        data[3] = read.control.rawValue  // VCP opcode
        data[4] = 0x6E ^ data[0] ^ data[1] ^ data[2] ^ data[3]
        request.replyTransactionType = IOOptionBits(kIOI2CSimpleTransactionType)
        request.replyAddress         = 0x6F // Destination address: Host
        request.replySubAddress      = 0x51 // ?
        
        request.replyBuffer = vm_address_t(bitPattern: OpaquePointer(reply_data))
        request.replyBytes = 11

        // Send I2C request
        result = DisplayRequest(displayID: displayID, request: &request)

        // Check consistency of reply data
        let chksumVal : UInt8 = UInt8(request.replyAddress & 255) ^ request.replySubAddress
            ^ (reply_data[1] ^ reply_data[2] ^ reply_data[3] ^ reply_data[4])
            ^ (reply_data[5] ^ reply_data[6] ^ reply_data[7] ^ reply_data[8])
            ^ reply_data[9]
        result = (result
            && reply_data[0] == request.sendAddress
            && reply_data[2] == DDC_CI_OpCode.VCP_REPLY.rawValue // VCP Reply op code
            && reply_data[4] == read.control.rawValue
            && reply_data[10] == chksumVal)

        // check VCP result code: 00 = OK, 01 = Unsupported
        if reply_data[3] == 01 {
            print("D: VCP feature \(reply_data[4]) is not supported")
        }
        
        if result {
            read.success = true
            read.max_value = UInt16(reply_data[6])<<8 + UInt16(reply_data[7])
            read.current_value = UInt16(reply_data[8])<<8 + UInt16(reply_data[9])
            if i > 1 {
                print("D: Get data after \(i) tries")
            }
            return true
        }
        if request.result == kIOReturnUnsupportedMode {
            print("E: Unsupported Transaction Type!")
        }
        
        usleep(40000) // 40msec -> See DDC/CI Vesa Standard - 4.4.1 Communication Error Recovery
    }
    read.success = false
    read.max_value = 0
    read.current_value = 0
    print("E: No data after \(kMaxRequests) tries!")

    return false
}


// ------------------------------------------------------------------
func DDCWrite(displayID: CGDirectDisplayID, write: inout DDCWriteCommand) -> Bool {

    // Allocate data memory
    var data = [UInt8](repeating: 0, count: 128)

    var request = IOI2CRequest()

    request.commFlags           = 0

    request.sendAddress         = 0x6E  // Destination address: Display
    request.sendTransactionType = IOOptionBits(kIOI2CSimpleTransactionType)
    request.sendBuffer          = vm_address_t(bitPattern: OpaquePointer(data))
    request.sendBytes           = 7
    
    data[0] = 0x51  // Source address: Host
    data[1] = 0x84  // Length
    data[2] = DDC_CI_OpCode.VCP_SET.rawValue  // VCP Set op code
    data[3] = write.control.rawValue
    data[4] = UInt8(write.new_value >> 8)
    data[5] = UInt8(write.new_value & 255)
    data[6] = 0x6E ^ data[0] ^ data[1] ^ data[2] ^ data[3] ^ data[4] ^ data[5]

    request.replyTransactionType = IOOptionBits(kIOI2CNoTransactionType)
    request.replyBytes           = 0

    // Send I2C request
    let result = DisplayRequest(displayID: displayID, request: &request)
    
    return result
}


// ------------------------------------------------------------------
print("Scanning for Monitors")

let displays = DDCGetDisplayList()
print("displays", displays)


print("------------------------------------\n-- DDCWrite")
var result = false

var write = DDCWriteCommand(control: .LUMINANCE, new_value: 40)
result = DDCWrite(displayID: displays[0].displayID, write: &write)
print("DDCWrite: result=\(result)")

usleep(50000) // wait a minimum before processing another command

print("------------------------------------\n-- DDCRead")
var read = DDCReadCommand(control: .LUMINANCE)
result = DDCRead(displayID: displays[0].displayID, read: &read)
print("DDCRead: result=\(result) success=\(read.success) current_value=\(read.current_value) max_value=\(read.max_value)")
