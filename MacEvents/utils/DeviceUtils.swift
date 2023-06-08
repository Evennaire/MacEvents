//
//  DeviceUtils.swift
//  MacEvents
//
//  Created by Yueting Weng on 2023/5/25.
//

import Foundation
import IOKit
import AppKit

enum DeviceUtils {
    
    static var uuid: String? {
        let platformExpert = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceMatching("IOPlatformExpertDevice"))
        if platformExpert != IO_OBJECT_NULL {
            let serialNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert, "IOPlatformUUID" as CFString, kCFAllocatorDefault, 0)
            IOObjectRelease(platformExpert)
            if let serialNumber = serialNumberAsCFString?.takeRetainedValue() as? String {
                return serialNumber
            }
        }
        return nil
    }
    
    static var height: CGFloat {
        let screenFrame = NSScreen.main?.frame
        let screenHeight = screenFrame?.size.height ?? 0.0
        return screenHeight
    }
}
