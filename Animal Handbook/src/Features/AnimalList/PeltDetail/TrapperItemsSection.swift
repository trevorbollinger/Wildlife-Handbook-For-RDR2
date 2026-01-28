//
//  TrapperItemsSection.swift
//  Animal Handbook for RDR2
//
//  Created by Trevor Bollinger on 12/4/25.
//

import SwiftUI

struct TrapperItemsSection: View {
    let trapperItems: [TrapperItem]
    let paddingAmount: CGFloat
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Trapper Items")
                .font(.title2)
                .bold()
                .padding(.bottom, paddingAmount)
            
            ForEach(trapperItems, id: \.self) { item in
                NavigationLink(destination: ItemDetail(item: CheckedItem(
                    id: item.id,
                    name: item.name,
                    type: .trapper,
                    price: item.price,
                    ingredients: item.ingredients,
                    sourcePeltName: ""
                ))) {
                    TrapperItemRow(item: item, paddingAmount: paddingAmount)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct TrapperItemRow: View {
    let item: TrapperItem
    let paddingAmount: CGFloat
    
    @StateObject private var checklistManager = ChecklistManager.shared
    @EnvironmentObject var storeKitManager: StoreKitManager
    
    var body: some View {
        //Item Container
        VStack(alignment: .leading, spacing: 8) {
            // Name and Price
            HStack(alignment: .center) {
                
                //Name
                Text(item.name)
                    .font(.custom("ChineseRocksFree", size: 21))
                    .foregroundColor(.primary)
                
                Spacer()
                
                //Price
                Text("$\(item.price, specifier: "%.2f")")
                    .font(.custom("ChineseRocksFree", size: 19))
                    .bold()
                    .foregroundColor(Color("Money"))
                
                // Tracking Button
                if !checklistManager.isChecked(item.name) {
                    Button(action: {
                        if !storeKitManager.hasPremium {
                            storeKitManager.showPremiumSheet = true
                        } else {
                            withAnimation(.snappy) {
                                checklistManager.toggleTracked(item.name)
                            }
                        }
                    }) {
                        Image(systemName: checklistManager.isTracked(item.name) ? "cart.badge.minus" : "cart.badge.plus")
                            .font(.title2)
                            .foregroundColor(checklistManager.isTracked(item.name) ? Color("Money") : .secondary)
                    }
                    .buttonStyle(.plain)
                    .padding(.leading, 8)
                }

                // Checkbox
                Button(action: {
                    if !storeKitManager.hasPremium {
                        storeKitManager.showPremiumSheet = true
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
                .environmentObject(StoreKitManager())
            }
        }
}
