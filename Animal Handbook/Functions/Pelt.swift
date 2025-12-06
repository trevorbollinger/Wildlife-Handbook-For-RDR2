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
    
#if DEBUG
    static let example1 = Pelt(id: UUID(), name: "Alligator Skin", description: "Tough skin used for crafting sturdy items.", trapperItems: [TrapperItem.example, TrapperItem.example2], fenceItems: [FenceItem.example], campItems: [CampItem.example])
    
    static let example2 = Pelt(id: UUID(), name: "Cougar Pelt", description: "A perfect cougar pelt can be sold or used to craft various items.", trapperItems: [TrapperItem.example], fenceItems: [FenceItem.example], campItems: [CampItem.example])
    
    static let example3 = Pelt(id: UUID(), name: "Deer Pelt", description: "Deer pelts are common and can be used for crafting basic items.", trapperItems: [TrapperItem.example], fenceItems: [FenceItem.example], campItems: [CampItem.example])
    
    static let example4 = Pelt(id: UUID(), name: "Wolf Pelt", description: "A pristine wolf pelt is valuable and used for crafting.", trapperItems: [TrapperItem.example], fenceItems: [FenceItem.example], campItems: [CampItem.example])
    
    static let example5 = Pelt(id: UUID(), name: "Bison Pelt", description: "Bison pelts are large and sturdy, perfect for crafting heavy-duty items.", trapperItems: [TrapperItem.example], fenceItems: [FenceItem.example], campItems: [CampItem.example])
    
    static let exampleList = [example1, example2, example3, example4, example5]
#endif

}

struct TrapperItem: Codable, Hashable, Identifiable {

    var id: UUID
    var name: String
    var price: Double
    var ingredients: [String]

#if DEBUG
    static let example = TrapperItem(id: UUID(), name: "Alligator Ranch Cutter Saddle", price: 107.00, ingredients: ["Perfect Alligator Skin"])
    static let example2 = TrapperItem(id: UUID(), name: "Legendary Alligator Gambler's Hat", price: 22.00, ingredients: ["Legendary Alligator Skin", "Perfect Snake Skin x2"])
#endif

}

struct FenceItem: Codable, Hashable, Identifiable {

    var id: UUID
    var name: String
    var price: Double
    var ingredients: [String]
    var effect: String

#if DEBUG
    static let example = FenceItem(id: UUID(), name: "Alligator Tooth Talisman", price: 40.00, ingredients: ["Legendary Alligator Tooth", "Vintage Civil War Handcuffs", "Gold Jointed Bracelet"], effect:"Lowers the drain speed of Dead Eye Core by 10%")
#endif

}
struct CampItem: Codable, Hashable, Identifiable {

    var id: UUID
    var name: String
    var ingredients: [String]

#if DEBUG
    static let example = CampItem(id: UUID(), name: "Alligator Skull for Arthur's Lodging", ingredients: ["Perfect Alligator Skin"])
#endif

}

func convertToPelt (peltName: String, peltList: [Pelt]) -> Pelt {
    for pelt in peltList {
        if pelt.name == peltName {
            return pelt
        }
    }
    return peltList[0]
}
