//
//  HandbookApp.swift
//  Animal Handbook For RDR2
//
//  Created by Trevor Bollinger on 12/5/25.
//

import SwiftUI

@main
struct NewHandbookApp: App {
    @State private var manager = DataManager()
    @StateObject private var storeKitManager = StoreKitManager()

    var body: some Scene {
        WindowGroup {
            HandbookTabs()
                .environment(manager)
                .environmentObject(storeKitManager)
        }
        #if os(macOS)
        .defaultSize(width: 800, height: 800)
        #endif
    }
}
