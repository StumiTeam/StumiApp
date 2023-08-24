//
//  AnimalManager.swift
//  StumiApp
//
//  Created by Jeremy Kwok on 8/9/23.
//

import Foundation

//class AnimalManager {
//    static let shared = AnimalManager()
//
//    private var allAnimals: [Animal] = []
//
//    private init() {
//        // Initialize the list of available animals here
//        // You can load data from a CSV file or any other data source
//        // For demonstration purposes, let's manually add some animals
//
//        // Male and female animals of the same species
////        let lion = Animal(species: "Lion", maleImageURL: "lion_male.png", femaleImageURL: "lion_female.png")
////        let tiger = Animal(species: "Tiger", maleImageURL: "tiger_male.png", femaleImageURL: "tiger_female.png")
//
//        // Add more animals here...
//
//        //allAnimals = [lion, tiger]
//    }
//
//    func getAvailableAnimals(for player: MainPlayer) -> [Animal] {
//        // Filter out animals that the player has already collected
//        let collectedSpecies = player.collectedAnimals.map { $0.species }
//        return allAnimals.filter { !collectedSpecies.contains($0.species) }
//    }
//}
