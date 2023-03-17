//
//  RegisterView.swift
//  StumiApp
//
//  Created by Jeremy Kwok on 2/5/23.
//

import SwiftUI
import Firebase

struct RegisterView: View {
    
    @EnvironmentObject var firestoreManager: FirestoreManager
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Binding var mainUserRegistered: Bool
    @Binding var showBanner: Bool
    @Binding var bannerData: BannerModifier.BannerData
    //@ObservedObject var viewModel = FirestoreManager()
    
    var body: some View {
        NavigationView {
            
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    
                    Text("Register")
                        .foregroundColor(.white)
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .offset(x: -100, y:-100)
                    
                    //Username
                    
                    Group {
                        
                        TextField("Username", text: $username)
                            .foregroundColor(.white)
                            .textFieldStyle(.plain)
                            .placeholder(when: username.isEmpty) {
                                Text("Username")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                        
                        Rectangle()
                            .frame(width: 350, height: 1)
                            .foregroundColor(.white)
                    }
                    
                    //Email
                    Group {
                        
                        TextField("Email", text: $email)
                            .foregroundColor(.white)
                            .textFieldStyle(.plain)
                            .placeholder(when: email.isEmpty) {
                                Text("Email")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                        
                        Rectangle()
                            .frame(width: 350, height: 1)
                            .foregroundColor(.white)
                        
                    }
                    
                    //Password
                    Group {
                        
                        SecureField("Password", text: $password)
                            .foregroundColor(.white)
                            .textFieldStyle(.plain)
                            .placeholder(when: password.isEmpty) {
                                Text("Password")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                        
                        Rectangle()
                            .frame(width: 350, height: 1)
                            .foregroundColor(.white)
                        
                    }

                    //Confirm Password
                    Group {
                        
                        SecureField("Confirm Password", text: $confirmPassword)
                            .foregroundColor(.white)
                            .textFieldStyle(.plain)
                            .placeholder(when: confirmPassword.isEmpty) {
                                Text("Confirm Password")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                        
                        Rectangle()
                            .frame(width: 350, height: 1)
                            .foregroundColor(.white)
                        
                    }
                    
                    //Register Button
                    Button {
                        userViewModel.register(
                            username: username,
                            email: email,
                            password: password,
                            confirmPassword: confirmPassword
                        )
                        //redirect to loginView after clicking SignUp buttonj
                    } label: {
                        Text("Sign up")
                            .bold()
                            .frame(width: 200, height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(.linearGradient(colors: [.pink, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                            )
                            .foregroundColor(.white)
                    }
                    .padding(.top)
                    .offset(y: 100)
                    
                    //Redirect to Login Button
                    NavigationLink(destination: LoginView(
                        mainUserLoggedIn: $mainUserRegistered,
                        showBanner: $showBanner,
                        bannerData: $bannerData
                    ).navigationBarBackButtonHidden(true)){
                            Text("Already have an account? Login!")
                                .bold()
                                .foregroundColor(.white)
                        .padding(.top)
                    }
                    .offset(y:110)
                    
                }
                .frame(width: 350)
                .navigationBarHidden(true)
            }
            
        }
        .ignoresSafeArea()
        .banner(data: $userViewModel.bannerData, show: $userViewModel.showBanner)
    }
    
    /*
    func register() {
        
        //if username is already taken -> ask user to use another username
        if username == "" {
            bannerData.title = "No Username"
            bannerData.detail = "Please enter your username"
            showBanner = true
        }
        
        //if password doesn't match confirmPassword
        else if password != confirmPassword {
            bannerData.title = "Password Mismatch"
            bannerData.detail = "Your passwords don't match!"
            showBanner = true

        } else {
            
            //Add to Firebase Authentication
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if error != nil {
                    bannerData.detail = error!.localizedDescription
                    print(error!.localizedDescription)
                    
                    //find error and show corresponding banner
                    switch bannerData.detail {
                    
                    case "An email address must be provided.":
                        bannerData.title = "Missing Email"
                        
                    case "The email address is badly formatted.":
                        bannerData.title = "Bad Email"
                        
                    case "The email address is already in use by another account.":
                        bannerData.title = "Email in Use"
                        
                    case "The password must be 6 characters long or more.":
                        bannerData.title = "Short Password"
                    
                    default:
                        bannerData.title = "Error"
                    }
                    
                    bannerData.type = .Warning
                    
                } else {
                    //successful register
                    
                    print("User Registered!")
                    
                    //create new firebase document in "Users" Collection
                    guard let userID = Auth.auth().currentUser?.uid else { return }
                    
                    //create user
                    firestoreManager.createUser(userID: userID)
                    
                    //update username
                    firestoreManager.updateUserData(
                        userID: userID,
                        propertyName: "username",
                        newPropertyValue: username
                    )
                    
                    //update email
                    firestoreManager.updateUserData(
                        userID: userID,
                        propertyName: "email",
                        newPropertyValue: email
                    )
                    
                    //show success banner
                    bannerData.title = "Success!"
                    bannerData.detail = "You're all set, \(username)! Please log in!"
                    bannerData.type = .Success
                }
                showBanner = true
            }
            
        }
    }
    */
    
}

/*
struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
*/
