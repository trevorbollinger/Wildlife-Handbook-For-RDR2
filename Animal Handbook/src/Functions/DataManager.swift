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
    
    var id: UUID {
        switch self {
        case .animal(let animal):
            return animal.id
        case .pelt(let pelt):
            return pelt.id
        }
    }
    
    var name: String {
        switch self {
        case .animal(let animal):
            return animal.name
        case .pelt(let pelt):
            return pelt.name
        }
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
        return filteredAnimals + filteredPelts
    }
    
    func getAnimal(by name: String) -> Animal? {
        animals.first { $0.name == name }
    }
    
    func getPelt(by name: String) -> Pelt? {
        pelts.first { $0.name == name }
    }
}
 
