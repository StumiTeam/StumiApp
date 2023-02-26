//
//  FirestoreManager.swift
//  StumiApp
//
//  Created by Jeremy Kwok on 2/5/23.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift


class FirestoreManager: ObservableObject {
    
    @Published var auth: User?
    @Published var user = Auth.auth().currentUser
    @Published var uid = Auth.auth().currentUser?.uid
    @Published var animals : [String]
    @Published var Username : String = ""
    @Published var users = [User]()

    let db = Firestore.firestore()
    
    /*
    var username : String {
        user?.username
    }
    */
    
    var email : String { (user?.email)! }
    var userIsAuthenticated: Bool { user != nil }
    var userIsAuthenticatedAndSynced: Bool { user != nil && userIsAuthenticated
}
    
    let newUserData: [String: Any] = [
        "username" : "user1",
        "numCoins" : 0,
        "level" : 1,
        "prestige" : 0
    ]
    
    init() {
        animals = []
        //fetchUser()
        //fetchAllUsers()
    }
    
    
    /*
    func addFriend(_ user: User) {
        guard userIsAuthenticated else { return }
        do {
            let _ = try db.collection("Users").document(self.uid!).setData(from: auth)
        } catch {
            print("Error adding: \(error)")
        }
    }
    */
    
    func update() {
        guard userIsAuthenticatedAndSynced else { return }
        
    }
    
    /*
    func fetchUser() {
        // Read a user doc at a specific path
        guard userIsAuthenticated else { return }
        print("Current user: " + self.uid!)
        db.collection("Users").document(self.uid!).getDocument { (document, error) in
            guard document != nil, error == nil else {
                print("error", error ?? "")
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
                    print("data", data)
                    self.Username = data["name"] as? String ?? ""
                }
            }
        }
    }
    */
    
    func fetchUser(userID: String) {
        let docRef = db.collection("Users").document(userID)
        
        docRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching User Document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            print("data: \(data)")
            print("User FETCHED LESGO")
        }
    }
    
    func fetchAllUsers() {
        db.collection("Users").getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID): \(document.data())")
                }
            }
        }
    }
    
    func createUser(userID: String) {
        let docRef = db.collection("Users").document(userID)
        
        docRef.setData(newUserData) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func updateUser(userID: String, userLevel: Int) {
        let docRef = db.collection("Users").document(userID)
        
        docRef.setData(["level": userLevel], merge: true) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated!")
            }
        }
    }
    
    /*
    //Find the User's friends in CloudFirestore
    func fetchFriends() {
        //find all documents that have User's username in Friends List
        db.collection("Users").whereField("Friends", arrayContains:)
    }
     */
    
    
    func fetchAnimals() {
        db.collection("Users").document(uid!)
    }
    
}
