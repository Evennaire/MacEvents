//
//  Reflectable.swift
//  MacEvents
//
//  Created by Yueting Weng on 2023/5/24.
//

import Foundation
import AppKit
import SwiftyJSON
import AXSwift

protocol Reflectable {
    
    /// transform objects to key-value pairs.
    func reflected() -> [String: Any?]
}

extension Reflectable {
    
    /// transform PureSwift objects to key-value pairs.
    func reflected() -> [String: Any?] {
        let mirror = Mirror(reflecting: self)
        var dict: [String: Any?] = [:]
        for child in mirror.children {
            guard let key = child.label else { continue }
            dict[key] = child.value
        }
        return dict
    }
}

extension Reflectable where Self : NSObject {

    /// transform non-Swift KVC-Compliant objects to key-value pairs.
    func reflected() -> [String : Any?] {
        var count: UInt32 = 0
        guard let properties = class_copyPropertyList(Self.self, &count) else {
            return [:]
        }
        
        var dict: [String: Any] = [:]
        for i in 0..<Int(count) {
            let name = property_getName(properties[i])
            guard let nsKey = NSString(utf8String: name) else {
                continue
            }
            let key = nsKey as String
            guard responds(to: Selector(key)) else {
                continue
            }
            dict[key] = value(forKey: key)
        }
        
        free(properties)
        return dict
    }
}

extension NSEvent : Reflectable {

    /// transform non-Swift non-KVC-Compliant objects (NSEvent Specified) to
    /// key-value pairs.
    func reflected() -> [String : Any?]  {
        var dict = [String : Any?]()
        dict["timestamp"] = Int64(Date().timeIntervalSince1970 * 1000)
        dict["event"] = "\(EventType(rawValue: type.rawValue)!)"
        dict["x"] = locationInWindow.x
        dict["y"] = locationInWindow.y
        dict["uuid"] = getDeviceUUID()
        
        switch type {
        case .leftMouseDown, .rightMouseDown:
            dict["click"] = clickCount
        case .scrollWheel, .swipe, .leftMouseDragged, .rightMouseDragged:
            dict["deltaX"] = deltaX
            dict["deltaY"] = deltaY
        case .keyUp, .keyDown:
            dict["character"] = charactersIgnoringModifiers ?? "undefined"
        default:
            break
        }
        
        if let application = NSWorkspace.shared.frontmostApplication {
            dict["focusedWindow"] = application.localizedName
        }
        
        return dict
    }
}
