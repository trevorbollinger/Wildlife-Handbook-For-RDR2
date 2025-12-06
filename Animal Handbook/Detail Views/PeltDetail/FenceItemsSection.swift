//
//  FenceItemsSection.swift
//  Animal Handbook for RDR2
//
//  Created by Trevor Bollinger on 12/4/25.
//

import SwiftUI

struct FenceItemsSection: View {
    let fenceItems: [FenceItem]
    let paddingAmount: CGFloat
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Fence Items")
                .font(.title2)
                .bold()
                .padding(.bottom, paddingAmount)
            
            ForEach(0..<fenceItems.count, id: \.self) { i in
                HStack {
                    Text(fenceItems[i].name)
                        .font(.headline)
                        .bold()
                        .padding(.bottom, paddingAmount)
                    
                    Spacer()
                    
                    Text("$\(fenceItems[i].price, specifier: "%.2f")")
                        .font(.custom("ChineseRocksFree", size: 17))
                        .bold()
                        .padding(.bottom, paddingAmount)
                        .foregroundColor(Color("Money"))
                }
                
                HStack() {
                    Spacer()
                    Text("\(fenceItems[i].effect)")
                        .italic()
                        .padding(.bottom, paddingAmount)
                    Spacer()
                }
                
                ForEach(fenceItems[i].ingredients, id: \.self) { ingredient in
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

