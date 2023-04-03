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
    @Published var user : User?
    @Published var mainPlayer : User = User()
    
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
                    
                    //create new user document in "Users" Collection
                    DispatchQueue.main.async {
                        self?.createUser(User(userID: (self?.userID)!, username: username, email: email))
                        self?.syncUser()
                    }
                    
                    //show success banner
                    self?.bannerData.title = "Success!"
                    self?.bannerData.detail = "Welcome, \(username)!"
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
    } //end logout
    
    //User Data (Cloud Firestore) Functions
    
    //sync user data
    func syncUser() {
        guard userLoggedIn else { return }
        let userDocRef = db.collection("Users").document(self.userID!)
        
        userDocRef.getDocument { [self] (document, error) in
            guard document != nil, error == nil else { return }
            do {
                try self.user = document!.data(as: User.self)
                //print(self.user!)
                try mainPlayer = document!.data(as: User.self)
                print(mainPlayer)
                
            } catch {
                print("Sync error: \(error)")
            }
        }
        /*
        //everytime the document changes we pull from Firestore again
        userDocRef.addSnapshotListener { (documentSnapshot, error) in
            guard let document = documentSnapshot else {
                print("Error fetching User Document: \(error!)")
                return
            }
            
            //non-optionals like DocumentSnapshot never equal nil
            //print(document==nil) //document is not nil
            //guard document != nil, error == nil else { return }
            do {
                print("trying to sync user")
                try print(document.data(as:User.self))
                try self.user = document.data(as: User.self) //no need to use document! bc DocumentSnapshot is non-optional (i.e. it can't return nil)
                print("userSynced!")
                var mainPlayer = self.user!
                print(mainPlayer.email)
            } catch { //in case call throws
                print("Sync error: \(error)")
            }
            //print("user: \(self.user)")
            //print("data: \(dataa)")
            print("User FETCHED LESGO")
        }
        */
    }
    
    //Update user data (Create document if it doesn't exist)
    func updateUserData(propertyName: String, newPropertyValue: String) {
        guard userLoggedInAndSynced else { return }
     
        let userDocRef = db.collection("Users").document(self.userID!)
        
        do {
            try userDocRef.setData(from: user)
            userDocRef.updateData([propertyName: newPropertyValue])
            print("Successfully updated \(propertyName) to \(newPropertyValue)!")
        } catch {
            print("Error updating \(propertyName): \(error)")
        }
    }
    
    //Increment a user's numerical data
    func incrementUserData(propertyName: String, incrementValue: Int) {
        guard userLoggedInAndSynced else { return }
        let userDocRef = db.collection("Users").document(self.userID!)
        //print(incrementValue)
        
        userDocRef.updateData([propertyName: FieldValue.increment(Int64(incrementValue))]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("\(propertyName) successfully incremented by \(incrementValue)!")
            }
        }
    }
    
    //Record user history
    func updateStudyHistory(dateTime: String, subject: String, timeStudied: Int) {
        guard userLoggedInAndSynced else { return }
        
        let components = dateTime.components(separatedBy: ", ")
        let date = components[0]
        print(date)
        let timeStart = components[1]
        
        let userDocRef = db.collection("Users").document(self.userID!)
        
        //Get into today's study doc
        let userStudyHistoryRef = userDocRef.collection("Study History").document(date)
        
        userStudyHistoryRef.setData([ timeStart : [ subject, timeStudied ] as [Any] ], merge: true) { error in
            if let error = error {
                print("Error recording Studying Session: \(error)")
            } else {
                print("New Study Session successfully recorded")
            }
        }
    }
    
    //Create user
    private func createUser(_ user: User) {
        guard userLoggedIn else { return }
        
        let userDocRef = db.collection("Users").document(self.userID!)
        //let userAnimalDocRef = userDocRef.collection("Animals").document()
        
        //create new user doc and set data
        do {
            try userDocRef.setData(from: user) //takes username, email, and password
            userDocRef.updateData(["usernamesForSearch": user.usernamesForSearch])
            print("User Doc successfully written!")
        } catch {
            print("Error creating document: \(error)")
        }
    }
    
}
