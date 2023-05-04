//
//  VisitorDelegate.swift
//  MacEvents
//
//  Created by Yueting Weng on 2023/5/3.
//

import Foundation

protocol VisitorDelegate {
    func visit(_ event: KeyboardEvent)
    func visit(_ event: MouseEvent)
}
