//
//  LocationsList.swift
//  Animal Handbook for RDR2
//
//  Created by Trevor Bollinger on 12/4/25.
//

import SwiftUI

struct LocationsList: View {
    let locations: [String]
    
    var body: some View {
        ForEach(locations, id: \.self) { location in
            HStack {
                Image(systemName: "mappin.circle.fill")
                    .font(.headline)
                Text(location)
            }
            #if os(tvOS)
            .padding(.vertical, 4)
            #endif
        }
    }
}
