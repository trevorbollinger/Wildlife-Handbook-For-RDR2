//
//  HandbookTabs.swift
//  NewHandbook
//
//  Created by Trevor Bollinger on 12/5/25.
//

import SwiftData
import SwiftUI
import WidgetKit

// MARK: - Split View List Tab for iPad
// MARK: - Split View List Tab for iPad
#if os(iOS)
struct SplitViewListTab<Item: NamedItem>: View {
    let items: [Item]
    let name: String
    let jsonFile: String
    @Environment(DataManager.self) var manager
    @State private var selectedAnimal: Animal?
    @State private var selectedPelt: Pelt?
    @State private var selectedSearchItem: SearchableItem?
    
    var body: some View {
        @Bindable var manager = manager
        
        if name == "Animals" {
            NavigationSplitView {
                List(manager.filteredAnimals, selection: $selectedAnimal) { animal in
                    ItemRowView(
                        title: animal.name,
                        description: animal.loot.joined(separator: ", "),
                        subtitle: animal.location.first
                    )
                    .tag(animal)
                }
                .listStyle(.sidebar)
                .navigationTitle(name)
                .searchable(text: $manager.filter)
                .navigationSplitViewColumnWidth(min: 280, ideal: 350)
            } detail: {
                if let animal = selectedAnimal {
                    AnimalDetail(animal: animal, pelts: manager.pelts)
                } else {
                    ContentUnavailableView(
                        "Select an animal",
                        systemImage: "pawprint.fill",
                        description: Text("Choose an animal from the list to view details")
                    )
                }
            }
            .navigationSplitViewStyle(.balanced)
        } else if name == "Pelts" {
            NavigationSplitView {
                List(manager.filteredPelts, selection: $selectedPelt) { pelt in
                    ItemRowView(
                        title: pelt.name,
                        description: pelt.description,
                        subtitle: nil
                    )
                    .tag(pelt)
                }
                .listStyle(.sidebar)
                .navigationTitle(name)
                .searchable(text: $manager.filter)
                .navigationSplitViewColumnWidth(min: 280, ideal: 350)
            } detail: {
                if let pelt = selectedPelt {
                    PeltDetail(pelt: pelt, compact: false)
                } else {
                    ContentUnavailableView(
                        "Select a pelt",
                        systemImage: "bag.fill",
                        description: Text("Choose a pelt from the list to view details")
                    )
                }
            }
            .navigationSplitViewStyle(.balanced)
        } else if name == "Search" {
            NavigationSplitView {
                List(manager.filteredList, selection: $selectedSearchItem) { item in
                    ItemRowView(
                        title: item.name,
                        description: itemDescription(for: item),
                        subtitle: itemSubtitle(for: item)
                    )
                    .tag(item)
                }
                .listStyle(.sidebar)
                .navigationTitle(name)
                .searchable(text: $manager.filter)
                .navigationSplitViewColumnWidth(min: 280, ideal: 350)
            } detail: {
                if let item = selectedSearchItem {
                    destinationView(for: item)
                } else {
                    ContentUnavailableView(
                        "Select an item",
                        systemImage: "magnifyingglass",
                        description: Text("Choose an item from the list to view details")
                    )
                }
            }
            .navigationSplitViewStyle(.balanced)
        }
    }
    
    private func itemDescription(for item: SearchableItem) -> String {
        switch item {
        case .animal(let animal):
            return animal.loot.joined(separator: ", ")
        case .pelt(let pelt):
            return pelt.description
        case .checklistItem(let item):
            return "\(item.type.rawValue) Item"
        }
    }
    
    private func itemSubtitle(for item: SearchableItem) -> String? {
        switch item {
        case .animal(let animal):
            return animal.location.first
        case .pelt:
            return ""
        case .checklistItem:
            return nil
        }
    }
    
    @ViewBuilder
    private func destinationView(for item: SearchableItem) -> some View {
        switch item {
        case .animal(let animal):
            AnimalDetail(animal: animal, pelts: manager.pelts)
        case .pelt(let pelt):
            PeltDetail(pelt: pelt, compact: false)
        case .checklistItem(let item):
            // user requested "no navigation link" (which implies no deep drill down, but we need something for split view)
            ItemDetail(item: item)
        }
    }
}
#endif

