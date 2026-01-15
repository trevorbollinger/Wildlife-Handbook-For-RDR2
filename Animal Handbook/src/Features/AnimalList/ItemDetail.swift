//
//  ItemDetail.swift
//  Animal Handbook for RDR2
//
//  Created by Trevor Bollinger on 1/15/26.
//

import SwiftUI

struct ItemDetail: View {
    let item: CheckedItem
    @StateObject private var checklistManager = ChecklistManager.shared
    @EnvironmentObject var storeKitManager: StoreKitManager

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header with Name and Price
                VStack(alignment: .leading, spacing: 8) {
                    Text(item.name)
                        .font(.custom("ChineseRocksFree", size: 34))
                        .bold()
                        .foregroundColor(.primary)

                    HStack {
                        if let price = item.price {
                            Text("$\(price, specifier: "%.2f")")
                                .font(.custom("ChineseRocksFree", size: 24))
                                .bold()
                                .foregroundColor(Color("Money"))

                            Text("•")
                                .foregroundColor(.secondary)
                        }

                        Text("\(item.type.rawValue) Item")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .modifier(GlassEffectModifier())

                // Ingredients Section
                if !item.ingredients.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Ingredients")
                            .font(.title2)
                            .bold()
                            .padding(.bottom, 4)

                        ForEach(item.ingredients, id: \.self) { ingredient in
                            // Parse ingredient for better display
                            let clean =
                                ingredient.hasPrefix("x")
                                ? String(ingredient.dropFirst()) : ingredient
                            let parts = clean.split(
                                separator: " ",
                                maxSplits: 1
                            )
                            let p0 = parts.first.map(String.init) ?? ""
                            let p1 = parts.count > 1 ? String(parts[1]) : ""
                            let isNumeric = Int(p0) != nil

                            let showCount =
                                ingredient.hasPrefix("x") && isNumeric
                                && parts.count > 1
                            let displayCount = showCount ? p0 : ""
                            let displayName = showCount ? p1 : clean

                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "circle.fill")
                                    .font(.system(size: 6))
                                    .foregroundColor(.secondary.opacity(0.7))
                                    .padding(.top, 6)

                                if !displayCount.isEmpty {
                                    Text("\(displayCount)x")
                                        .font(.body)
                                        .fontWeight(.bold)
                                        .foregroundColor(.secondary)
                                }

                                Text(displayName)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                    .fixedSize(
                                        horizontal: false,
                                        vertical: true
                                    )

                                Spacer()
                            }
                            .padding(.vertical, 4)

                            if ingredient != item.ingredients.last {
                                Divider()
                            }
                        }
                    }
                    .padding()
                    .modifier(GlassEffectModifier())
                }

                // Status Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Status")
                        .font(.title2)
                        .bold()

                    // Collected Toggle
                    Button(action: {
                        if !storeKitManager.hasPremium {
                            storeKitManager.showPremiumSheet = true
                        } else {
                            withAnimation {
                                checklistManager.toggleCollected(item.name)
                            }
                        }
                    }) {
                        HStack {
                            Text(
                                checklistManager.isCollected(item.name)
                                    ? "Collected" : "Not Collected"
                            )
                            .font(.headline)
                            .foregroundColor(
                                checklistManager.isCollected(item.name)
                                    ? Color("Money") : .primary
                            )

                            Spacer()

                            Image(systemName: checklistManager.isCollected(item.name) ? "checkmark.circle.fill" : "circle")
                                .font(.title2)
                                .foregroundColor(checklistManager.isCollected(item.name) ? Color("Money") : .secondary)
                        }
                    }
                    .padding()
                    .background(Color.primary.opacity(0.05))
                    .cornerRadius(8)

                    // Shopping List Toggle
                    Button(action: {
                        if !storeKitManager.hasPremium {
                            storeKitManager.showPremiumSheet = true
                        } else {
                            withAnimation {
                                checklistManager.toggleTracked(item.name)
                            }
                        }
                    }) {
                        HStack {
                            Text(
                                checklistManager.isTracked(item.name)
                                    ? "Tracked in Shopping List"
                                    : "Add to Shopping List"
                            )
                            .font(.headline)
                            .foregroundColor(
                                checklistManager.isTracked(item.name)
                                    ? Color("Money") : .primary
                            )

                            Spacer()

                            Image(systemName: checklistManager.isTracked(item.name) ? "cart.badge.minus" : "cart.badge.plus")
                                .font(.title2)
                                .foregroundColor(checklistManager.isTracked(item.name) ? Color("Money") : .secondary)
                        }
                    }
                    .padding()
                    .background(Color.primary.opacity(0.05))
                    .cornerRadius(8)
                }
                .padding()
                .modifier(GlassEffectModifier())

                Spacer()
            }
            .padding()
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .withPremiumSheet()
    }
}

#Preview {
    NavigationView {
        ZStack {
            Color.gray.opacity(0.2).ignoresSafeArea()

            ItemDetail(
                item: CheckedItem(
                    id: UUID(),
                    name: "Legendary Bear Head Hat",
                    type: .trapper,
                    price: 45.00,
                    ingredients: ["x1 Legendary Bear Pelt"],
                    sourcePeltName: "Legendary Bear Pelt"
                )
            )
        }
    }
}
