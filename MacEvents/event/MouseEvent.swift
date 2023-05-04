//
//  MouseEvent.swift
//  MacEvents
//
//  Created by Yueting Weng on 2023/5/3.
//

import AppKit

struct MouseEvent: BaseEvent, Codable {
    
    var type: UInt
    
    var winId: Int
    
    var timestamp: TimeInterval
    
    let x: Double
    
    let y: Double
    
    let click: Int
    
    func accept(_ visitor: VisitorDelegate) { visitor.visit(self) }
}
