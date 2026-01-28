//
//  ShoppingListHelper.swift
//  Animal Handbook for RDR2
//
//  Created by Trevor Bollinger on 1/15/26.
//

import Foundation

struct ShoppingListItem: Identifiable, Hashable, Codable {
    var id = UUID()
    let name: String
    let count: Int
}

struct ShoppingListHelper {
    static func generateShoppingList(from items: [CheckedItem]) -> [ShoppingListItem] {
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
}
