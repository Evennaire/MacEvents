//
//  AppDelegate.swift
//  MacEvents
//
//  Created by Yueting Weng on 2023/5/3.
//

import Foundation
import AppKit
import SwiftUI
import SwiftyJSON
import AXSwift
import Accessibility 

class AppDelegate: NSObject, NSApplicationDelegate {
    
    lazy var statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var popover: NSPopover!
    var jsonArray: JSON = []
    var eventIndex: Int = 0
    var lastWindowList = [String]()
    var observer: Observer!
    
    // Your app needs to be code-signed.
    // Your app needs to not have the App Sandbox enabled, and:
    // Your app needs to be registered in the Security and Privacy preference pane, under Accessibility.
    func applicationDidFinishLaunching(_ notification: Notification) {
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String : true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options)
        if !accessEnabled {
            print("请打开无障碍权限")
        } else {
            NSEvent.addGlobalMonitorForEvents(matching: [.keyDown, .keyUp, .leftMouseDown, .rightMouseDown, .flagsChanged]) { [unowned self] event in
                var json = JSON(event.reflected())
                json["event_index"].intValue = eventIndex
                json["uncomplete"].intValue = 0
                if let windowList = json["context"]["windows_list"].rawValue as? [String] {
                    let contextualChanges = Set(windowList) != Set(lastWindowList)
                    json["context"]["changed"].boolValue = contextualChanges
                    lastWindowList = windowList
                }
                jsonArray.arrayObject?.append(json)
                print(json)
                
                let writer = JsonWriter()
                let timestamp = json["timestamp"]
                    .stringValue
                    .split(separator: " ").first!
                    .replacingOccurrences(of: "[-:\\s]", with: "", options: .regularExpression)
                let filename = "log_\(timestamp)_event.json"
                writer.writeAsArray(jsonArray, by: filename) { path in
                    print("事件数据已成功写入文件：\(path)")
                } exceptionally: { error in
                    print(error.localizedDescription)
                }
                
                eventIndex += 1
            }
        }
        
        if let window = NSApplication.shared.windows.first {
            window.close()
        }
        
        let contentView = ContentView()
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 80, height: 60)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover
        
        statusBarItem.button?.title = "MacEvents"
        statusBarItem.button?.action = #selector(togglePopover(_:))
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = self.statusBarItem.button {
            if self.popover.isShown {
                self.popover.performClose(sender)
            } else {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }
}
