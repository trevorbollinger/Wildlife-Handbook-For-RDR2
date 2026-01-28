//
//  ChecklistRow.swift
//  Animal Handbook for RDR2
//
//  Created by Trever Bollinger on 1/15/26.
//

import SwiftUI

struct ChecklistRow: View {
    let item: CheckedItem
    let showIngredients: Bool
    @StateObject private var checklistManager = ChecklistManager.shared
    
    var body: some View {
        NavigationLink(value: item) {
            VStack(alignment: .leading, spacing: 8) {
                // Header: Name, Price, Buttons
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.custom("ChineseRocksFree", size: 21))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                        
                        Text("\(item.type.rawValue) Item")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    if let price = item.price {
                        Text("$\(price, specifier: "%.2f")")
                            .font(.custom("ChineseRocksFree", size: 19))
                            .bold()
                            .foregroundColor(Color("Money"))
                    }
                    
                    // Action Buttons
                    HStack(spacing: 12) {
                        // Track Button (Cart)
                        if !checklistManager.isCollected(item.name) {
                            Button(action: {
                                withAnimation(.snappy) {
                                    checklistManager.toggleTracked(item.name)
                                }
                            }) {
                                Image(systemName: checklistManager.isTracked(item.name) ? "cart.badge.minus" : "cart.badge.plus")
                                    .font(.title2)
                                    .foregroundColor(checklistManager.isTracked(item.name) ? .orange : .secondary.opacity(0.8))
                            }
                            .buttonStyle(.plain) // Prevents triggering NavigationLink
                        }
                        
                        // Collect Button (Check)
                        Button(action: {
                            withAnimation(.snappy) {
                                checklistManager.toggleCollected(item.name)
                            }
                        }) {
                            Image(systemName: checklistManager.isCollected(item.name) ? "checkmark.circle.fill" : "circle")
                                .font(.title2)
                                .foregroundColor(checklistManager.isCollected(item.name) ? Color("Money") : .secondary)
                        }
                        .buttonStyle(.plain) // Prevents triggering NavigationLink
                    }
                    .padding(.leading, 8)
                }
                
                if showIngredients {
                    Rectangle()
                        .fill(Color.primary.opacity(0.2))
                        .frame(height: 1)
                    
                    // Ingredients
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(item.ingredients, id: \.self) { ingredient in
                            // Reuse the parsing logic
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
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                            }
                        }
                    }
                    .padding(.leading, 4)
                }
            }
            .padding(14)
            .modifier(GlassEffectModifier())
            .padding(.vertical, 1)
        }
        .buttonStyle(.plain) // Removes default list row styling for the NavigationLink
    }
}

#Preview {
    ChecklistTab()
        .environment(DataManager())
        .environmentObject(StoreKitManager())
}

