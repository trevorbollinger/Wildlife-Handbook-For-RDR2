//
//  FavoritesView.swift
//  Hunting Handbook
//
//  Created by Trevor Bollinger on 1/2/23.
//
//
//import SwiftUI
//
//struct FavoritesView: View {
//    
//    let animals = Bundle.main.decode([Animal].self, from: "animals.json")
//    
//    var body: some View {
//        NavigationStack {
//            List {
//                ForEach(animals) { animals in
//
//                        NavigationLink(value: animals) {
//                            AnimalRow(animal: animals)
//                        
//                    }
//                    
//                }
//            }
//            .navigationDestination(for: Animal.self) { animal in
//                AnimalDetail(animal: animal)
//            }
//            .navigationTitle("Favorites")
//        }
//    }
//}
//
//
//struct FavoritesView_Previews: PreviewProvider {
//    static var previews: some View {
//        FavoritesView()
//    }
//}
