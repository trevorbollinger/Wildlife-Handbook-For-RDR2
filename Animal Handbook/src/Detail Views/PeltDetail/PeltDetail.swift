//
//  PeltDetail.swift
//  Hunting Handbook
//
//  Created by Trevor Bollinger on 1/4/23.
//

import SwiftUI

struct PeltDetail: View {
    
    let pelt: Pelt
    let compact: Bool
    @Environment(\.dismiss) private var dismiss
    
    let paddingAmount = 3.0
    
    private var hasItems: Bool {
        !pelt.trapperItems.isEmpty && pelt.trapperItems[0].name != "" ||
        !pelt.fenceItems.isEmpty && pelt.fenceItems[0].name != "" ||
        !pelt.campItems.isEmpty && pelt.campItems[0].name != ""
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                if !hasItems {
                    // Description only
                    Text(pelt.description)
                        .lineSpacing(5.0)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .modifier(GlassEffectModifier())
                } else {
                    // Items sections
                    VStack(alignment: .leading, spacing: 16) {
                        if !pelt.trapperItems.isEmpty && pelt.trapperItems[0].name != "" {
                            TrapperItemsSection(
                                trapperItems: pelt.trapperItems,
                                paddingAmount: paddingAmount
                            )
                        }
                        
                        if !pelt.fenceItems.isEmpty && pelt.fenceItems[0].name != "" {
                            FenceItemsSection(
                                fenceItems: pelt.fenceItems,
                                paddingAmount: paddingAmount
                            )
                        }
                        
                        if !pelt.campItems.isEmpty && pelt.campItems[0].name != "" {
                            CampItemsSection(
                                campItems: pelt.campItems,
                                paddingAmount: paddingAmount
                            )
                        }
                    }
                    .padding(.bottom, paddingAmount)
                }
            }
            .padding([.horizontal, .bottom])
        }
        .background {
            // Provide a background for glass effects to blur
            Color.clear
        }
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(pelt.name)
                    .font(.custom("ChineseRocksFree", size: compact ? 28 : 34))
                    .bold()
            }
            
            #if os(iOS) || os(tvOS)
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Label("Close", systemImage: "xmark")
                }
            }
            #else
            ToolbarItem(placement: .automatic) {
                Button {
                    dismiss()
                } label: {
                    Label("Close", systemImage: "xmark")
                }
            }
            #endif
        }
    }
}

