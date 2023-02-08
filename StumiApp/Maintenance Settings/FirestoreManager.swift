//
//  FirestoreManager.swift
//  StumiApp
//
//  Created by Jeremy Kwok on 2/5/23.
//

import Foundation
import Firebase

class FirestoreManager: ObservableObject {
    
    @Published var user = Auth.auth().currentUser
    @Published var uid : String
    
    init() {
        uid = ""
    }
    
    func getUserData() {
        
        // Get reference to Cloud Firestore Database
        let db = Firestore.firestore()
        
        // Read a user doc at a specific path
        if user != nil {
            
            //Get user uid and email, but exclude nil cases
            let uid = user?.uid
            let email = user?.email
            
        } else {
            //No user is signed in
        }
        
        let userDocRef = db.collection("Users").document(uid)
        
        //if there's an error, print it
        userDocRef.getDocument{ (document, error) in
            guard error == nil else {
                print("error", error ?? "")
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
                    print("data", data)
                }
            }
        }
        
    }
    
    func findUser() {
        let db = Firestore.firestore()
        //let docRef = db.collection("Users").document(username)
    }
}
