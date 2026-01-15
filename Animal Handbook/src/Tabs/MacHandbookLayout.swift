import SwiftUI

struct MacHandbookLayout: View {
    @Environment(DataManager.self) var manager
    @State private var selectedCategory: HandbookCategory? = .animals
    @State private var selectedAnimal: Animal?
    @State private var selectedPelt: Pelt?
    @State private var selectedSearchItem: SearchableItem?
    
    enum HandbookCategory: String, CaseIterable, Identifiable {
        case animals = "Animals"
        case pelts = "Pelts"
        case search = "Search All"
        case credits = "Credits"
        
        var id: String { self.rawValue }
        
        var icon: String {
            switch self {
            case .animals: return "pawprint.fill"
            case .pelts: return "bag.fill"
            case .search: return "magnifyingglass"
            case .credits: return "creditcard.fill"
            }
        }
    }

    var body: some View {
        @Bindable var manager = manager
        
        if selectedCategory == .credits {
            // 2-column layout for Credits: Sidebar + Credits content (no detail)
            NavigationSplitView {
                List(HandbookCategory.allCases, selection: $selectedCategory) { category in
                    Label(category.rawValue, systemImage: category.icon)
                        .tag(category)
                }
                .listStyle(.sidebar)
                .navigationTitle("Handbook")
            } detail: {
                CreditsTab()
                    .navigationTitle("Credits")
            }
        } else {
            // 3-column layout for Animals, Pelts, Search
            NavigationSplitView {
                List(HandbookCategory.allCases, selection: $selectedCategory) { category in
                    Label(category.rawValue, systemImage: category.icon)
                        .tag(category)
                }
                .listStyle(.sidebar)
                .navigationTitle("Handbook")
            } content: {
                if let category = selectedCategory {
                    switch category {
                    case .animals:
                        List(manager.filteredAnimals, selection: $selectedAnimal) { animal in
                            ItemRowDetail(
                                title: animal.name,
                                description: animal.loot.joined(separator: ", "),
                                subtitle: animal.location.first
                            )
                            .tag(animal)
                        }
                        .navigationTitle("Animals")
                        .searchable(text: $manager.filter)
                        
                    case .pelts:
                        List(manager.filteredPelts, selection: $selectedPelt) { pelt in
                            ItemRowDetail(
                                title: pelt.name,
                                description: pelt.description,
                                subtitle: nil
                            )
                            .tag(pelt)
                        }
                        .navigationTitle("Pelts")
                        .searchable(text: $manager.filter)
                        
                    case .search:
                        List(manager.filteredList, selection: $selectedSearchItem) { item in
                            ItemRowDetail(
                                title: item.name,
                                description: itemDescription(for: item),
                                subtitle: itemSubtitle(for: item)
                            )
                            .tag(item)
                        }
                        .navigationTitle("Search")
                        .searchable(text: $manager.filter)
                        
                    case .credits:
                        EmptyView()
                    }
                } else {
                    Text("Select a category")
                }
            } detail: {
                if let category = selectedCategory {
                    switch category {
                    case .animals:
                        if let animal = selectedAnimal {
                            AnimalDetail_MACOS(animal: animal, pelts: manager.pelts)
                        } else {
                            ContentUnavailableView("Select an animal", systemImage: "pawprint")
                        }
                    case .pelts:
                        if let pelt = selectedPelt {
                            PeltDetail(pelt: pelt, compact: false)
                        } else {
                            ContentUnavailableView("Select a pelt", systemImage: "bag")
                        }
                    case .search:
                        if let item = selectedSearchItem {
                            destinationView(for: item)
                        } else {
                            ContentUnavailableView("Select an item", systemImage: "magnifyingglass")
                        }
                    case .credits:
                        EmptyView()
                    }
                } else {
                    ContentUnavailableView("Welcome", systemImage: "book.fill")
                }
            }
            .navigationSplitViewStyle(.balanced)
            .navigationSplitViewColumnWidth(min: 300, ideal: 300, max: 350)
        }
    }
    
    // Helpers copied from SplitViewListTab
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
            AnimalDetail_MACOS(animal: animal, pelts: manager.pelts)
        case .pelt(let pelt):
            PeltDetail(pelt: pelt, compact: false)
        }
    }
}

#Preview {
    MacHandbookLayout()
        .environment(DataManager())
}
