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
    @Published var animals : [String]
    @Published var Username : String = ""

    let db = Firestore.firestore()
    
    var uid : String? {
        user?.uid
    }
    /*
    var username : String {
        user?.username
    }
    */
    var email : String {
        (user?.email)!
    }
    var userIsAuthenticated: Bool {
        user != nil
    }
    var userIsAuthenticatedAndSynced: Bool {
        user != nil && userIsAuthenticated
    }
    
    //let docRef = db.collection("Users").document(user?.uid)
    
    init() {
        animals = []
        fetchUser()
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
    
    func fetchUser() {
        // Read a user doc at a specific path
        guard userIsAuthenticated else { return }
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
