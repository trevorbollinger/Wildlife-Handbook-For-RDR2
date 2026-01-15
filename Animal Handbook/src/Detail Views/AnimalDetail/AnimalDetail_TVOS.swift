//
//  AnimalDetailTVOS.swift
//  Animal Handbook for RDR2
//
//  Created by Trevor Bollinger on 12/4/25.
//

import SwiftUI

struct AnimalDetailTVOS: View {
    let animal: Animal
    let pelts: [Pelt]
    @Binding var presentedPelt: Pelt?
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 32) {
                // Left side - Image
                Image(animal.mainImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: geometry.size.width * 0.45)
                
                // Right side - Information
                ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Description Section
                    if !animal.description.isEmpty {
                        InfoSection(
                            icon: "newspaper",
                            title: "Description",
                            showDanger: animal.danger == "5"
                        ) {
                            Text(animal.description)
                                .font(.title2)
                        }
                    }
                    
                    // Locations Section
                    InfoSection(icon: "map", title: "Locations") {
                        LocationsList(locations: animal.location)
                    }
                    
                    // Drops Section
                    if !animal.loot.isEmpty {
                        InfoSection(icon: "bag", title: "Drops") {
                            LootList(
                                loot: animal.loot,
                                pelts: pelts,
                                presentedPelt: $presentedPelt
                            )
                        }
                    }
                    
                    // Tips Section
                    if !animal.tips.isEmpty {
                        InfoSection(icon: "questionmark", title: "Tips") {
                            Text(animal.tips)
                                .font(.title2)
                        }
                    }
                    
                    // Trivia Section
                    if !animal.trivia.isEmpty {
                        InfoSection(icon: "lightbulb", title: "Trivia") {
                            Text(animal.trivia)
                                .font(.title2)
                        }
                    }
                }
                .padding(.horizontal)
            }
            }
            .padding()
        }
        .navigationTitle(animal.name)
        .sheet(item: $presentedPelt) { pelt in
            PeltDetail(pelt: pelt, compact: true)
                .presentationDetents([.medium, .large])
        }
    }
}

