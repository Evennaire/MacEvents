//
//  Buildable.swift
//  MacEvents
//
//  Created by Yueting Weng on 2023/6/7.
//

import Foundation
import SwiftyJSON

protocol Buildable: AnyObject {

    typealias Attributes = [String: Any]

    var attributes: Attributes { get set }

    @discardableResult
    func addKey(_ value: Any, forKey key: String) -> Self

    @discardableResult
    func addKey(_ value: Any, forKey key: String, _ withConditionallyChecked: () -> Bool) -> Self

    func build() -> Attributes
}

extension Buildable {

    @discardableResult
    func addKey(_ value: Any, forKey key: String) -> Self {
        attributes[key] = value
        return self
    }

    @discardableResult
    func addKey(_ value: Any, forKey key: String, _ withConditionallyChecked: () -> Bool) -> Self {
        if withConditionallyChecked() {
            attributes[key] = value
        }
        return self
    }

    func build() -> Attributes {
        return attributes
    }
}

//protocol Buildable {
//    
//    associatedtype Attributes
//    
//    var attributes: Attributes { get set }
//    
//    @discardableResult
//    mutating func addKey(_ value: Any, forKey key: String) -> Self
//    
//    @discardableResult
//    mutating func addKey(_ value: Any, forKey key: String, _ withConditionallyChecked: () -> Bool) -> Self
//    
//    func build() -> Attributes
//    
//    subscript(index: String) -> Any? { get set }
//}

//extension Buildable {
//
//    @discardableResult
//    mutating func addKey(_ value: Any, forKey key: String) -> Self {
//        self[key] = value
//        return self
//    }
//
//    @discardableResult
//    mutating func addKey(_ value: Any, forKey key: String, _ withConditionallyChecked: () -> Bool) -> Self {
//        if withConditionallyChecked() {
//            self[key] = value
//        }
//        return self
//    }
//
//    func build() -> Attributes {
//        return attributes
//    }
//
//    subscript(index: String) -> Any? {
//        get {
//            if let dict = attributes as? Dictionary<String, Any> {
//                return dict[index]
//            } else {
//                return JSON(attributes)[index].rawValue
//            }
//        }
//        set {
//            if var dict = attributes as? Dictionary<String, Any> {
//                dict[index] = newValue
//                attributes = dict as! Attributes
//            } else {
//                if var json = attributes as? JSON {
//                    if let stringValue = newValue as? String {
//                        json[index].stringValue = stringValue
//                    } else if let intValue = newValue as? Int {
//                        json[index].intValue = intValue
//                    } else if let floatValue = newValue as? Float {
//                        json[index].floatValue = floatValue
//                    } else if let doubleValue = newValue as? Double {
//                        json[index].doubleValue = doubleValue
//                    } else if let boolValue = newValue as? Bool {
//                        json[index].boolValue = boolValue
//                    } else {
//                        fatalError("Unsupported data format.")
//                    }
//                }
//            }
//        }
//    }
//}

//final class TestBuilder<Output>: Buildable where Output : Collection {
//    
//    typealias Attributes = Output
//    
//    var attributes: Output
//    
//    required init(_ attributes: Output) {
//        self.attributes = attributes
//    }
//    
//    func addTimestamp(_ duration: TimeInterval, withFormat format: String) -> TestBuilder {
//        var instance = self
//        instance.addKey(duration.formatted(format), forKey: "timestamp")
//        return instance
//    }
//    
//    func addEvent(_ rawValue: UInt) -> EventBuilder {
//        var instance = self
//        instance.addKey("\(NSEvent.EventType(rawValue: rawValue)!)", forKey: "event")
//        return instance
//    }
//    
//    func addPosition(_ position: NSPoint) -> EventBuilder {
//        var instance = self
//        instance.addKey(position.x, forKey: "x")
//        instance.addKey(position.y, forKey: "y")
//        return instance
//    }
//    
//    func addID(_ uuidString: String) -> EventBuilder {
//        var instance = self
//        instance.addKey(uuidString, forKey: "uuid")
//        return instance
//    }
//    
//    func addClipboard() -> EventBuilder {
//        var clipboardList: [String] = []
//        if let pasteboardItems = NSPasteboard.general.pasteboardItems {
//            for item in pasteboardItems {
//                for type in item.types {
//                    if type.rawValue == "public.utf8-plain-text" {
//                        if let string = item.string(forType: type) {
//                            clipboardList.append(string)
//                        }
//                    }
//                }
//            }
//        }
//        var instance = self
//        instance.addKey(clipboardList, forKey: "clipboard")
//        return instance
//    }
//    
//    func addContext() -> EventBuilder {
//        let runningApps = NSWorkspace.shared.runningApplications
//        var windowList: [String] = []
//        var windowCount: Int = 0
//        for app in runningApps {
//            guard app.activationPolicy == .regular else {
//                continue
//            }
//            if let localizedName = app.localizedName {
//                windowList.append(localizedName)
//                windowCount += 1
//            }
//        }
//        var context: [String: Any] = [
//            "windows_cnt": windowCount,
//            "windows_list": windowList,
//            "changed": false
//        ]
//        
//        if let preWindowList = self.context["windows_list"] as? [String],
//           let currentWindowList = context["windows_list"] as? [String] {
//            if preWindowList.sorted() == currentWindowList.sorted() {
//                context["changed"] = false
//            } else {
//                context["changed"] = true
//            }
//        }
//        
//        self.context = context
//        var instance = self
//        instance.addKey(context, forKey: "context")
//        return instance
//    }
//    
//    func addClick(_ clickAmount: Int, _ withConditionallyChecked: () -> Bool) -> EventBuilder {
//        var instance = self
//        instance.addKey(clickAmount, forKey: "click", withConditionallyChecked)
//        return instance
//    }
//    
//    func addContinuity(_ deltaX: CGFloat, _ deltaY: CGFloat, _ withConditionallyChecked: () -> Bool) -> EventBuilder {
//        var instance = self
//        instance.addKey(deltaX, forKey: "deltaX", withConditionallyChecked)
//        instance.addKey(deltaY, forKey: "deltaY", withConditionallyChecked)
//        return instance
//    }
//    
//    func addPressedKey(_ key: String, _ withConditionallyChecked: () -> Bool) -> EventBuilder {
//        var instance = self
//        instance.addKey(key, forKey: "character", withConditionallyChecked)
//        return instance
//    }
//}
