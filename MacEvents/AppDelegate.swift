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
    var jsonData: JSON = []
    var mouseEvents = ["leftMouseDown", "leftMouseUp", "rightMouseDown", "rightMouseUp"]
    var keyEvents = ["keyDown"]
    var timestamp: Int64 = Int64(Date().timeIntervalSince1970 * 1000)
    var eventIndex: Int = 0
    var context: [String: Any] = [:]
    
    // Your app needs to be code-signed.
    // Your app needs to not have the App Sandbox enabled, and:
    // Your app needs to be registered in the Security and Privacy preference pane, under Accessibility.
    func applicationDidFinishLaunching(_ notification: Notification) {
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String : true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options)
        if !accessEnabled {
            print("请打开无障碍权限")
        } else {
            NSEvent.addGlobalMonitorForEvents(matching: [.keyDown, .keyUp, .leftMouseDown, .rightMouseDown, .flagsChanged]) { event in
                let json = JSON(event.reflected())
                print(json)
                                
                if self.mouseEvents.contains(json["event"].stringValue)   {
                    self.writeMouseJsonToFile(json: json)
                }
                if self.keyEvents.contains(json["event"].stringValue)   {
                    self.writeKeyJsonToFile(json: json)
                }
                self.eventIndex += 1
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

    func writeMouseJsonToFile(json: JSON) {
        var jsonEntries: [String: Any] = writeMouseJson(json: json)
        jsonEntries["event_index"] = self.eventIndex
        jsonEntries["clipboard"] = getClickboard()
        jsonEntries["context"] = getContext()
        if var uncomplete = jsonEntries["uncomplete"] as? Int {
            uncomplete -= 1
            jsonEntries["uncomplete"] = uncomplete
        }
        self.jsonData.arrayObject?.append(jsonEntries)
        writeJsonToFile()
    }
    
    func writeKeyJsonToFile(json: JSON) {
        var jsonEntries: [String: Any] = writeKeyJson(json: json)
        jsonEntries["event_index"] = self.eventIndex
        jsonEntries["clipboard"] = getClickboard()
        jsonEntries["context"] = getContext()
        if var uncomplete = jsonEntries["uncomplete"] as? Int {
            uncomplete -= 1
            jsonEntries["uncomplete"] = uncomplete
        }
        self.jsonData.arrayObject?.append(jsonEntries)
        writeJsonToFile()
    }

    func getClickboard() -> [String] {
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
        return clipboardList
    }
    
    func getContext() -> [String: Any] {
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
        var context: [String: Any] = [
            "windows_cnt": windowCount,
            "windows_list": windowList,
            "changed": false
        ]
        
        if let preWindowList = self.context["windows_list"] as? [String],
           let currentWindowList = context["windows_list"] as? [String] {
            if preWindowList.sorted() == currentWindowList.sorted() {
                context["changed"] = false
            } else {
                context["changed"] = true
            }
        }
        self.context = context
        return context
    }
    
    func writeJsonToFile() {
        let fileName = "log_\(self.timestamp)_event.json"
        let desktopURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
        let fileURL = desktopURL.appendingPathComponent(fileName)

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self.jsonData.arrayObject as Any, options: .prettyPrinted)
            try jsonData.write(to: fileURL)
            print("事件数据已成功写入文件：\(fileURL.path)")
        } catch {
            print("写入 JSON 文件出错：\(error.localizedDescription)")
        }
    }
}
