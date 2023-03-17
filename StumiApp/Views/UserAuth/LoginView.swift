//
//  LoginView.swift
//  StumiApp
//
//  Created by Jeremy Kwok on 2/4/23.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    @EnvironmentObject var firestoreManager: FirestoreManager
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var email = ""
    @State private var password = ""
    @Binding var mainUserLoggedIn : Bool
    @Binding public var showBanner: Bool
    @Binding public var bannerData: BannerModifier.BannerData
    //@ObservedObject var viewModel = FirestoreManager() //new instance of FirestoreManager()
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color.black
                
                VStack(spacing: 20) {
                    Text("Login")
                        .foregroundColor(.white)
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .offset(x: -120, y:-100)
                    
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
                    
                    //Login Button
                    Button {
                        userViewModel.login(email: email, password: password)
                    } label: {
                        Text("Sign in")
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
                    
                    //Redirect to Register Button
                    NavigationLink(destination: RegisterView(
                        mainUserRegistered: $mainUserLoggedIn,
                        showBanner: $showBanner,
                        bannerData: $bannerData
                    ).navigationBarBackButtonHidden(true)){
                            Text("First time user? Register!")
                                .bold()
                                .foregroundColor(.white)
                        .padding(.top)
                    }
                    .offset(y:110)
                }
                .frame(width: 350)
                .navigationBarHidden(true)
            }
            .ignoresSafeArea()
        }
        .banner(
            data: $userViewModel.bannerData,
            show: $userViewModel.showBanner
        )
    }

    /*
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                bannerData.detail = error!.localizedDescription
                print(error!.localizedDescription)
                
                if bannerData.detail == "The email address is badly formatted." {
                    bannerData.title = "Bad Email"
                }
                else if bannerData.detail == "There is no user record corresponding to this identifier. The user may have been deleted." {
                    bannerData.title = "User Not Found"
                }
                else if bannerData.detail == "The password is invalid or the user does not have a password." {
                    bannerData.title = "Invalid Password"
                    bannerData.detail = "Please re-enter your password."
                }
                bannerData.type = .Error
                
            } else {
                
                //successful login
                mainUserLoggedIn = true
                
                print("Logged In!")
                bannerData.title = "Success!"
                bannerData.detail = "Welcome back!"
                bannerData.type = .Success
                
                //switch Firestore user document (something here is causing Stumi to pull increasingly more times of the same data). New instances of class?
                //everytime the user signs in it creates a new instance of the Firestore class
                firestoreManager.user = Auth.auth().currentUser
                firestoreManager.uid = Auth.auth().currentUser?.uid
                
            }
            showBanner = true
        }
    }
     */
}


/*
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
*/
