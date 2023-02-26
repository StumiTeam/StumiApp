//
//  LoginView.swift
//  StumiApp
//
//  Created by Jeremy Kwok on 2/4/23.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @Binding var userLoggedIn : Bool
    @Binding public var showBanner: Bool
    @Binding public var bannerData: BannerModifier.BannerData
    @ObservedObject private var viewModel = FirestoreManager()
    
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
                        login()
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
                        userRegistered: $userLoggedIn,
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
        .banner(data: $bannerData, show: $showBanner)
    }

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
                print("Logged In!")
                bannerData.title = "Success!"
                bannerData.detail = "Welcome back!"
                bannerData.type = .Success
                userLoggedIn = true
                
                //read document
                //guard let userID = Auth.auth().currentUser?.uid else { return }
                //self.viewModel.createUser(userID: userID)
            }
            
            showBanner = true
            
        }
    }

}


/*
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
*/
