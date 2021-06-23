//
//  UIDevice+Devices.swift
//  CEUserControls
//
//  Created by Christoph Erl on 17.03.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit

public enum UCModelCategory {
    case iPhone4, iPhone5, iPhone6, iPhone6Plus, iPad, iPadRetina, iPadPro, none
}

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return kIPod5
        case "iPod7,1":                                 return kIPod6
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return kIPhone4
        case "iPhone4,1":                               return kIPhone4s
        case "iPhone5,1", "iPhone5,2":                  return kIPhone5
        case "iPhone5,3", "iPhone5,4":                  return kIPhone5c
        case "iPhone6,1", "iPhone6,2":                  return kIPhone5s
        case "iPhone7,2":                               return kIPhone6
        case "iPhone7,1":                               return kIPhone6Plus
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
 
    }
    
    var modelCategory: UCModelCategory {
        switch modelName {
            case kIPhone6, kIPhone6s:                                                       return .iPhone6
            case kIPhone5, kIPhone5s, kIPhone5c:                                            return .iPhone5
            case kIPhone4, kIPhone4s:                                                       return .iPhone4
            case kIPad2, kIPadMini:                                                         return .iPad
            case kIPad3, kIPad4, kIPadAir, kIPadAir2, kIPadMini2, kIPadMini3, kIPadMini4:   return .iPadRetina
            case kIPhone6Plus, kIPhone6sPlus:                                               return .iPhone6Plus
            default:                                                                        return .none
        }
    }
    
    
}

// Constants


private let kIPod5          = "iPod Touch 5"
private let kIPod6          = "iPod Touch 6"
private let kIPhone4        = "iPhone 4"
private let kIPhone4s       = "iPhone 4s"
private let kIPhone5        = "iPhone 5"
private let kIPhone5c       = "iPhone 5c"
private let kIPhone5s       = "iPhone 5s"
private let kIPhone6        = "iPhone 6"
private let kIPhone6Plus    = "iPhone 6 Plus"
private let kIPhone6s       = "iPhone 6s"
private let kIPhone6sPlus   = "iPhone 6s Plus"
private let kIPad2          = "iPad 2"
private let kIPad3          = "iPad 3"
private let kIPad4          = "iPad 4"
private let kIPadAir        = "iPad Air"
private let kIPadAir2       = "iPad Air 2"
private let kIPadMini       = "iPad Mini"
private let kIPadMini2      = "iPad Mini 2"
private let kIPadMini3      = "iPad Mini 3"
private let kIPadMini4      = "iPad Mini 4"
private let kIPadPro        = "iPad Pro"
private let kAppleTv        = "Apple TV"
private let kSimulator      = "Simulator"
