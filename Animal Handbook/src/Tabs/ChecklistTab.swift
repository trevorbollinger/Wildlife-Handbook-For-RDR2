//
//  ChecklistTab.swift
//  Animal Handbook for RDR2
//
//  Created by Trever Bollinger on 1/15/26.
//

import SwiftUI

struct CheckedItem: Identifiable, Hashable {
    let id: UUID
    let name: String
    let type: ItemType
    let price: Double?
    let ingredients: [String]
    let sourcePeltName: String
    
    enum ItemType: String {
        case trapper = "Trapper"
        case fence = "Fence"
        case camp = "Camp"
    }
}

struct ChecklistTab: View {
    @Environment(DataManager.self) var manager
    @StateObject private var checklistManager = ChecklistManager.shared
    
    var allItems: [CheckedItem] {
        var results: [CheckedItem] = []
        var seenNames: Set<String> = []
        
        for pelt in manager.pelts {
            // Trapper Items
            for item in pelt.trapperItems {
                if !item.name.isEmpty && !seenNames.contains(item.name) {
                    seenNames.insert(item.name)
                    results.append(CheckedItem(
                        id: item.id,
                        name: item.name,
                        type: .trapper,
                        price: item.price,
                        ingredients: item.ingredients,
                        sourcePeltName: pelt.name
                    ))
                }
            }
            
            // Fence Items
            for item in pelt.fenceItems {
                if !item.name.isEmpty && !seenNames.contains(item.name) {
                    seenNames.insert(item.name)
                    results.append(CheckedItem(
                        id: item.id,
                        name: item.name,
                        type: .fence,
                        price: item.price,
                        ingredients: item.ingredients,
                        sourcePeltName: pelt.name
                    ))
                }
            }
            
            // Camp Items
            for item in pelt.campItems {
                if !item.name.isEmpty && !seenNames.contains(item.name) {
                    seenNames.insert(item.name)
                    results.append(CheckedItem(
                        id: item.id,
                        name: item.name,
                        type: .camp,
                        price: nil,
                        ingredients: item.ingredients,
                        sourcePeltName: pelt.name
                    ))
                }
            }
        }
        
        return results.sorted { $0.name < $1.name }
    }
    
    var checkedItems: [CheckedItem] {
        allItems.filter { checklistManager.isChecked($0.name) }
    }
    
    var uncheckedItems: [CheckedItem] {
        allItems.filter { !checklistManager.isChecked($0.name) }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    
                    if !checkedItems.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Checked Items")
                                .font(.title2)
                                .bold()
                            
                            LazyVStack(spacing: 12) {
                                ForEach(checkedItems) { item in
                                    ChecklistRow(item: item, showIngredients: false)
                                }
                            }
                        }
                    }
                    
                    if !uncheckedItems.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Missing Items")
                                .font(.title2)
                                .bold()
                            
                            LazyVStack(spacing: 12) {
                                ForEach(uncheckedItems) { item in
                                    ChecklistRow(item: item, showIngredients: true)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Checklist")
        }
    }
}

struct ChecklistRow: View {
    let item: CheckedItem
    let showIngredients: Bool
    @StateObject private var checklistManager = ChecklistManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header: Name, Price, Checkbox
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.custom("ChineseRocksFree", size: 21))
                        .foregroundColor(.primary)
                    
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
                
                // Checkbox
                Button(action: {
                    withAnimation(.snappy) {
                        checklistManager.toggle(item.name)
                    }
                }) {
                    Image(systemName: checklistManager.isChecked(item.name) ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .foregroundColor(checklistManager.isChecked(item.name) ? Color("Money") : .secondary)
                }
                .buttonStyle(.plain)
                .padding(.leading, 8)
            }
            
            if showIngredients {
                Rectangle()
                    .fill(Color.primary.opacity(0.2))
                    .frame(height: 1)
                
                // Ingredients
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(item.ingredients, id: \.self) { ingredient in
                        // Reuse the nice parsing logic from TrapperItemsSection
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
        }
        .padding(14)
        .modifier(GlassEffectModifier())
        .padding(.vertical, 1)
    }
}

#Preview {
    // Pre-populate some items for preview
    let previewNames = [
        "Alligator Ranch Cutter Saddle",
        "Alligator Tooth Talisman",
        "Materials Satchel"
    ]
    
    for name in previewNames {
        if !ChecklistManager.shared.isChecked(name) {
            ChecklistManager.shared.toggle(name)
        }
    }
    
    return ChecklistTab()
        .environment(DataManager())
}
