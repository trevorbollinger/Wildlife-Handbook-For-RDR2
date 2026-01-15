//
//  ItemRowDetail.swift
//  Animal Handbook for RDR2
//
//  Created by Trevor Bollinger on 12/5/25.
//

import SwiftUI

struct ItemRowDetail: View {
    let title: String
    let description: String
    let subtitle: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                if let subtitle = subtitle {
                    Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
        }
        
        Text(description)
            .font(.subheadline)
            .foregroundColor(.secondary)
            .lineLimit(2)
    }
    .padding(.vertical, 0)
    }
}

#Preview {
    List {
        ItemRowDetail(
            title: "American Alligator",
            description: "Big teeth, scaly skin, hangs out in swamps.",
            subtitle: "Lemoyne"
        )
        ItemRowDetail(
            title: "Badger",
            description: "Small, angry, digs holes.",
            subtitle: nil
        )
    }
}
