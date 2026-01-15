//
//  ShoppingListView.swift
//  Animal Handbook for RDR2
//
//  Created by Trever Bollinger on 1/15/26.
//

import SwiftUI
import Foundation

struct ShoppingListItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let count: Int
}

struct ShoppingListView: View {
    let items: [CheckedItem] 
    
    // Aggregate ingredients from all items
    var shoppingList: [ShoppingListItem] {
        var ingredientCounts: [String: Int] = [:]
        
        for item in items {
            for ingredient in item.ingredients {
                // Parse "x2 Perfect Bear Pelt" or "Perfect Bear Pelt"
                let clean = ingredient.hasPrefix("x") ? String(ingredient.dropFirst()) : ingredient
                let parts = clean.split(separator: " ", maxSplits: 1)
                
                var count = 1
                var name = clean
                
                if let firstPart = parts.first, let parsedCount = Int(firstPart) {
                    count = parsedCount
                    if parts.count > 1 {
                        name = String(parts[1])
                    }
                }
                
                // Normalization for grouping (trim whitespace)
                let trimmedName = name.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                if !trimmedName.isEmpty {
                    ingredientCounts[trimmedName, default: 0] += count
                }
            }
        }
        
        return ingredientCounts.map { ShoppingListItem(name: $0.key, count: $0.value) }
            .sorted { $0.name < $1.name }
    }
    
    var totalCost: Double {
        items.compactMap { $0.price }.reduce(0, +)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    Text("Shopping List")
                        .font(.custom("ChineseRocksFree", size: 32))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 10)
                    
                    if items.isEmpty {
                        ContentUnavailableView("No Items Tracked", systemImage: "cart.badge.plus", description: Text("Add items to your cart from the Checklist."))
                            .padding(.top, 40)
                    } else {
                        // Total Cost Section
                        HStack {
                            Text("Total Estimated Cost:")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("$\(totalCost, specifier: "%.2f")")
                                .font(.custom("ChineseRocksFree", size: 28))
                                .foregroundColor(Color("Money"))
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color("Money").opacity(0.1))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color("Money").opacity(0.3), lineWidth: 1)
                        )
                        
                        // Ingredients Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Required Ingredients")
                                .font(.title3)
                                .bold()
                                .padding(.bottom, 4)
                            
                            ForEach(shoppingList) { ingredient in
                                HStack(alignment: .firstTextBaseline) {
                                    Text("\(ingredient.count)x")
                                        .font(.headline)
                                        .bold()
                                        .foregroundColor(Color("Money"))
                                        .frame(width: 40, alignment: .leading)
                                    
                                    Text(ingredient.name)
                                        .font(.body)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                }
                                .padding(.vertical, 2)
                                Divider()
                            }
                        }
                        .padding()
                        .modifier(GlassEffectModifier())
                        
                        // Tracked Items List Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Tracked Items")
                                .font(.title3)
                                .bold()
                                .padding(.bottom, 4)
                            
                            LazyVStack(spacing: 8) {
                                ForEach(items) { item in
                                    ChecklistRow(item: item, showIngredients: false)
                                        .buttonStyle(.plain) // Ensure tap works for row navigation
                                }
                            }
                        }
                        .padding()
                    }
                }
                .padding()
            }
            .navigationTitle("Shopping List")
            .navigationDestination(for: CheckedItem.self) { item in
                ItemDetail(item: item)
            }
        }
    }
}
