//
//  InfoSection.swift
//  Animal Handbook for RDR2
//
//  Created by Trevor Bollinger on 12/4/25.
//

import SwiftUI

struct InfoSection<Content: View>: View {
    let icon: String
    let title: String
    var showDanger: Bool = false
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                // Icon
                if icon != "none" {
                    Image(systemName: icon)
                        .bold()
                        .font(.title3)
                    
                }

                // Title
                if title != "" {
                    Text(title)
                        .font(.title3)
                        .bold()
                    // Spacer
                    Spacer()
                    
                    if showDanger {
                        Image(systemName: "hazardsign.fill")
                            .font(.title3)
                    }
                }
    
             
            }
            
            content()
            
        }
        .padding()
        .modifier(GlassEffectModifier())
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
