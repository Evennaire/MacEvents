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

class AppDelegate: NSObject, NSApplicationDelegate {
    
    lazy var statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var popover: NSPopover!
    
    // Your app needs to be code-signed.
    // Your app needs to not have the App Sandbox enabled, and:
    // Your app needs to be registered in the Security and Privacy preference pane, under Accessibility.
    func applicationDidFinishLaunching(_ notification: Notification) {
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String : true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options)
        if !accessEnabled {
            print("请打开无障碍权限")
        } else {
            NSEvent.addGlobalMonitorForEvents(matching: [.keyDown, .leftMouseDown, .leftMouseDragged]) { event in
                let json = JSON(event.reflected())
                print(json)
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


