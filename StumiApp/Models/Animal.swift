//
//  Animal.swift
//  StumiApp
//
//  Created by Jeremy Kwok on 3/14/23.
//

/*
 import Foundation
 
 struct Animal: Identifiable, Codable {
 
 //Descriptive Properties
 var id: Int
 var speciesName: String
 var displayName: String?
 //If the user has customized the name, it will display both the custom name and the species. If the user hasn't customized the name, it will display just the species name
 
 var gender: Gender
 var biome: String
 var description: String
 
 
 //Growth Properties
 var defBookRate: Int {
 switch biome {
 case city:
 return 50
 case biome2:
 return 60
 case biome3:
 return 80
 default:
 return 0
 }
 }
 
 var defMaxExp: Int {
 switch biome {
 case city:
 return 500
 case biome2:
 return 600
 case biome3:
 return 800
 default:
 return 0
 }
 }
 
 var maxExpInc: Int {
 switch biome {
 case city:
 return 100
 case biome2:
 return 120
 case biome3:
 return 150
 default:
 return 0
 }
 }
 var level: Int = 1 //Initial Level
 var currentExp: Int = 0 //Initial exp
 var expToNextLevel: Int {
 return defMaxExp + (level - 1) * maxExpInc
 }//Total exp needed to level up
 
 var stage: Int = 1 //Initial Stage
 
 //Image Properties
 var stageImages: [String] //Array of image URLs for each stage
 var imageURL: String {
 let stageIndex = min(stage, stageImages.count - 1)
 return stageImages[stageIndex]
 }
 
 init(id: Int, speciesName: String, gender: Gender, biome: String, description: String, stageImages: [String]) {
 self.id = id
 self.speciesName = speciesName
 self.gender = gender
 self.biome = biome
 self.description = description
 self.stageImages = stageImages
 }
 
 mutating func gainEXPandLevelUp(_ experience: Int) {
 /*
  EXP Gains
  Level    ExpToNextLevel
  0        100
  1        200
  2        300
  3        400
  4        600
  5        800
  6        1000
  7        1200
  8        1500
  9        1800
  10       2100
  11       2400
  12       2800
  13       3200
  14       3600
  15       4000
  16       X
  */
 
 if level < 16 {
 currentExp += experience
 if currentExp >= expToNextLevel {
 currentExp -= expToNextLevel
 level += 1
 
 if level % 4 == 0 {
 stage += 1
 }
 
 switch biome {
 case city:
 switch stage {
 case 1:
 expToNextLevel += 100
 case 2:
 expToNextLevel += 200
 case 3:
 expToNextLevel += 300
 case 4:
 expToNextLevel += 400
 default:
 expToNextLevel += 100
 }
 case biome2:
 switch stage {
 case 1:
 expToNextLevel += 150
 case 2:
 expToNextLevel += 250
 case 3:
 expToNextLevel += 350
 case 4:
 expToNextLevel += 450
 default:
 expToNextLevel += 150
 }
 case biome3:
 switch stage {
 case 1:
 expToNextLevel += 200
 case 2:
 expToNextLevel += 300
 case 3:
 expToNextLevel += 400
 case 4:
 expToNextLevel += 500
 default:
 expToNextLevel += 200
 }
 default:
 switch stage {
 case 1:
 expToNextLevel += 100
 case 2:
 expToNextLevel += 200
 case 3:
 expToNextLevel += 300
 case 4:
 expToNextLevel += 400
 default:
 expToNextLevel += 100
 }
 }
 }
 } else {
 currentExp = 0;
 }
 }
 
 //Initialization
 //    init(species: String, level: Int, gender: Gender, s1imgURL: String, s2imgURL: String, s3imgURL: String, s4imgURL: String)
 }
 
 enum Gender: String, Codable {
 case male
 case female
 }
 */
