//
//  ChecklistManager.swift
//  Animal Handbook for RDR2
//
//  Created by Trevor Bollinger on 1/15/26.
//

import SwiftUI

@MainActor
class ChecklistManager: ObservableObject {
    static let shared = ChecklistManager()
    
    // Storing item names instead of UUIDs
    @Published private var checkedItems: Set<String> = []
    
    private let store = NSUbiquitousKeyValueStore.default
    
    private init() {
        // Load initial state
        loadFromStore()
        
        // Listen for external changes (e.g. from other devices)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(storeDidChange),
            name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
            object: store
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func storeDidChange(notification: Notification) {
        Task { @MainActor in
            loadFromStore()
        }
    }
    
    private func loadFromStore() {

        // Dictionary stored as Data/JSON to be safe against key limits.
        
        if let data = store.data(forKey: "checklist_data_v2"), // Changed key for v2 migration
           let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
            self.checkedItems = decoded
        } else {
            self.checkedItems = []
        }
        print("✅ Loaded checked items (\(checkedItems.count)): \(checkedItems)")
    }
    
    private func saveToStore() {
        if let data = try? JSONEncoder().encode(checkedItems) {
            store.set(data, forKey: "checklist_data_v2") // consistent with v2
            let success = store.synchronize()
            print("💾 Saved checklist to KVS. Synchronize result: \(success)")
        } else {
            print("❌ Failed to encode checklist data")
        }
    }
    
    func isChecked(_ name: String) -> Bool {
        return checkedItems.contains(name)
    }
    
    func toggle(_ name: String) {
        if checkedItems.contains(name) {
            print("Action: Unchecking item \(name)")
            checkedItems.remove(name)
        } else {
            print("Action: Checking item \(name)")
            checkedItems.insert(name)
        }
        saveToStore()
    }
}
