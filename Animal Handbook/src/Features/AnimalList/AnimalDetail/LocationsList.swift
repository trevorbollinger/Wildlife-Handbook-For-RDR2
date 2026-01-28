//
//  LocationsList.swift
//  Animal Handbook for RDR2
//
//  Created by Trevor Bollinger on 12/4/25.
//

import SwiftUI

struct LocationsList: View {
    let locations: [String]
    
    var body: some View {
        ForEach(locations, id: \.self) { location in
            HStack {
                Image(systemName: "mappin.circle.fill")
                Text(location)
            }
            #if os(tvOS)
            .padding(.vertical, 4)
            #endif
        }
    }
}
#Preview {
    NavigationStack {
        AnimalDetail(
            animal: Animal(
                id: UUID(),
                name: "Alligator",
                description:
                    "Native to the swamps and bayous of Lemoyne, the American Alligator is a carnivorous apex predator.",
                location: ["Lemoyne", "Lagras"],
                loot: [
                    "Big Game Meat", "Alligator Tooth",
                    "Perfect Alligator Skin",
                ],
                tips: "Use a rifle for a clean kill.",
                trivia: "They are older than dinosaurs.",
                danger: "5"
            ),
            pelts: []
        )
        .environmentObject(StoreKitManager())
    }
}
