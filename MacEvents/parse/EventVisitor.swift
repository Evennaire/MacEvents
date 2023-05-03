//
//  EventVisitor.swift
//  MacEvents
//
//  Created by Yueting Weng on 2023/5/3.
//

import Foundation
import SwiftyJSON

class EventVisitor: VisitorDelegate {
    
    func visit(_ event: KeyboardEvent) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(event), let json = try? JSON(data: data) {
            print(json)
        }
    }
    
    func visit(_ event: MouseEvent) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(event), let json = try? JSON(data: data) {
            print(json)
        }
    }
}
