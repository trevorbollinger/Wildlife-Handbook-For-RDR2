//
//  Pelt.swift
//  Hunting Handbook
//
//  Created by Trevor Bollinger on 1/4/23.
//

import SwiftUI

struct Pelt: Codable, Hashable, Identifiable {
    var id: UUID
    var name: String
    var description: String
    var trapperItems: [TrapperItem]
    var fenceItems: [FenceItem]
    var campItems: [CampItem]
    
    var mainImage: String {
        name.replacingOccurrences(of: " ", with: "-").lowercased()
    }
    
    var thumbnailImage: String {
        "\(mainImage)-thumb"
    }
    

}

struct TrapperItem: Codable, Hashable, Identifiable {

    var id: UUID
    var name: String
    var price: Double
    var ingredients: [String]


}

struct FenceItem: Codable, Hashable, Identifiable {

    var id: UUID
    var name: String
    var price: Double
    var ingredients: [String]
    var effect: String


}
struct CampItem: Codable, Hashable, Identifiable {

    var id: UUID
    var name: String
    var ingredients: [String]


}

func convertToPelt (peltName: String, peltList: [Pelt]) -> Pelt {
    for pelt in peltList {
        if pelt.name == peltName {
            return pelt
        }
    }
    return peltList[0]
}
