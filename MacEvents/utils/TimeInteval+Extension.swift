//
//  TimeInteval+Extension.swift
//  MacEvents
//
//  Created by Yueting Weng on 2023/5/24.
//

import Foundation

extension TimeInterval {
    
    func formatted(_ format: String) -> String {
        let systemUptime = ProcessInfo.processInfo.systemUptime
        let eventTime = Date(timeIntervalSinceNow: -systemUptime + self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: eventTime)
    }
}
