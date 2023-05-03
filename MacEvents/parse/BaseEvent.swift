//
//  BaseEvent.swift
//  MacEvents
//
//  Created by Yueting Weng on 2023/5/3.
//

import Foundation

protocol BaseEvent {
    
    var type: UInt { get set }
    
    var timestamp: TimeInterval { get set }
    
    var winId: Int { get set }
}
