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
            
            ForEach(0..<campItems.count, id: \.self) { i in
                HStack {
                    Text(campItems[i].name)
                        .font(.headline)
                        .bold()
                        .padding(.bottom, paddingAmount)
                    
                    Spacer()
                }
                
                ForEach(campItems[i].ingredients, id: \.self) { ingredient in
                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                            .foregroundColor(.secondary)
                        Text(ingredient)
                    }
                }
            }
        }
        .padding()
        .glassEffect(.regular, in: .rect(cornerRadius: 15))
    }
}

