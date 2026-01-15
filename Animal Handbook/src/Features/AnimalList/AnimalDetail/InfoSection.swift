//
//  InfoSection.swift
//  Animal Handbook for RDR2
//
//  Created by Trevor Bollinger on 12/4/25.
//

import SwiftUI

struct InfoSection<Content: View>: View {
    let icon: String
    let title: String
    var showDanger: Bool = false
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                // Icon
                if icon != "none" {
                    Image(systemName: icon)
                        .bold()
                        .font(.title3)
                    
                }

                // Title
                if title != "" {
                    Text(title)
                        .font(.title2)
                        .bold()
                    // Spacer
                    Spacer()
                    
                    if showDanger {
                        Image(systemName: "hazardsign.fill")
                            .font(.title3)
                    }
                }
    
             
            }
            
            content()
            
        }
        .padding()
        .modifier(GlassEffectModifier())
    }
}

