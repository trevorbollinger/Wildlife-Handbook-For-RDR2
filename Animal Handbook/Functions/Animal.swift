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
#if DEBUG
    static let example1 = Animal(id: UUID(), name: "Alligator", description: "Alligators are large reptiles found in the swamp regions. They are known for their powerful bite and tough hide.", location: ["Bayou Nwa", "Bluewater Marsh"], loot: ["Alligator Skin", "Big Game Meat"], tips: "Use a rifle for a clean kill and aim for the head to get a perfect pelt.", trivia: "Alligators are native to the southeastern United States.", danger: "4")
    
    static let example2 = Animal(id: UUID(), name: "Cougar", description: "Cougars, also known as mountain lions, are solitary and elusive predators that are highly dangerous.", location: ["New Austin", "West Elizabeth", "New Hanover"], loot: ["Cougar Fang", "Big Game Meat"], tips: "Always keep your Dead Eye filled and use a Bow with Poison Arrows for a perfect pelt.", trivia: "Cougars can be albino and are featured in several in-game missions.", danger: "5")
    
    static let example3 = Animal(id: UUID(), name: "Deer", description: "Deer are common herbivores found throughout the forests and plains.", location: ["Everywhere"], loot: ["Deer Pelt", "Venison"], tips: "Use a bow with standard arrows for a clean kill.", trivia: "Deer are the most common animal in the game.", danger: "1")
    
    static let example4 = Animal(id: UUID(), name: "Wolf", description: "Wolves are pack animals that can be very aggressive when threatened.", location: ["Ambarino", "West Elizabeth"], loot: ["Wolf Pelt", "Big Game Meat"], tips: "Take out the pack leader to scatter the rest.", trivia: "Wolves can be found howling at night and during the day in forests.", danger: "3")
    
    static let example5 = Animal(id: UUID(), name: "Bison", description: "Bison are large herbivores that roam the plains and are known for their massive size and strength.", location: ["The Heartlands", "Great Plains"], loot: ["Bison Pelt", "Prime Beef"], tips: "Use a high-powered rifle to take them down quickly.", trivia: "Bison were nearly hunted to extinction in the late 1800s.", danger: "2")
    
    static let exampleList = [example1, example2, example3, example4, example5]
#endif

    
}
