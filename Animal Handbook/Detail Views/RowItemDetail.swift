//
//  RowItemView.swift
//  TestingPlayground
//
//  Created by Trevor Bollinger on 12/5/25.
//

import SwiftUI

struct RowItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let preview: String
    let category: NavigationCategory
}

// Mail Row View
struct RowItemView: View {
    let rowItem: RowItem

    var body: some View {

        VStack(alignment: .leading, spacing: 4) {

            //Title text
            Text(rowItem.title)
                .font(.headline)
                .foregroundColor(.primary)

            //Description text
            Text(rowItem.preview)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)
        }

        .padding(.vertical, 4)
    }
}

