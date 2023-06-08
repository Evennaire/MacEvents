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
    
    typealias Output = [String: Any?]
    
    /// transform objects to key-value pairs.
    func reflected() -> Output
}

extension Reflectable {
    
    /// transform PureSwift objects to key-value pairs.
    func reflected() -> Output {
        let mirror = Mirror(reflecting: self)
        var dict: Output = [:]
        for child in mirror.children {
            guard let key = child.label else { continue }
            dict[key] = child.value
        }
        return dict
    }
}

extension Reflectable where Self : NSObject {

    /// transform non-Swift KVC-Compliant objects to key-value pairs.
    func reflected() -> Output {
        var count: UInt32 = 0
        guard let properties = class_copyPropertyList(Self.self, &count) else {
            return [:]
        }
        
        var dict: Output = [:]
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
    func reflected() -> Output {
        var eventOutput = EventBuilder()
            .addTimestamp(timestamp, withFormat: "yyyy-MM-dd HH:mm:ss")
            .addEvent(type.rawValue)
            .addPosition(locationInWindow)
            .addID(DeviceUtils.uuid ?? ConstDef.Error.unknownString)
            .addClipboard()
            .addContext()
            .addClick(click) {
                type.matches(ConstDef.EventType.touchpad)
            }
            .addContinuity(deltaX, deltaY) {
                type.matches(ConstDef.EventType.panning)
            }
            .addPressedKey(pressedKey) {
                type.matches(ConstDef.EventType.keyboard)
            }
            .build()
        
        if let application = NSWorkspace.shared.frontmostApplication, let wrappedApplication = Application(application) {
            eventOutput["focusedWindow"] = application.localizedName
            var accessibilityElement: AXUIElement?
            AXUIElementCopyElementAtPosition(wrappedApplication.element, Float(locationInWindow.x), Float(DeviceUtils.height - locationInWindow.y), &accessibilityElement)
            if let accessibilityElement {
                let accessibilityOutput = AccessibilityBuilder(accessibilityElement)
                    .addTitle(x: locationInWindow.x, y: DeviceUtils.height - locationInWindow.y)
                    .addRole()
                    .build()
                eventOutput["element"] = accessibilityOutput
            }
        }
        
        return eventOutput
    }
}


