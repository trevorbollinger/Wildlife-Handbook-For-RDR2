//
//  LootButton.swift
//  Animal Handbook for RDR2
//
//  Created by Trevor Bollinger on 12/4/25.
//

import SwiftUI

struct LootButton: View {
    let item: String
    let pelts: [Pelt]
    @Binding var presentedPelt: Pelt?
    
    var body: some View {
        if isInteractive {
            Button {
                presentedPelt = determineSelectedPelt(for: item)
            } label: {
                Group {
                    HStack {
                        Image(systemName: "bag.fill.badge.plus")
                            .font(.headline)
                        Text(item)
                    }
                }
                .foregroundStyle(.blue)


                #if os(tvOS)
                .padding(.vertical, 4)
                #endif
            }
            .buttonStyle(.glass)
        } else {
            HStack {
                Image(systemName: "bag.fill.badge.plus")
                    .font(.headline)
                Text(item)
                    .foregroundColor(.primary)
            }
        }
        
 
    }
    
    private var isInteractive: Bool {
        pelts.contains(where: { $0.name == item }) || isSpecialLoot(item)
    }
    
    private func determineSelectedPelt(for item: String) -> Pelt? {
        if let matchingPelt = pelts.first(where: { $0.name == item }) {
            return matchingPelt
        }
        
        return getPeltForSpecialLoot(item, from: pelts)
    }
}

