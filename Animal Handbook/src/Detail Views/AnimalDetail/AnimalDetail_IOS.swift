import SwiftUI

struct AnimalDetail: View {
    let animal: Animal
    let pelts: [Pelt]
    @State private var presentedPelt: Pelt? = nil

    private let sectionSpacing: CGFloat = 3.0

    var body: some View {
        #if os(tvOS)
            AnimalDetailTVOS(
                animal: animal,
                pelts: pelts,
                presentedPelt: $presentedPelt
            )
        #elseif os(macOS)
            AnimalDetail_MACOS(
                animal: animal,
                pelts: pelts
            )
        #else
            ScrollView {
                VStack(alignment: .leading, spacing: sectionSpacing) {
                    // Header Image
                    Image(animal.mainImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(
                            minWidth: 0,
                            maxWidth: .infinity,
                            minHeight: 0,
                            maxHeight: .infinity
                        )
                        .clipped()
                        .flexibleHeaderContent()

                    // Animal Name
                    //With Warning
                    if animal.danger == "5" {
                        HStack {
                            Text(animal.name)
                                .font(.custom("ChineseRocksFree", size: 40))
                                .padding(.bottom, 8)

                            Spacer()

                            Image(systemName: "hazardsign.fill")
                                .font(.system(size: 32, design: .rounded))
                                .foregroundColor(.red)

                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        //Without Warning
                    } else {
                        HStack {
                            Text(animal.name)
                                .font(.custom("ChineseRocksFree", size: 40))
                                .padding(.bottom, 8)

                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }

                    //Main Body
                    VStack(alignment: .leading, spacing: 16) {
                        // Description Section
                        if !animal.description.isEmpty {
                            VStack(alignment: .leading, spacing: 0) {
                                Text(animal.description)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .modifier(GlassEffectModifier())
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
                            }
                        }

                        // Trivia Section
                        if !animal.trivia.isEmpty {
                            InfoSection(icon: "lightbulb", title: "Trivia") {
                                Text(animal.trivia)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .flexibleHeaderScrollView()
            .ignoresSafeArea(edges: .top)
            .sheet(item: $presentedPelt) { pelt in
                NavigationStack {
                    PeltDetail(pelt: pelt, compact: true)
                }
                .presentationDetents([.medium, .fraction(0.95)])
            }
        #endif
    }
}

#Preview {
    NavigationStack {
        AnimalDetail(
            animal: Animal(
                id: UUID(),
                name: "American Alligator (Small)",
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
    }
}
