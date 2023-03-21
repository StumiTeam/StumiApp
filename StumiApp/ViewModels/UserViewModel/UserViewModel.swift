//
//  LoginViewModel.swift
//  StumiApp
//
//  Created by Jeremy Kwok on 3/16/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserViewModel: ObservableObject {

    @Published var user: User?
    var mainPlayer: User = User(username: "Username", email: "email", subjects: [], numCoins: 0, prestige: 0, totalTime: 0)
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    var userID: String? { auth.currentUser?.uid }
    var userLoggedIn: Bool { auth.currentUser != nil } //ensures user is logged in
    var userLoggedInAndSynced: Bool { user != nil && userLoggedIn }
    
    //For banners
    @Published var showBanner: Bool = false
    @Published var bannerData = BannerModifier.BannerData(title: "", detail: "", type: .Warning)
    
    func login(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            if error != nil {
                self?.bannerData.detail = error!.localizedDescription
                print(error!.localizedDescription)
                
                if self?.bannerData.detail == "The email address is badly formatted." {
                    self?.bannerData.title = "Bad Email"
                }
                else if self?.bannerData.detail == "There is no user record corresponding to this identifier. The user may have been deleted." {
                    self?.bannerData.title = "User Not Found"
                }
                else if self?.bannerData.detail == "The password is invalid or the user does not have a password." {
                    self?.bannerData.title = "Invalid Password"
                    self?.bannerData.detail = "Please re-enter your password."
                }
                else if self?.bannerData.detail == "Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later." {
                    self?.bannerData.title = "Account Temporarily Locked"
                }
                self?.bannerData.type = .Error
                
            } else {
                
                //successful login
                
                print("Logged In!")
                
                //fetch user
                DispatchQueue.main.async {
                    self?.syncUser()
                }
                
                self?.bannerData.title = "Success!"
                self?.bannerData.detail = "Welcome back!"
                self?.bannerData.type = .Success
                
                //switch Firestore user document (something here is causing Stumi to pull increasingly more times of the same data). New instances of class?
                
                //sync
                self?.syncUser()
                
            }
            self?.showBanner = true
        }
    } //end login
    
    
    func register(username: String, email: String, password: String, confirmPassword: String) {
        
        //if username is already taken -> ask user to use another username
        if username == "" {
            self.bannerData.title = "No Username"
            self.bannerData.detail = "Please enter your username"
            self.showBanner = true
        }
        
        //if password doesn't match confirmPassword
        else if password != confirmPassword {
            self.bannerData.title = "Password Mismatch"
            self.bannerData.detail = "Your passwords don't match!"
            self.showBanner = true

        } else {
            
            //Add to Firebase Authentication
            auth.createUser(withEmail: email, password: password) { [weak self] result, error in
                if error != nil {
                    self?.bannerData.detail = error!.localizedDescription
                    print(error!.localizedDescription)
                    
                    //find error and show corresponding banner
                    switch self?.bannerData.detail {
                    
                    case "An email address must be provided.":
                        self?.bannerData.title = "Missing Email"
                        
                    case "The email address is badly formatted.":
                        self?.bannerData.title = "Bad Email"
                        
                    case "The email address is already in use by another account.":
                        self?.bannerData.title = "Email in Use"
                        
                    case "The password must be 6 characters long or more.":
                        self?.bannerData.title = "Short Password"
                    
                    default:
                        self?.bannerData.title = "Error"
                    }
                    
                    self?.bannerData.type = .Warning
                    
                } else {
                    guard result != nil, error == nil else { return }
                    //successful register
                    
                    print("User Registered!")
                    
                    //create new firebase document in "Users" Collection
                    //guard let userID = Auth.auth().currentUser?.uid else { return }
                    
                    //create user
                    DispatchQueue.main.async {
                        self?.createUser(username: username, email: email)
                        self?.syncUser()
                    }
                    /*
                    //update username
                    updateUserData(
                        userID: userID,
                        propertyName: "username",
                        newPropertyValue: username
                    )
                    
                    //update email
                    updateUserData(
                        userID: userID,
                        propertyName: "email",
                        newPropertyValue: email
                    )
                    */
                    
                    //show success banner
                    self?.bannerData.title = "Success!"
                    self?.bannerData.detail = "You're all set, \(username)! Please log in!"
                    self?.bannerData.type = .Success
                }
                self?.showBanner = true
            }
            
        }
    } //end register
    
    func logout() {
        do {
            try auth.signOut()
            self.user = nil
            //mainUserLoggedIn = false;
            print("User Logged Out!")
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    //User Data (Cloud Firestore) Functions
    
    //sync user data
    func syncUser() {
        guard userLoggedIn else { return }
        let userDocRef = db.collection("Users").document(self.userID!)
        
        userDocRef.addSnapshotListener { (documentSnapshot, error) in
            guard let document = documentSnapshot else {
                print("Error fetching User Document: \(error!)")
                return
            }
            /*
            guard let dataa = document.data() else {
                print("Document data was empty.")
                return
            }
            */
            
            //non-optionals like DocumentSnapshot never equal nil
            //print(document==nil) //document is not nil
            //guard document != nil, error == nil else { return }
            do {
                print("trying to sync user")
                try print(document.data(as:User.self))
                try self.user = document.data(as: User.self) //no need to use document! bc DocumentSnapshot is non-optional (i.e. it can't return nil)
                print("userSynced!")
                var mainPlayer = self.user!
            } catch { //in case call throws
                print("Sync error: \(error)")
            }
            //print("user: \(self.user)")
            //print("data: \(dataa)")
            print("User FETCHED LESGO")
        }
    }
    
    //Update user data
    func updateUserData(propertyName: String, newPropertyValue: String) {
        guard userLoggedInAndSynced else { return }
        let userDocRef = db.collection("Users").document(self.userID!)
        
        do {
            try userDocRef.setData(from: user)
            userDocRef.updateData([propertyName: newPropertyValue])
            print("Document successfully updated: Property \(propertyName) value updated to \(newPropertyValue)!")
        } catch {
            print("Error updating usernamesForSearch: \(error)")
        }
    }
    
    //Increment a user's numerical data
    func incrementUserData(propertyName: String, incrementValue: Int) {
        guard userLoggedInAndSynced else { return }
        
        let userDocRef = db.collection("Users").document(self.userID!)
        
        userDocRef.updateData([propertyName: FieldValue.increment(Int64(incrementValue))]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("\(propertyName) successfully incremented by \(incrementValue)!")
            }
        }
    }
    
    //Create user
    func createUser(username: String, email: String) {
        let newUserData: [String: Any] = [
            "username" : username,
            "email" : email,
            "subjects" : [],
            "numCoins" : 0,
            "level" : 1,
            "prestige" : 0,
            "totalTime" : 0,
            "usernamesForSearch" : []
        ]
        
        let userDocRef = db.collection("Users").document(self.userID!)
        //let userAnimalDocRef = userDocRef.collection("Animals").document()
        
        //create new user doc and set data
        userDocRef.setData(newUserData) { error in
            if let error = error {
                print("Error writing user doc: \(error)")
            } else {
                print("User doc successfully written!")
            }
        }
        
        
    }
    
}
