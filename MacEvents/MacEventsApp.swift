//
//  MacEventsApp.swift
//  MacEvents
//
//  Created by Even on 2023/4/21.
//

import SwiftUI

@main
struct MacEventsApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
