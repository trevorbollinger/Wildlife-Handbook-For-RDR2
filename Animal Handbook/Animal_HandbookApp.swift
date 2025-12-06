import SwiftUI

enum NavigationCategory: String, CaseIterable, Identifiable, Hashable {
    case animals = "Animals"
    case catTwo = "Pelts"
    case credits = "Credits"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .animals: return "pawprint.fill"
        case .catTwo: return "bag.fill"
        case .credits: return "creditcard.fill"
        }
    }
}



@main
struct Hunting_HandbookApp: App {
    let animals = Bundle.main.decode([Animal].self, from: "animals.json")
    let pelts = Bundle.main.decode([Pelt].self, from: "pelts.json")
    
    var body: some Scene {
        WindowGroup {
            ContentView(animals: animals, pelts: pelts)
        }
    }
}

//struct ContentView: View {
//    let animals: [Animal]
//    let pelts: [Pelt]
//    
//    var body: some View {
//        AnimalSplitView(animals: animals, pelts: pelts)
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        let animals = Animal.exampleList
//        let pelts = Pelt.exampleList
//        
//        ContentView(animals: animals, pelts: pelts).preferredColorScheme(.dark)
//    }
//}
struct ContentView: View {
    
    let animals: [Animal]
    let pelts: [Pelt]
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var selectedCategory: NavigationCategory? = .animals
    @State private var selectedRowItem: RowItem?
    
    // Create RowItems once at this level so both views share the same instances
    private var animalItems: [RowItem] {
        animals.map { animal in
            RowItem(
                title: animal.name,
                preview: String(animal.description.prefix(100)) + (animal.description.count > 100 ? "..." : ""),
                category: .animals
            )
        }
    }
    
    private var peltItems: [RowItem] {
        pelts.map { pelt in
            RowItem(
                title: pelt.name,
                preview: String(pelt.description.prefix(100)) + (pelt.description.count > 100 ? "..." : ""),
                category: .catTwo
            )
        }
    }

    var body: some View {
        // Use TabView for iPhone (compact), NavigationSplitView for iPad (regular)
        if horizontalSizeClass == .compact {
            CompactView(
                animalItems: animalItems,
                peltItems: peltItems,
                animals: animals,
                pelts: pelts
            )
        } else {
            ExpandedView(
                selectedCategory: $selectedCategory,
                selectedItem: $selectedRowItem,
                animalItems: animalItems,
                peltItems: peltItems,
                animals: animals,
                pelts: pelts
            )
        }
    }
}
