//
//  LootList.swift
//  Animal Handbook for RDR2
//
//  Created by Trevor Bollinger on 12/4/25.
//

import SwiftUI

struct LootList: View {
    let loot: [String]
    let pelts: [Pelt]
    @Binding var presentedPelt: Pelt?
    
    var body: some View {
        ForEach(loot, id: \.self) { item in
            LootButton(
                item: item,
                pelts: pelts,
                presentedPelt: $presentedPelt
            )
        }
    }
}

