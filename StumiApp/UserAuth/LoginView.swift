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
    @State public var showBanner: Bool = false
    @State public var bannerData: BannerModifier.BannerData = BannerModifier.BannerData(title: "", detail: "", type: .Warning)
    
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
                    NavigationLink(destination: RegisterView(userRegistered: $userLoggedIn).navigationBarBackButtonHidden(true)){
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
                self.bannerData.detail = error!.localizedDescription
                print(error!.localizedDescription)
                
                if self.bannerData.detail == "The email address is badly formatted." {
                    self.bannerData.title = "Bad Email"
                }
                else if self.bannerData.detail == "There is no user record corresponding to this identifier. The user may have been deleted." {
                    self.bannerData.title = "User Not Found"
                }
                else if self.bannerData.detail == "The password is invalid or the user does not have a password." {
                    self.bannerData.title = "Invalid Password"
                    self.bannerData.detail = "Please re-enter your password."
                }
                self.bannerData.type = .Error
                
            } else {
                
                //successful login
                print("Logged In!")
                self.bannerData.title = "Success!"
                self.bannerData.detail = "Welcome back!"
                self.bannerData.type = .Success
                userLoggedIn = true
                
            }
            
            self.showBanner = true
            
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
