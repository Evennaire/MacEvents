//
//  NSEvent+Serialization.swift
//  MacEvents
//
//  Created by Yueting Weng on 2023/5/3.
//

import AppKit

extension NSEvent {
    
    func asKeyboardEvent() -> KeyboardEvent {
        return .init(type: self.type.rawValue,
                     winId: self.windowNumber,
                     timestamp: self.timestamp,
                     keyCode: self.keyCode,
                     char: self.characters!)
    }
    
    func asMouseEvent() -> MouseEvent {
        return .init(type: self.type.rawValue,
                     winId: self.windowNumber,
                     timestamp: self.timestamp,
                     x: self.locationInWindow.x,
                     y: self.locationInWindow.y,
                     click: self.clickCount)
    }
}
