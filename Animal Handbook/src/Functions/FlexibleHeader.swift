//
//  FlexibleHeader.swift
//  Animal Handbook for RDR2
//
//  Created by Trevor Bollinger on 12/4/25.
//

import SwiftUI

@Observable private class FlexibleHeaderGeometry {
    var offset: CGFloat = 0
}

/// A view modifer that stretches content when the containing geometry offset changes.
private struct FlexibleHeaderContentModifier: ViewModifier {
    @Environment(FlexibleHeaderGeometry.self) private var geometry
    
    #if os(iOS)
    private var initialHeight: CGFloat {
        UIScreen.main.bounds.height / 2.75
    }
    #elseif os(macOS)
    private var initialHeight: CGFloat {
        450
    }
    #else
    private var initialHeight: CGFloat {
        450
    }
    #endif

    func body(content: Content) -> some View {
        let height = initialHeight - geometry.offset
        content
            .frame(height: max(height, 50))
            .padding(.bottom, geometry.offset)
            .offset(y: geometry.offset)
    }
}

/// A view modifier that tracks scroll view geometry to stretch a view with ``FlexibleHeaderContentModifier``.
private struct FlexibleHeaderScrollViewModifier: ViewModifier {
    @State private var geometry = FlexibleHeaderGeometry()

    func body(content: Content) -> some View {
        content
            .onScrollGeometryChange(for: CGFloat.self) { geometry in
                min(geometry.contentOffset.y + geometry.contentInsets.top, 0)
            } action: { _, offset in
                geometry.offset = offset
            }
            .environment(geometry)
    }
}

// MARK: - View Extensions

extension ScrollView {
    /// A function that returns a view after it applies `FlexibleHeaderScrollViewModifier` to it.
    @MainActor func flexibleHeaderScrollView() -> some View {
        modifier(FlexibleHeaderScrollViewModifier())
    }
}

extension View {
    /// A function that returns a view after it applies `FlexibleHeaderContentModifier` to it.
    func flexibleHeaderContent() -> some View {
        modifier(FlexibleHeaderContentModifier())
    }
}
