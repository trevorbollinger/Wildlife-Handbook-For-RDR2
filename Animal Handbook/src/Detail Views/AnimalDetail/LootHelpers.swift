//
//  LootHelpers.swift
//  Animal Handbook for RDR2
//
//  Created by Trevor Bollinger on 12/4/25.
//

import Foundation

func getPeltForSpecialLoot(_ loot: String, from pelts: [Pelt]) -> Pelt? {
    // Safety check for empty pelts array
    guard !pelts.isEmpty else { return nil }
    
    switch loot {
    case "Big Game Meat":
        return pelts.count > 0 ? pelts[0] : nil
    case "Exotic Bird Meat", "Mature Venison", "Game Meat", "Succulent Fish", "Prime Beef", "Tender Pork Loin":
        return pelts.count > 1 ? pelts[1] : nil
    case "Plump Bird Meat", "Crustacean Meat", "Gristly Mutton", "Flaky Fish":
        return pelts.count > 2 ? pelts[2] : nil
    case "Gritty Fish", "Gamey Bird Meat", "Stringy Meat", "Herptile Meat":
        return pelts.count > 3 ? pelts[3] : nil
    case let feather where isFeather(feather):
        return pelts.count > 4 ? pelts[4] : nil
    case "Flight Feather":
        return pelts.count > 5 ? pelts[5] : nil
    default:
        return nil
    }
}

func isFeather(_ loot: String) -> Bool {
    let feathers1 = ["Blue Jay Feather", "Booby Feather", "Cardinal Feather", "Chicken Feather",
                     "Condor Feather", "Cormorant Feather", "Crane Feather", "Crow Feather"]
    let feathers2 = ["Duck Feather", "Eagle Feather", "Egret Feather", "Goose Feather",
                     "Hawk Feather", "Heron Feather", "Loon Feather", "Oriole Feather"]
    let feathers3 = ["Owl Feather", "Parakeet Feather", "Parrot Feather", "Peccary Feather",
                     "Pelican Feather", "Pheasant Feather", "Pig Feather", "Pigeon Feather"]
    let feathers4 = ["Quail Feather", "Raven Feather", "Robin Feather", "Rooster Feather",
                     "Seagull Feather", "Songbird Feather", "Sparrow Feather", "Spoonbill Plume"]
    let feathers5 = ["Turkey Feather", "Vulture Feather", "Waxwing Feather", "Woodpecker Feather",
                     "Bat Wing"]
    let feathers = feathers1 + feathers2 + feathers3 + feathers4 + feathers5
    return feathers.contains(loot)
}

func isSpecialLoot(_ loot: String) -> Bool {
    getPeltForSpecialLoot(loot, from: []) != nil
}

