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
    @Published private var collectedItems: Set<String> = []
    @Published private var trackedItems: Set<String> = []
    
    private let store = NSUbiquitousKeyValueStore.default
    private let collectedKey = "collected_items_v3"
    private let trackedKey = "tracked_items_v1"
    private let legacyKey = "checklist_data_v2"
    
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
        // Migration Check: Check for V2 data
        if let legacyData = store.data(forKey: legacyKey),
           store.data(forKey: collectedKey) == nil {
            print("📦 Found legacy V2 data, migrating to V3...")
            if let decoded = try? JSONDecoder().decode(Set<String>.self, from: legacyData) {
                print("   Migrating \(decoded.count) items to collected state")
                self.collectedItems = decoded
                saveToStore() // This will save to V3 key
                store.removeObject(forKey: legacyKey) // Cleanup old key
                store.synchronize()
                return // We are done for this load
            }
        }
        
        // Load Collected Items (V3)
        if let data = store.data(forKey: collectedKey),
           let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
            self.collectedItems = decoded
        } else {
            self.collectedItems = []
        }
        
        // Load Tracked Items (V1)
        if let data = store.data(forKey: trackedKey),
           let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
            self.trackedItems = decoded
        } else {
            self.trackedItems = []
        }
        
        print("✅ Loaded: \(collectedItems.count) collected, \(trackedItems.count) tracked")
    }
    
    private func saveToStore() {
        // Save Collected
        if let data = try? JSONEncoder().encode(collectedItems) {
            store.set(data, forKey: collectedKey)
        }
        
        // Save Tracked
        if let data = try? JSONEncoder().encode(trackedItems) {
            store.set(data, forKey: trackedKey)
        }
        
        let success = store.synchronize()
        print("💾 Saved checklist state to KVS. Synchronize result: \(success)")
    }
    
    // MARK: - Collected (formerly Checked)
    
    func isCollected(_ name: String) -> Bool {
        return collectedItems.contains(name)
    }
    
    func toggleCollected(_ name: String) {
        if collectedItems.contains(name) {
            print("Action: Un-collecting item \(name)")
            collectedItems.remove(name)
        } else {
            print("Action: Collecting item \(name)")
            collectedItems.insert(name)
            
            // If we collect it, we probably don't need to track it anymore
            if trackedItems.contains(name) {
                trackedItems.remove(name)
            }
        }
        saveToStore()
    }
    
    // MARK: - Tracked (Shopping List)
    
    func isTracked(_ name: String) -> Bool {
        return trackedItems.contains(name)
    }
    
    func toggleTracked(_ name: String) {
        if trackedItems.contains(name) {
            print("Action: Un-tracking item \(name)")
            trackedItems.remove(name)
        } else {
            print("Action: Tracking item \(name)")
            trackedItems.insert(name)
        }
        saveToStore()
    }
    
    // MARK: - Legacy Support (deprecated)
    
    // Helper to support older calls temporarily if any exist
    func isChecked(_ name: String) -> Bool {
        return isCollected(name)
    }
    
    func toggle(_ name: String) {
        toggleCollected(name)
    }
}
