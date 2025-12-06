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
        #else
        ScrollView {
            VStack(alignment: .leading, spacing: sectionSpacing) {
                // Header Image
                Image(animal.mainImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .clipped()
                    .flexibleHeaderContent()
                
                // Animal Name
                HStack {
                    Text(animal.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    if animal.danger == "5" {
                        Image(systemName: "hazardsign.fill")
                            .font(.title3)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                //Main Body
                VStack(alignment: .leading, spacing: 16) {
                    // Description Section
                    if !animal.description.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(animal.description)
                        }
                        .padding()
                        .glassEffect(.regular, in: .rect(cornerRadius: 15))
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
            .presentationDetents([.medium, .large])
            .presentationBackground(.regularMaterial)
        }
        #endif
    }
}

struct AnimalDetail_Preview: PreviewProvider {
    static var previews: some View {
        AnimalDetail(animal: Animal.example1, pelts: Pelt.exampleList)
            .preferredColorScheme(.dark)
    }
}

