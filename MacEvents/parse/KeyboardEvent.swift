//
//  KeyboardEvent.swift
//  MacEvents
//
//  Created by Yueting Weng on 2023/5/3.
//

import Foundation
import AppKit

struct KeyboardEvent: BaseEvent, Codable {
    
    var type: UInt
    
    var winId: Int
    
    var timestamp: TimeInterval
    
    let keyCode: UInt16
    
    let char: String
}
