//
//  RegisterView.swift
//  StumiApp
//
//  Created by Jeremy Kwok on 2/5/23.
//

import SwiftUI
import Firebase

struct RegisterView: View {
    
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var userIsLoggedIn = false
    @State var showBanner: Bool = false
    @State var bannerData: BannerModifier.BannerData = BannerModifier.BannerData(title: "", detail: "", type: .Error)
    
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
                        register()
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
                    NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true)){
                            Text("Already have an account? Login!")
                                .bold()
                                .foregroundColor(.white)
                        .padding(.top)
                    }
                    .offset(y:110)
                    
                }
                .frame(width: 350)
                .navigationBarHidden(true)
                .onAppear {
                    Auth.auth().addStateDidChangeListener { auth, user in
                        if user != nil {
                            userIsLoggedIn.toggle()
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            
        }
        .ignoresSafeArea()
        .banner(data: $bannerData, show: $showBanner)
    }
    
    func register() {
        
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
            
            /*
            print(self.bannerData.title)
            print(self.bannerData.detail)
            print(self.bannerData.type)
            print(self.showBanner)
            print("Passwords don't match")
            */
        } else {
            
            //Add to Firebase Authentication
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if error != nil {
                    self.bannerData.detail = error!.localizedDescription
                    print(error!.localizedDescription)
                    
                    if self.bannerData.detail == "An email address must be provided." {
                        self.bannerData.title = "Missing Email"
                    }
                    else if self.bannerData.detail == "The email address is badly formatted." {
                        self.bannerData.title = "Bad Email"
                    }
                    else if self.bannerData.detail == "The email address is already in use by another account." {
                        self.bannerData.title = "Email In Use"
                    }
                    else if self.bannerData.detail == "The password must be 6 characters long or more." {
                        self.bannerData.title = "Short Password"
                    }
                    self.bannerData.type = .Error
                    
                } else {
                    //successful register
                    self.bannerData.title = "Success!"
                    self.bannerData.detail = "You're all set, " + username + "! Please log in!"
                    self.bannerData.type = .Success
                }
                self.showBanner = true
            }
            
        }
    }
    
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
