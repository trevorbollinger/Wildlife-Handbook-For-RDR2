import SwiftUI

struct AnimalDetail_MACOS: View {
    let animal: Animal
    let pelts: [Pelt]
    @State private var presentedPelt: Pelt? = nil

    private let sectionSpacing: CGFloat = 16.0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Image
                Image(animal.mainImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 300)
                    .clipped()
                    .cornerRadius(20)

                // Animal Name and Danger Warning
                HStack {
                    Text(animal.name)
                        .font(.custom("ChineseRocksFree", size: 48))
                    
                    Spacer()

                    if animal.danger == "5" {
                        Image(systemName: "hazardsign.fill")
                            .font(.system(size: 32, design: .rounded))
                            .foregroundColor(.red)
                            .help("Dangerous Animal")
                    }
                }
                .padding(.top, 8)

                // Main Body Content
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Description Section
                    if !animal.description.isEmpty {
                        Text(animal.description)
                            .font(.body)
                            .lineSpacing(4)
                            .padding()
                            .background(.regularMaterial)
                            .cornerRadius(20)
                    }

                    // Combined Info Grid
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 300), spacing: 16)], spacing: 16) {
                        
                        // Locations
                        InfoSection(icon: "map", title: "Locations") {
                            LocationsList(locations: animal.location)
                        }
                        
                        // Drops
                        if !animal.loot.isEmpty {
                            InfoSection(icon: "bag", title: "Drops") {
                                LootList(
                                    loot: animal.loot,
                                    pelts: pelts,
                                    presentedPelt: $presentedPelt
                                )
                            }
                        }
                        
                        // Tips
                        if !animal.tips.isEmpty {
                            InfoSection(icon: "questionmark", title: "Tips") {
                                Text(animal.tips)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        
                        // Trivia
                        if !animal.trivia.isEmpty {
                            InfoSection(icon: "lightbulb", title: "Trivia") {
                                Text(animal.trivia)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .sheet(item: $presentedPelt) { pelt in
             PeltDetail(pelt: pelt, compact: false)
                .frame(minWidth: 500, minHeight: 600)
        }
        .withPremiumSheet()
    }
}
