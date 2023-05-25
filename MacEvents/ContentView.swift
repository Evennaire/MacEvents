//
//  ContentView.swift
//  MacEvents
//
//  Created by Even on 2023/4/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Button("退出") {
            NSApplication.shared.terminate(nil)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
