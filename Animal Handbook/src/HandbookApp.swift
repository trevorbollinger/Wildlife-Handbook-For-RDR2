//
//  NewHandbookApp.swift
//  NewHandbook
//
//  Created by Trevor Bollinger on 12/5/25.
//

import SwiftUI

@main
struct NewHandbookApp: App {
    @State private var manager = DataManager()

    var body: some Scene {
        WindowGroup {
            ContentView().environment(manager)
        }
    }
}
