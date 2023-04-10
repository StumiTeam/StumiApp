//
//  FirestoreManager.swift
//  StumiApp
//
//  Created by Jeremy Kwok on 2/5/23.
//
//
// This file acts as a ViewModel, holding all the functions we use from Cloud FireStore

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI


class FirestoreManager: ObservableObject {
    
    @Published var auth: User?
    @Published var user = Auth.auth().currentUser
    @Published var uid = Auth.auth().currentUser?.uid
    
    @Published var users = [User]()
    @Published var queryResultUsers: [User] = []

    let db = Firestore.firestore()
    
    var email : String { (user?.email)! }
    var userIsAuthenticated: Bool { user != nil }
    var userIsAuthenticatedAndSynced: Bool { user != nil && userIsAuthenticated }
    
    let newUserData: [String: Any] = [
        "username" : "username",
        "email" : "email",
        "numCoins" : 0,
        "level" : 1,
        "prestige" : 0,
        "totalTime" : 0
    ]
    
    let newAnimalData: [String: Any] = [
        "animalName" : "animalName",
        "species" : "species",
        "level" : 1,
        "stage" : "elementary", //every 4 levels should be an increase in stage
        "bookRate" : 1,
        "EXP" : 0,
        "maxEXP" : 100
    ]
    
    init() {
        //animals = []
        uid = Auth.auth().currentUser?.uid
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
    
    func changeUser(userID: String) {
        
    }
    
    //pulls user data from Firestore everytime user data is updated
    func fetchUser() {
        let userDocRef = db.collection("Users").document(uid!)
        
        userDocRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching User Document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            
            //self.users = data.compactMap { queryDocumentSnapshot -> User? in
            //    return try? queryDocumentSnapshot.data(as: User.self)
            //}
            print("data: \(data)")
            print("User FETCHED LESGO")
        }
    }
    
    //search for a list of users based on keywords
    func searchForUsers(from keyword: String) {
        
        db.collection("Users").whereField("keywordsForLookup", arrayContains: keyword).getDocuments { querySnapshot, error in
            
            guard let documents = querySnapshot?.documents, error == nil else {
                print("No documents")
                return
            }
            //Convert each result to a user struct
            self.queryResultUsers = documents.compactMap{ queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: User.self)
            }
        }
    }
    
    /*
    func fetchAllUsers() {
        let userColRef = db.collection("Users")
        
        userColRef.getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID): \(document.data())")
                }
            }
        }
    }
     */
     
    
    func createUser(userID: String) {
        let userDocRef = db.collection("Users").document(userID)
        //let userAnimalDocRef = userDocRef.collection("Animals").document()
        
        //create new user doc and set data
        userDocRef.setData(newUserData) { error in
            if let error = error {
                print("Error writing user doc: \(error)")
            } else {
                print("User doc successfully written!")
            }
        }
        
        //create history subcollection where each day is a new doc
        
    }
    
    /*
    //if the field doesn't exist this function will create it
    func updateUserData(userID: String, propertyName: String, newPropertyValue: String) {
        let userDocRef = db.collection("Users").document(userID)
        
        userDocRef.updateData([propertyName: newPropertyValue]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    */
    
    func createAnimal(animalName: String, animalType: String){
        let userDocRef = db.collection("Users").document(uid!)
        let userAnimalDocRef = userDocRef.collection("Animals").document("\(animalName)")
        
        //create new animal doc and set data (maxEXP should vary for each animal)
        userAnimalDocRef.setData(newAnimalData) { error in
            if let error = error {
                print("Error writing animal doc: \(error)")
            } else {
                print("Animal doc successfully written!")
            }
        }
        
    }
    
    //like updateUserData but for user's animal
    func updateAnimalData(animalID: String, propertyName: String, newPropertyValue: String) {
        let animalDocRef = db.collection("Users").document(uid!).collection("Animals").document(animalID)
        
        animalDocRef.updateData([propertyName: newPropertyValue]) { error in
            if let error = error {
                print("Error updating \(animalID) (animal) : \(error)")
            } else {
                print("\(animalID) successfully updated")
            }
        }
    }
    
    /*
    //increments the numeric value of a certain stat in FireStore
    func incrementUserData(propertyName: String, incrementValue: Int) {
        
        //NIL FOUND HERE
        let userDocRef = db.collection("Users").document(uid!)
        
        userDocRef.updateData([propertyName: FieldValue.increment(Int64(incrementValue))]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("\(propertyName) successfully incremented by \(incrementValue)!")
            }
        }
    }
    */
    
    
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
