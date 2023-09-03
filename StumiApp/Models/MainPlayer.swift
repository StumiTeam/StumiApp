//
//  MainPlayer.swift
//  StumiApp
//
//  Created by Jeremy Kwok on 3/14/23.
//

import Foundation
import FirebaseFirestoreSwift
import SwiftUI

class mainPlayer: Codable {
    //ALL DOC FIELDS FROM FIRESTORE SHOULD TO BE HERE
    @DocumentID var id: String? //@DocumentID to fetch the identifier from Firestore
    
    //var variableName: type = initial value
    var username: String
    var email: String
    var subjects: [String]
    var level: Int 
    var numCoins: Int
    var prestige: Int
    var totalTime: Int
    
    //Object Storage
    var unlockedBiomes: [Biome]
    //var collectedAnimals: [Animal]
    var availableAnimals: [String]
    var achievements: [Achievement]
    var availableAchievements: [String]
    var furniture: [Furniture]
    var availableFurniture: [String]
    
    var gameVersion: String
    var usernamesForSearch: [String] { [self.username.generateStringSequence()].flatMap { $0 }
    }
}
