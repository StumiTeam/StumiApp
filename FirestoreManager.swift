//
//  FirestoreManager.swift
//  StumiApp
//
//  Created by Jeremy Kwok on 2/5/23.
//

import Firebase

class FirestoreManager: ObservableObject {
    @Published var user: String = ""
    
    func findUser() {
        let db = Firestore.firestore()
        //let docRef = db.collection("Users").document(username)
    }
}
