//
//  ChecklistTab.swift
//  Animal Handbook for RDR2
//
//  Created by Trever Bollinger on 1/15/26.
//

import SwiftUI



struct ChecklistTab: View {
    @Environment(DataManager.self) var manager
    @StateObject private var checklistManager = ChecklistManager.shared
    
    var allItems: [CheckedItem] {
        manager.checklistItems
    }
    
    var collectedItems: [CheckedItem] {
        allItems.filter { checklistManager.isCollected($0.name) }
    }
    
    var uncollectedItems: [CheckedItem] {
        allItems.filter { !checklistManager.isCollected($0.name) }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    
                    if !collectedItems.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Collected Items")
                                .font(.title2)
                                .bold()
                            
                            LazyVStack(spacing: 12) {
                                ForEach(collectedItems) { item in
                                    ChecklistRow(item: item, showIngredients: false)
                                }
                            }
                        }
                    }
                    
                    if !uncollectedItems.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Missing Items")
                                .font(.title2)
                                .bold()
                            
                            LazyVStack(spacing: 12) {
                                ForEach(uncollectedItems) { item in
                                    ChecklistRow(item: item, showIngredients: true)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Checklist")
            .navigationDestination(for: CheckedItem.self) { item in
                ItemDetail(item: item)
            }
        }
    }
}

#Preview {
    ChecklistTab()
        .environment(DataManager())
        .environmentObject(StoreKitManager())
}


