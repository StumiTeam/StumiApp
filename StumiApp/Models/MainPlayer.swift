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
    @DocumentID var userID: String? //@DocumentID to fetch the identifier from Firestore
    
    //var variableName: type = initial value
    var username: String
    var email: String
    var subjects: [String]
    var level: Int 
    var numCoins: Int
    var prestige: Int
    var totalTime: Int
    var usernamesForSearch: [String] { [self.username.generateStringSequence()].flatMap { $0 }
    }
}
