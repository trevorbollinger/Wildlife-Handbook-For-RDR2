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
                
                // Item Container
                VStack {
                    //title and price
                    HStack {
                        //title
                        Text(fenceItems[i].name)
                            .font(.headline)
                            .bold()
                            .padding(.bottom, paddingAmount)
                        
                        Spacer()
                        
                        //price
                        Text("$\(fenceItems[i].price, specifier: "%.2f")")
                            .font(.custom("ChineseRocksFree", size: 19))
                            .bold()
                            .padding(.bottom, paddingAmount)
                            .foregroundColor(Color("Money"))
                    }
                    
                    //Effects
                    HStack() {
                        Spacer()
                        Text("\(fenceItems[i].effect)")
                            .italic()
                            .padding(.bottom, paddingAmount)
                        Spacer()
                    }
                    
                    //ingredients list
                    ForEach(fenceItems[i].ingredients, id: \.self) { ingredient in
                        HStack(alignment: .top, spacing: 8) {
                            Text("•")
                                .foregroundColor(.secondary)
                            Text(ingredient)
                            Spacer()
                        }
                        
                    }
                }
                .padding()
                .modifier(GlassEffectModifier())
                
                
      
            }
            
        }
        .padding()
        .modifier(GlassEffectModifier())
    }
}

