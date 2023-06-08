//
//  NSEvent+Extension.swift
//  MacEvents
//
//  Created by Yueting Weng on 2023/5/24.
//

import Foundation
import AppKit

extension NSEvent.EventType {
    
    func matches(_ masks: NSEvent.EventType...) -> Bool {
        return masks.contains(self)
    }
    
    func matches(_ masks: [NSEvent.EventType]) -> Bool {
        return masks.contains(self)
    }
}

extension NSEvent.EventType : CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .leftMouseDown:
            return "leftMouseDown"
        case .leftMouseUp:
            return "leftMouseUp"
        case .leftMouseDragged:
            return "leftMouseDragged"
        case .rightMouseUp:
            return "rightMouseUp"
        case .rightMouseDown:
            return "rightMouseDown"
        case .rightMouseDragged:
            return "rightMouseDragged"
        case .keyUp:
            return "keyUp"
        case .keyDown:
            return "keyDown"
        case .mouseEntered:
            return "mouseEntered"
        case .mouseMoved:
            return "mouseMoved"
        case .mouseExited:
            return "mouseExited"
        case .scrollWheel:
            return "scrollWheel"
        case .swipe:
            return "swipe"
        default:
            return "undefined" //TODO: expand this.
        }
    }
}

extension NSEvent {
    
    var click: Int {
        if type.matches(ConstDef.EventType.touchpad) {
            return clickCount
        } else {
            return 0
        }
    }
    
    var pressedKey: String {
        if type.matches(ConstDef.EventType.keyboard), let charactersIgnoringModifiers {
            return charactersIgnoringModifiers
        } else {
            return ConstDef.Error.undefinedKey
        }
    }
}
