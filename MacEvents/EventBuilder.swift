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
        var instance = self
        instance.addKey(duration.formatted(format), forKey: "timestamp")
        return instance
    }

    func addEvent(_ rawValue: UInt) -> EventBuilder {
        var instance = self
        instance.addKey("\(NSEvent.EventType(rawValue: rawValue)!)", forKey: "event")
        return instance
    }

    func addPosition(_ position: NSPoint) -> EventBuilder {
        var instance = self
        instance.addKey(position.x, forKey: "x")
        instance.addKey(position.y, forKey: "y")
        return instance
    }

    func addID(_ uuidString: String) -> EventBuilder {
        var instance = self
        instance.addKey(uuidString, forKey: "uuid")
        return instance
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
        var instance = self
        instance.addKey(clipboardList, forKey: "clipboard")
        return instance
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
        
        var instance = self
        instance.addKey(context, forKey: "context")
        return instance
    }

    func addClick(_ clickAmount: Int, _ withConditionallyChecked: () -> Bool) -> EventBuilder {
        var instance = self
        instance.addKey(clickAmount, forKey: "click", withConditionallyChecked)
        return instance
    }

    func addContinuity(_ deltaX: CGFloat, _ deltaY: CGFloat, _ withConditionallyChecked: () -> Bool) -> EventBuilder {
        var instance = self
        instance.addKey(deltaX, forKey: "deltaX", withConditionallyChecked)
        instance.addKey(deltaY, forKey: "deltaY", withConditionallyChecked)
        return instance
    }

    func addPressedKey(_ key: String, _ withConditionallyChecked: () -> Bool) -> EventBuilder {
        var instance = self
        instance.addKey(key, forKey: "character", withConditionallyChecked)
        return instance
    }
}