// MARK: - Main Tabs View
struct HandbookTabs: View {
    @Environment(DataManager.self) var manager
    @SceneStorage("selectedTab") var selectedTab = 0
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.requestReview) var requestReview
    @EnvironmentObject var storeKitManager: StoreKitManager
    @StateObject private var checklistManager = ChecklistManager.shared
    
    var trackedItems: [CheckedItem] {
        manager.checklistItems.filter {
            checklistManager.isTracked($0.name) && !checklistManager.isCollected($0.name)
        }
    }

    var body: some View {

        Group {
            if horizontalSizeClass == .compact {
            //IPHONE VIEW
            TabView(selection: $selectedTab) {
                Tab("Animals", systemImage: "pawprint.fill", value: 0) {
                    ListTab(
                        items: manager.animals,
                        name: "Animals",
                        jsonFile: "animals.json"
                    )
                }
                // Tab("Pelts", systemImage: "bag.fill", value: 1) {
                //     ListTab(
                //         items: manager.pelts,
                //         name: "Pelts",
                //         jsonFile: "pelts.json"
                //     )
                // }
                if storeKitManager.hasPremium {
                    Tab("Checklist", systemImage: "checklist", value: 4) {
                        ChecklistTab()
                    }
                    Tab("Shopping List", systemImage: "cart", value: 5) {
                        ShoppingListView(items: trackedItems)
                    }
                }
                Tab("Credits", systemImage: "creditcard.fill", value: 2) {
                    CreditsTab()
                }
                Tab(
                    "Search All",
                    systemImage: "magnifyingglass",
                    value: 3,
                    role: .search
                ) {
                    ListTab(
                        items: manager.filteredList,
                        name: "Search",
                        jsonFile: "animals.json"
                    )
                }

            }
            .tabViewStyle(.sidebarAdaptable)
        } else {
            #if os(macOS)
            MacHandbookLayout()
            #else
            //IPAD VIEW
            TabView(selection: $selectedTab) {
                Tab("Animals", systemImage: "pawprint.fill", value: 0) {
                    SplitViewListTab(
                        items: manager.animals,
                        name: "Animals",
                        jsonFile: "animals.json"
                    )
                }
                // Tab("Pelts", systemImage: "bag.fill", value: 1) {
                //     SplitViewListTab(
                //         items: manager.pelts,
                //         name: "Pelts",
                //         jsonFile: "pelts.json"
                //     )
                // }
                
                if storeKitManager.hasPremium {
                    Tab("Checklist", systemImage: "checklist", value: 4) {
                        ChecklistTab()
                    }
                    Tab("Shopping List", systemImage: "cart", value: 5) {
                        ShoppingListView(items: trackedItems)
                    }
                }

                Tab("Credits", systemImage: "creditcard.fill", value: 2) {
                    CreditsTab()
                }
                Tab(
                    "Search All",
                    systemImage: "magnifyingglass",
                    value: 3,
                    role: .search
                ) {
                    SplitViewListTab(
                        items: manager.filteredList,
                        name: "Search",
                        jsonFile: "animals.json"
                    )
                }
            }
            .tabViewStyle(.sidebarAdaptable)
            #endif
        }
        }
        .onChange(of: storeKitManager.shouldRequestReview) { _, newValue in
            if newValue {
                requestReview()
                storeKitManager.markReviewRequested()
            }
        }
        .onChange(of: checklistManager.trackedItems) { _, _ in syncWidget() }
        .onChange(of: checklistManager.collectedItems) { _, _ in syncWidget() }
        .onChange(of: storeKitManager.hasPremium) { _, _ in syncWidget() }
        .onAppear { syncWidget() } // Ensure widget is up to date on app launch
        .onOpenURL { url in
            if url.scheme == "animalhandbook" && url.host == "shoppinglist" {
                selectedTab = 5
            }
        }
    }
    
    private func syncWidget() {
        let items = trackedItems
        let shoppingList = ShoppingListHelper.generateShoppingList(from: items)
        let hasPremium = storeKitManager.hasPremium
        
        let sharedDefaults = UserDefaults(suiteName: "group.com.trevorbollinger.animalhandbook")
        
        if let data = try? JSONEncoder().encode(shoppingList) {
            sharedDefaults?.set(data, forKey: "shoppingList")
        }
        
        sharedDefaults?.set(hasPremium, forKey: "hasPremium")
        
        WidgetCenter.shared.reloadAllTimelines()
    }
}



#Preview {
    HandbookTabs()
        .environment(DataManager())
        .environmentObject(StoreKitManager())
}
