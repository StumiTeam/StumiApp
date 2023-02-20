//
//  User.swift
//  StumiApp
//
//  Created by Jeremy Kwok on 2/10/23.
//

import Foundation

//Firestore map for animals
struct Animals: Codable {
    //animalName
    //animalLevel
    //animalDescription
    //animalEXP
}

/*
//Map for each Friend
struct Friends: Codable {
    var username: String
    var documentID: 
}
*/

struct User: Codable {
    var uuid: String
    var username: String
    var animals: Animals?
    //var friendslist: Friends?
    var usernameForSearch: [String] { self.username.generateStringSequence() }
}

extension String {
    func generateStringSequence() -> [String] {
        //"Jeremy" -> ['J', 'Je', 'Jer', 'Jere', 'Jerem', 'Jeremy']
        guard self.count > 0 else { return[] }
        var sequences: [String] = []
        for i in 1...self.count {
            sequences.append(String(self.prefix(i)))
        }
        return sequences
    }
}
