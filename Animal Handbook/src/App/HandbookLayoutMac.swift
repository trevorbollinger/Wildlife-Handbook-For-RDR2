import SwiftUI

struct MacHandbookLayout: View {
    @Environment(DataManager.self) var manager
    @State private var selectedCategory: HandbookCategory? = .animals
    @State private var selectedAnimal: Animal?
    @State private var selectedPelt: Pelt?
    @State private var selectedSearchItem: SearchableItem?
    @EnvironmentObject var storeKitManager: StoreKitManager
    @StateObject private var checklistManager = ChecklistManager.shared
    
    enum HandbookCategory: String, CaseIterable, Identifiable {
        case animals = "Animals"

        case checklist = "Checklist"
        case shoppingList = "Shopping List"
        case search = "Search All"
        case credits = "Credits"
        
        var id: String { self.rawValue }
        
        var icon: String {
            switch self {
            case .animals: return "pawprint.fill"

            case .checklist: return "checklist"
            case .shoppingList: return "cart"
            case .search: return "magnifyingglass"
            case .credits: return "creditcard.fill"
            }
        }
    }

    var checkListCategories: [HandbookCategory] {
        HandbookCategory.allCases.filter { category in
            if category == .checklist || category == .shoppingList {
                return storeKitManager.hasPremium
            }
            return true
        }
    }
    
    var trackedItems: [CheckedItem] {
        manager.checklistItems.filter {
            checklistManager.isTracked($0.name) && !checklistManager.isCollected($0.name)
        }
    }



    var body: some View {
        @Bindable var manager = manager
        
        if selectedCategory == .credits || selectedCategory == .checklist || selectedCategory == .shoppingList {
            // 2-column layout for Credits/Checklist/ShoppingList: Sidebar + Content (no detail)
            NavigationSplitView {
                List(checkListCategories, selection: $selectedCategory) { category in
                    Label(category.rawValue, systemImage: category.icon)
                        .tag(category)
                }
                .listStyle(.sidebar)
                .navigationTitle("Handbook")
            } detail: {
                if selectedCategory == .checklist {
                    ChecklistTab()
                } else if selectedCategory == .shoppingList {
                    ShoppingListView(items: trackedItems)
                } else {
                    CreditsTab()
                        .navigationTitle("Credits")
                }
            }
        } else {
            // 3-column layout for Animals, Pelts, Search
            NavigationSplitView {
                List(checkListCategories, selection: $selectedCategory) { category in
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
                            ItemRowView(
                                title: animal.name,
                                description: animal.loot.joined(separator: ", "),
                                subtitle: animal.location.first
                            )
                            .tag(animal)
                        }
                        .navigationTitle("Animals")
                        .searchable(text: $manager.filter)
                        



                    case .checklist, .shoppingList:
                         EmptyView()

                    case .search:
                        List(manager.filteredList, selection: $selectedSearchItem) { item in
                            ItemRowView(
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


                    case .checklist, .shoppingList:
                        EmptyView()
                        
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
        case .checklistItem(let item):
            return "\(item.type.rawValue) Item"
        default:
            return ""
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
        default:
            return nil
        }
    }
    
    @ViewBuilder
    private func destinationView(for item: SearchableItem) -> some View {
        switch item {
        case .animal(let animal):
            AnimalDetail_MACOS(animal: animal, pelts: manager.pelts)
        case .pelt(let pelt):
            PeltDetail(pelt: pelt, compact: false)
        case .checklistItem(let item):
            ItemDetail(item: item)
        default:
            EmptyView()
        }
    }
}

#Preview {
    MacHandbookLayout()
        .environment(DataManager())
}
