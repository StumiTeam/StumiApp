//
//  RegisterView.swift
//  StumiApp
//
//  Created by Jeremy Kwok on 2/5/23.
//

import SwiftUI
import Firebase

struct RegisterView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
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
                    NavigationLink(destination: LoginView()
                        .navigationBarBackButtonHidden(true)){
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
}


struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
            .environmentObject(UserViewModel())
    }
}
