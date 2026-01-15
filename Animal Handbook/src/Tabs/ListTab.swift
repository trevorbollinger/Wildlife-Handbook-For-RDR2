//
//  AnimalsTab.swift
//  NewHandbook
//
//  Created by Trevor Bollinger on 12/5/25.
//

import SwiftUI

extension Animal: NamedItem {}
extension Pelt: NamedItem {}

struct IsSearchable: ViewModifier {
    let selectedTab: Int
    @Binding var filter: String

    func body(content: Content) -> some View {
        if selectedTab == 3 {
            content
                .searchable(text: $filter)
        } else {
            content
        }
    }
}

extension View {
    func isSearchable(selectedTab: Int, filter: Binding<String>) -> some View {
        modifier(IsSearchable(selectedTab: selectedTab, filter: filter))
    }
}

struct ListTab<Item: NamedItem>: View {
    let items: [Item]
    let name: String
    let jsonFile: String
    @Environment(DataManager.self) var manager
    @SceneStorage("selectedTab") var selectedTab = 0

    var body: some View {
        @Bindable var manager = manager

        NavigationStack {
            if name == "Animals" {
                List(manager.filteredAnimals) { animal in
                    NavigationLink {
                        AnimalDetail(animal: animal, pelts: manager.pelts)
                    } label: {
                        ItemRowDetail(
                            title: animal.name,
                            description: animal.loot.joined(separator: ", "),
                            subtitle: animal.location.first
                        )
                    }
                }
                .listStyle(.plain)
                .navigationTitle(name)
                .isSearchable(selectedTab: selectedTab, filter: $manager.filter)
            } else if name == "Pelts" {
                List(manager.filteredPelts) { pelt in
                    NavigationLink {
                        PeltDetail(pelt: pelt, compact: false)
                    } label: {
                        ItemRowDetail(
                            title: pelt.name,
                            description: pelt.description,
                            subtitle: nil
                        )
                    }
                }
                .listStyle(.plain)
                .navigationTitle(name)
                .isSearchable(selectedTab: selectedTab, filter: $manager.filter)
            } else if name == "Search" {
                List(manager.filteredList) { item in
                    NavigationLink {
                        destinationView(for: item)
                    } label: {
                        ItemRowDetail(
                            title: item.name,
                            description: itemDescription(for: item),
                            subtitle: itemSubtitle(for: item)
                        )
                    }
                }
                .listStyle(.plain)
                .navigationTitle(name)
                .isSearchable(selectedTab: selectedTab, filter: $manager.filter)
            } else {
                List(items) { item in
                    ItemRowDetail(
                        title: item.name,
                        description: "",
                        subtitle: nil
                    )
                }
                .listStyle(.plain)
                .navigationTitle(name)
                .isSearchable(selectedTab: selectedTab, filter: $manager.filter)
            }
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

#Preview {
    ListTab(
        items: [] as [Animal],  // DataManager will populate this in a real app, but for preview we can pass empty or rely on the environment modification if the view read directly from environment. NOTE: The view uses `manager.filteredAnimals` for "Animals" case, so passing items: [] is fine as it ignores it for "Animals" case.
        name: "Animals",
        jsonFile: "animals.json"
    )
    .environment(DataManager())
}
