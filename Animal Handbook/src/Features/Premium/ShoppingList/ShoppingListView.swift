//
//  ShoppingListView.swift
//  Animal Handbook for RDR2
//
//  Created by Trever Bollinger on 1/15/26.
//

import SwiftUI
import Foundation

struct ShoppingListView: View {
    let items: [CheckedItem]
    
    // Aggregate ingredients from all items
    var shoppingList: [ShoppingListItem] {
        ShoppingListHelper.generateShoppingList(from: items)
    }
    
    var totalCost: Double {
        items.compactMap { $0.price }.reduce(0, +)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    
                    if items.isEmpty {
                        ContentUnavailableView("No Items Tracked", systemImage: "cart.badge.plus", description: Text("Add items to your cart from the Checklist."))
                            .padding(.top, 40)
                    } else {
                        // Total Cost Section
                        HStack {
                            Text("Total Cost:")
                                .font(.headline)
                            Spacer()
                            Text("$\(totalCost, specifier: "%.2f")")
                                .font(.custom("ChineseRocksFree", size: 28))
                                .foregroundColor(Color("Money"))
                        }
                        
                        .padding(.horizontal)
                        .padding(.vertical,8)
                        .modifier(GlassEffectModifier())

                        
                        // Ingredients Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Required Ingredients")
                                .font(.title3)
                                .bold()
                                .padding(.bottom, 4)
                            
                            ForEach(shoppingList) { ingredient in
                                Divider()
                                HStack(alignment: .firstTextBaseline) {
                                    Text("\(ingredient.count)x")
                                        .font(.headline)
                                        .bold()
                                        .foregroundColor(Color("Money"))
                                        .frame(width: 30, alignment: .leading)
                                    
                                    Text(ingredient.name)
                                        .font(.body)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                }
                                .padding(.vertical, 2)
//                                Divider()
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

#Preview {
    ShoppingListView(items: [
        CheckedItem(
            id: UUID(),
            name: "Bear Grenade",
            type: .trapper,
            price: 12.50,
            ingredients: ["x5 Perfect Bear Pelt", "x1 Fat"],
            sourcePeltName: "Black Bear"
        ),
        CheckedItem(
            id: UUID(),
            name: "Snake Hat",
            type: .trapper,
            price: 22.00,
            ingredients: ["x2 Perfect Snake Skin"],
            sourcePeltName: "Snake"
        )
    ])
    .environmentObject(StoreKitManager())
}
