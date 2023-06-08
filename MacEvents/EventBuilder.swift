//
//  EventBuilder.swift
//  MacEvents
//
//  Created by Yueting Weng on 2023/6/7.
//

import Foundation
import AppKit

final class EventBuilder: Buildable {

    var attributes = Attributes()

    func addTimestamp(_ duration: TimeInterval, withFormat format: String) -> EventBuilder {
        addKey(duration.formatted(format), forKey: "timestamp")
        return self
    }

    func addEvent(_ rawValue: UInt) -> EventBuilder {
        addKey("\(NSEvent.EventType(rawValue: rawValue)!)", forKey: "event")
        return self
    }

    func addPosition(_ position: NSPoint) -> EventBuilder {
        addKey(position.x, forKey: "x")
        addKey(position.y, forKey: "y")
        return self
    }

    func addID(_ uuidString: String) -> EventBuilder {
        addKey(uuidString, forKey: "uuid")
        return self
    }

    func addClipboard() -> EventBuilder {
        var clipboardList: [String] = []
        if let pasteboardItems = NSPasteboard.general.pasteboardItems {
            for item in pasteboardItems {
                for type in item.types {
                    if type.rawValue == "public.utf8-plain-text" {
                        if let string = item.string(forType: type) {
                            clipboardList.append(string)
                        }
                    }
                }
            }
        }
        
        addKey(clipboardList, forKey: "clipboard")
        return self
    }

    func addContext() -> EventBuilder {
        let runningApps = NSWorkspace.shared.runningApplications
        var windowList: [String] = []
        var windowCount: Int = 0
        for app in runningApps {
            guard app.activationPolicy == .regular else {
                continue
            }
            if let localizedName = app.localizedName {
                windowList.append(localizedName)
                windowCount += 1
            }
        }
        
        let context: [String: Any] = [
            "windows_cnt": windowCount,
            "windows_list": windowList,
            "changed": false
        ]
        
        addKey(context, forKey: "context")
        return self
    }

    func addClick(_ clickAmount: Int, _ withConditionallyChecked: () -> Bool) -> EventBuilder {
        addKey(clickAmount, forKey: "click", withConditionallyChecked)
        return self
    }

    func addContinuity(_ deltaX: CGFloat, _ deltaY: CGFloat, _ withConditionallyChecked: () -> Bool) -> EventBuilder {
        addKey(deltaX, forKey: "deltaX", withConditionallyChecked)
        addKey(deltaY, forKey: "deltaY", withConditionallyChecked)
        return self
    }

    func addPressedKey(_ key: String, _ withConditionallyChecked: () -> Bool) -> EventBuilder {
        addKey(key, forKey: "character", withConditionallyChecked)
        return self
    }
}

