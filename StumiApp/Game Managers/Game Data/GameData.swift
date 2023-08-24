//
//  GameData.swift
//  StumiApp
//
//  Created by Jeremy Kwok on 8/11/23.
//

import Foundation

class GameData {
    static let shared = GameData()
    
    var animals: [Animal] = []
    var achievements: [Achievement] = []
    var furniture: [Furniture] = []
    
    private init() {}
}
