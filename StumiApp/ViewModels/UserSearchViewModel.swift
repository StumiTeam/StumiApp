//
//  UserSearchViewModel.swift
//  StumiApp
//
//  Created by Jeremy Kwok on 3/29/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserSearchViewModel: ObservableObject {
    @Published var queryResultUsers: [User] = []
}
