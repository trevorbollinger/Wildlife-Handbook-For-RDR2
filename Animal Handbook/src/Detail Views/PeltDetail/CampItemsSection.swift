//
//  CampItemsSection.swift
//  Animal Handbook for RDR2
//
//  Created by Trevor Bollinger on 12/4/25.
//

import SwiftUI

struct CampItemsSection: View {
    let campItems: [CampItem]
    let paddingAmount: CGFloat
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Camp Items")
                .font(.title2)
                .bold()
                .padding(.bottom, paddingAmount)
            
            
            ForEach(campItems, id: \.self) { item in
                CampItemRow(item: item, paddingAmount: paddingAmount)
            }
        }
    }
}

struct CampItemRow: View {
    let item: CampItem
    let paddingAmount: CGFloat
    
    @StateObject private var checklistManager = ChecklistManager.shared
    @EnvironmentObject var storeKitManager: StoreKitManager
    @State private var showingProAlert = false
    
    var body: some View {
        //Item Container
        VStack(alignment: .leading, spacing: 8) {
            // Name and Checkbox
            HStack(alignment: .center) {
                
                //Name
                Text(item.name)
                    .font(.custom("ChineseRocksFree", size: 21))
                    .foregroundColor(.primary)
                
                Spacer()
                
                // Checkbox
                Button(action: {
                    if !storeKitManager.hasPremium {
                        showingProAlert = true
                    } else {
                        withAnimation(.snappy) {
                            checklistManager.toggle(item.name)
                        }
                    }
                }) {
                    Image(systemName: checklistManager.isChecked(item.name) ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .foregroundColor(checklistManager.isChecked(item.name) ? Color("Money") : .secondary)
                }
                .buttonStyle(.plain)
                .padding(.leading, 8)
                .alert("Pro Feature Locked", isPresented: $showingProAlert) {
                    Button("Unlock Pro") {
                        Task {
                            await storeKitManager.unlockPremium()
                        }
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Tracking collected items is a Pro feature. Unlock to track your progress!")
                }
            }
            
            Divider()
                .overlay(Color.primary.opacity(0.1))
            
            //Ingredients List
            VStack(alignment: .leading, spacing: 6) {
                ForEach(item.ingredients, id: \.self) { ingredient in
                    // Parse "x1 Name" -> count: "1", name: "Name"
                    let clean = ingredient.hasPrefix("x") ? String(ingredient.dropFirst()) : ingredient
                    let parts = clean.split(separator: " ", maxSplits: 1)
                    let p0 = parts.first.map(String.init) ?? ""
                    let p1 = parts.count > 1 ? String(parts[1]) : ""
                    let isNumeric = Int(p0) != nil
                    
                    let showCount = ingredient.hasPrefix("x") && isNumeric && parts.count > 1
                    let displayCount = showCount ? p0 : ""
                    let displayName = showCount ? p1 : clean
                    
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 5))
                            .foregroundColor(.secondary.opacity(0.7))
                            .offset(y: -3)
                        
                        if !displayCount.isEmpty {
                            Text("\(displayCount)x")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                        }
                        
                        Text(displayName)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }
                }
            }
            .padding(.leading, 4)
        }
        .padding(14)
        .modifier(GlassEffectModifier())


    }
}


#Preview {
    Text("Parent Background")
        .sheet(isPresented: .constant(true)) {
            NavigationStack {
                PeltDetail(
                    pelt: Pelt(
                        id: UUID(),
                        name: "Legendary Bear Pelt",
                        description:
                            "The pelt of the legendary Bharati Grizzly Bear. Can be used to craft rare items.",
                        trapperItems: [
                            TrapperItem(
                                id: UUID(),
                                name: "Bear Head Hat",
                                price: 45.0,
                                ingredients: ["Legendary Bear Pelt"]
                            ),
                            TrapperItem(
                                id: UUID(),
                                name: "Bear Head Hat",
                                price: 45.0,
                                ingredients: ["Legendary Bear Pelt"]
                            )
                        ],
                        fenceItems: [
                            FenceItem(
                                id: UUID(),
                                name: "Bear Claw Talisman",
                                price: 29.0,
                                ingredients: ["Legendary Bear Claw", "Silver Chain Bracelet", "Quartz Chunk"],
                                effect: "Decrease health core drain speed by 10%"
                            )
                        ],
                        campItems: [
                            CampItem(
                                id: UUID(),
                                name: "Bear Rug",
                                ingredients: ["Legendary Bear Pelt"]
                            )
                        ]
                    ),
                    compact: true
                )
            }
        }
}

