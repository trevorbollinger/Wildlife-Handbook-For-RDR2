//
//  Animal.swift
//  Hunting Handbook
//
//  Created by Trevor Bollinger on 1/2/23.
//

import SwiftUI

struct Animal: Codable, Hashable, Identifiable {
    var id: UUID
    var name: String
    var description: String
    var location: [String]
    var loot: [String]
    var tips: String
    var trivia: String
    var danger: String
    
    
    var mainImage: String {
        name.replacingOccurrences(of: " ", with: "-").lowercased()
    }
    
    var thumbnailImage: String {
        "\(mainImage)-thumb"
    }

    
}
