//
//  GlassEffectModifier.swift
//  Animal Handbook for RDR2
//
//  Created by Trevor Bollinger on 1/13/26.
//


import SwiftUI

struct GlassEffectModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, *) {
            content
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        } else {
            content
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(20)
        }
    }
}

struct GlassButtonStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, *) {
            content.buttonStyle(.bordered)
                .tint(.blue)
        } else {
            content
                .padding(8)
                .background(Color.blue.opacity(0.2))
                .cornerRadius(8)
        }
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, *)
extension Material {
    static let liquidGlass = Material.ultraThin
}

#Preview {
    ZStack {
        Color.blue
        
        Text("Glass Effect")
            .padding()
            .modifier(GlassEffectModifier())
            .frame(width: 200, height: 100)
    }
}

