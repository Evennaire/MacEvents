//
//  AppDelegate.swift
//  MacEvents
//
//  Created by Yueting Weng on 2023/5/3.
//

import Foundation
import AppKit
import SwiftUI

// Your app needs to be code-signed.
// Your app needs to not have the App Sandbox enabled, and:
// Your app needs to be registered in the Security and Privacy preference pane, under Accessibility.

class AppDelegate: NSObject, NSApplicationDelegate {
    
    lazy var statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var popover: NSPopover!
    
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String : true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options)
        if !accessEnabled {
            print("请打开无障碍权限")
        } else {
            let visitor = EventVisitor()
            NSEvent.addGlobalMonitorForEvents(matching: [.keyDown]) { (event) in
                visitor.visit(event.asKeyboardEvent())
            }

            NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { (event) in
                visitor.visit(event.asMouseEvent())
            }
        }
        
        if let window = NSApplication.shared.windows.first {
            window.close()
        }
        
        let contentView = ContentView()
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 120, height: 60)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover
        
        statusBarItem.button?.title = "MacEvents"
        statusBarItem.button?.action = #selector(NSApplication.shared.terminate(_:))
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


