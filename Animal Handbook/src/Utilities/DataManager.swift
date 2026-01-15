//
//  DataManager.swift
//  Animal Handbook for RDR2
//
//  Created by Trevor Bollinger on 12/5/25.
//

import SwiftUI

protocol NamedItem: Identifiable {
    var name: String { get }
}

enum SearchableItem: Identifiable, NamedItem, Hashable {
    case animal(Animal)
    case pelt(Pelt)
    case checklistItem(CheckedItem)
    
    var id: UUID {
        switch self {
        case .animal(let animal):
            return animal.id
        case .pelt(let pelt):
            return pelt.id
        case .checklistItem(let item):
            return item.id
        }
    }
    
    var name: String {
        switch self {
        case .animal(let animal):
            return animal.name
        case .pelt(let pelt):
            return pelt.name
        case .checklistItem(let item):
            return item.name
        }
    }
}

struct CheckedItem: Identifiable, Hashable {
    let id: UUID
    let name: String
    let type: ItemType
    let price: Double?
    let ingredients: [String]
    let sourcePeltName: String
    
    enum ItemType: String {
        case trapper = "Trapper"
        case fence = "Fence"
        case camp = "Camp"
    }
}

@Observable
class DataManager {
    var animals: [Animal] = []
    var pelts: [Pelt] = []
    
    var filter = ""
    
    init() {
        loadData()
    }
    
    private func loadData() {
        animals = Bundle.main.decode([Animal].self, from: "animals.json")
        pelts = Bundle.main.decode([Pelt].self, from: "pelts.json")
        generateChecklistItems()
    }
    
    var checklistItems: [CheckedItem] = []
    
    private func generateChecklistItems() {
        var results: [CheckedItem] = []
        var seenNames: Set<String> = []
        
        for pelt in pelts {
            // Trapper Items
            for item in pelt.trapperItems {
                if !item.name.isEmpty && !seenNames.contains(item.name) {
                    seenNames.insert(item.name)
                    results.append(CheckedItem(
                        id: item.id,
                        name: item.name,
                        type: .trapper,
                        price: item.price,
                        ingredients: item.ingredients,
                        sourcePeltName: pelt.name
                    ))
                }
            }
            
            // Fence Items
            for item in pelt.fenceItems {
                if !item.name.isEmpty && !seenNames.contains(item.name) {
                    seenNames.insert(item.name)
                    results.append(CheckedItem(
                        id: item.id,
                        name: item.name,
                        type: .fence,
                        price: item.price,
                        ingredients: item.ingredients,
                        sourcePeltName: pelt.name
                    ))
                }
            }
            
            // Camp Items
            for item in pelt.campItems {
                if !item.name.isEmpty && !seenNames.contains(item.name) {
                    seenNames.insert(item.name)
                    results.append(CheckedItem(
                        id: item.id,
                        name: item.name,
                        type: .camp,
                        price: nil,
                        ingredients: item.ingredients,
                        sourcePeltName: pelt.name
                    ))
                }
            }
        }
        
        self.checklistItems = results.sorted { $0.name < $1.name }
    }
    
    var filteredAnimals: [Animal] {
        animals.filter { filter.isEmpty || $0.name.localizedCaseInsensitiveContains(filter) }
    }
    
    var filteredPelts: [Pelt] {
        pelts.filter { filter.isEmpty || $0.name.localizedCaseInsensitiveContains(filter) }
    }
    
    var filteredList: [SearchableItem] {
        let filteredAnimals = self.filteredAnimals.map { SearchableItem.animal($0) }
        let filteredPelts = self.filteredPelts.map { SearchableItem.pelt($0) }
        
        // Filter checklist items locally since we don't need a separate filteredChecklistItems property exposed yet
        let filteredChecklist = checklistItems.filter { filter.isEmpty || $0.name.localizedCaseInsensitiveContains(filter) }
                                              .map { SearchableItem.checklistItem($0) }
                                              
        return filteredAnimals + filteredPelts + filteredChecklist
    }
    
    func getAnimal(by name: String) -> Animal? {
        animals.first { $0.name == name }
    }
    
    func getPelt(by name: String) -> Pelt? {
        pelts.first { $0.name == name }
    }
}
 
