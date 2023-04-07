//
//  User.swift
//  StumiApp
//
//  Created by Jeremy Kwok on 2/10/23.
//

import Foundation
import FirebaseFirestoreSwift
import SwiftUI

//User
struct User: Identifiable, Codable {
    
    //ALL DOC FIELDS FROM FIRESTORE SHOULD TO BE HERE
    @DocumentID var id: String? //@DocumentID to fetch the identifier from Firestore
    
    //var variableName: type = initial value
    var username: String = "Username"
    var email: String = "Email@email.com"
    var subjects: [String] = ["English", "Math", "Social Studies", "Science"]
    var level: Int = 1
    var numCoins: Int = 0
    var prestige: Int = 0
    var totalTime: Int = 0
    var gameVersion: String = "v0"
    var usernamesForSearch: [String] { [self.username.generateStringSequence()].flatMap { $0 }
    }
    func getSubjects() -> [String] {
        return subjects
    }
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
