//
//  ConstDef.swift
//  MacEvents
//
//  Created by Yueting Weng on 2023/6/7.
//

import Foundation
import AppKit

enum ConstDef {
    
    enum EventType {
        static let touchpad: [NSEvent.EventType] = [.leftMouseDown, .leftMouseUp, .rightMouseUp, .rightMouseDown]
        static let keyboard: [NSEvent.EventType] = [.keyUp, .keyDown]
        static let panning: [NSEvent.EventType] = [.scrollWheel, .swipe, .leftMouseDragged, .rightMouseDragged]
    }
    
    enum Error {
        static let undefinedKey = "undefinedKey"
        static let unknownString = "unknown"
        static let titleNotFound = "titleNotFound"
    }
}
