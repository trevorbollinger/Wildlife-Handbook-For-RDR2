//
//  HandbookTabs.swift
//  NewHandbook
//
//  Created by Trevor Bollinger on 12/5/25.
//

import SwiftData
import SwiftUI

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
                    ItemRowDetail(
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
                    ItemRowDetail(
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
                    ItemRowDetail(
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
        }
    }
    
    private func itemSubtitle(for item: SearchableItem) -> String? {
        switch item {
        case .animal(let animal):
            return animal.location.first
        case .pelt:
            return ""
        }
    }
    
    @ViewBuilder
    private func destinationView(for item: SearchableItem) -> some View {
        switch item {
        case .animal(let animal):
            AnimalDetail(animal: animal, pelts: manager.pelts)
        case .pelt(let pelt):
            PeltDetail(pelt: pelt, compact: false)
        }
    }
}
#endif

// MARK: - Main Tabs View
struct HandbookTabs: View {
    @Environment(DataManager.self) var manager
    @SceneStorage("selectedTab") var selectedTab = 0
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {

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
                Tab("Pelts", systemImage: "bag.fill", value: 1) {
                    ListTab(
                        items: manager.pelts,
                        name: "Pelts",
                        jsonFile: "pelts.json"
                    )
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
                Tab("Pelts", systemImage: "bag.fill", value: 1) {
                    SplitViewListTab(
                        items: manager.pelts,
                        name: "Pelts",
                        jsonFile: "pelts.json"
                    )
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
}

