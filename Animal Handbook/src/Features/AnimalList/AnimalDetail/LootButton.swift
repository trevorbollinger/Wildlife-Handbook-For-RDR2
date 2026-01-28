//
//  LootButton.swift
//  Animal Handbook for RDR2
//
//  Created by Trevor Bollinger on 12/4/25.
//

import SwiftUI

struct LootButton: View {
    let item: String
    let pelts: [Pelt]
    @Binding var presentedPelt: Pelt?
    
    var body: some View {
        if isInteractive {
            Group {
                Button {
                    presentedPelt = determineSelectedPelt(for: item)
                } label: {
                    Group {
                        HStack {
                            Image(systemName: "bag.fill.badge.plus")
                            Text(item)
                        }
                    }
                    .foregroundStyle(.blue)


                    #if os(tvOS)
                    .padding(.vertical, 4)
                    #endif
                }
            }
            .modifier(GlassButtonStyleModifier())
        } else {
            HStack {
                Image(systemName: "bag.fill.badge.plus")
                    .font(.headline)
                Text(item)
                    .foregroundColor(.primary)
            }
        }
        
 
    }
    
    private var isInteractive: Bool {
        pelts.contains(where: { $0.name == item }) || isSpecialLoot(item)
    }
    
    private func determineSelectedPelt(for item: String) -> Pelt? {
        if let matchingPelt = pelts.first(where: { $0.name == item }) {
            return matchingPelt
        }
        
        return getPeltForSpecialLoot(item, from: pelts)
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
