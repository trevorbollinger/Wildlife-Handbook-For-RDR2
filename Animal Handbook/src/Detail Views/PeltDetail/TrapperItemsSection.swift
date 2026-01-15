//
//  TrapperItemsSection.swift
//  Animal Handbook for RDR2
//
//  Created by Trevor Bollinger on 12/4/25.
//

import SwiftUI

struct TrapperItemsSection: View {
    let trapperItems: [TrapperItem]
    let paddingAmount: CGFloat
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Trapper Items")
                .font(.title2)
                .bold()
                .padding(.bottom, paddingAmount)
            
            ForEach(0..<trapperItems.count, id: \.self) { i in
                
                //Item Container
                VStack {
                    // Name and Price
                    HStack {
                        //Name
                        Text(trapperItems[i].name)
                            .font(.headline)
                            .bold()
                            .padding(.bottom, paddingAmount)
                        
                        Spacer()
                        
                        //Price
                        Text("$\(trapperItems[i].price, specifier: "%.2f")")
                            .font(.custom("ChineseRocksFree", size: 19))
                            .bold()
                            .padding(.bottom, paddingAmount)
                            .foregroundColor(Color("Money"))
                    }
                    
                    //Ingredients List
                    ForEach(trapperItems[i].ingredients, id: \.self) { ingredient in
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


