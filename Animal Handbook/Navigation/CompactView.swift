//
//  CompactView.swift
//  TestingPlayground
//
//  Created by Trevor Bollinger on 12/5/25.
//

import SwiftUI

struct CompactView: View {
    let animals: [Animal]
    let pelts: [Pelt]
    
    // Convert animals to RowItems
    private var animalItems: [RowItem] {
        animals.map { animal in
            RowItem(
                title: animal.name,
                preview: String(animal.description.prefix(100)) + (animal.description.count > 100 ? "..." : ""),
                category: .animals
            )
        }
    }
    
    // Convert pelts to RowItems
    private var peltItems: [RowItem] {
        pelts.map { pelt in
            RowItem(
                title: pelt.name,
                preview: String(pelt.description.prefix(100)) + (pelt.description.count > 100 ? "..." : ""),
                category: .catTwo
            )
        }
    }
    
    private func items(for category: NavigationCategory) -> [RowItem] {
        switch category {
        case .animals:
            return animalItems
        case .catTwo:
            return peltItems
        case .credits:
            return []
        }
    }
    
    var body: some View {
        TabView {
            ForEach(NavigationCategory.allCases) { category in
                ItemCategoryView(
                    category: category,
                    items: items(for: category),
                    animals: animals,
                    pelts: pelts
                )
                .tabItem {
                    Label(category.rawValue, systemImage: category.icon)
                }
            }
        }
    }
}

// Reusable view for displaying mail list for a category (used in TabView)
struct ItemCategoryView: View {
    let category: NavigationCategory
    let items: [RowItem]
    let animals: [Animal]
    let pelts: [Pelt]
    
    // Find matching Animal by name
    private func findAnimal(for rowItem: RowItem) -> Animal? {
        animals.first { $0.name == rowItem.title }
    }
    
    // Find matching Pelt by name
    private func findPelt(for rowItem: RowItem) -> Pelt? {
        pelts.first { $0.name == rowItem.title }
    }
    
    var body: some View {
        NavigationStack {
            if category == .credits {
                CreditsView()
                    .navigationTitle(category.rawValue)
                    .navigationBarTitleDisplayMode(.large)
            } else {
                List {
                    ForEach(items) { rowItem in
                        NavigationLink(value: rowItem) {
                            RowItemView(rowItem: rowItem)
                        }
                    }
                }
                .navigationTitle(category.rawValue)
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: {}) {
                            Label("Compose", systemImage: "square.and.pencil")
                        }
                    }
                }
                .navigationDestination(for: RowItem.self) { rowItem in
                    Group {
                        switch category {
                        case .animals:
                            if let animal = findAnimal(for: rowItem) {
                                AnimalDetail(animal: animal, pelts: pelts)
                            } else {
                                ContentUnavailableView("Animal Not Found", systemImage: "exclamationmark.triangle")
                            }
                        case .catTwo:
                            if let pelt = findPelt(for: rowItem) {
                                PeltDetail(pelt: pelt, compact: false)
                            } else {
                                ContentUnavailableView("Pelt Not Found", systemImage: "exclamationmark.triangle")
                            }
                        case .credits:
                            CreditsView()
                        }
                    }
                }
            }
        }
    }
}
