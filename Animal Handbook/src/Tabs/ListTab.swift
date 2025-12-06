//
//  AnimalsTab.swift
//  NewHandbook
//
//  Created by Trevor Bollinger on 12/5/25.
//

import SwiftUI

struct ListTab: View {
    let animals: [Animal]
    @Environment(DataManager.self) var manager
    var body: some View {
        
        var animalNames: [String] {
            animals.map { $0.name }
        }
        
        
        NavigationStack {
            List(animalNames, id: \.self) { animal in
                Text(animal)
            }
            .listStyle(.plain)
            .navigationTitle("Animals")
        }
    }
    
}

#Preview {
    ListTab(animals: Bundle.main.decode([Animal].self, from: "animals.json"))
        .environment(DataManager())
}
