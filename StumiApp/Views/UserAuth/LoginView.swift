//
//  LoginView.swift
//  StumiApp
//
//  Created by Jeremy Kwok on 2/4/23.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    //@EnvironmentObject var firestoreManager: FirestoreManager
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var email = ""
    @State private var password = ""
    
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
                    NavigationLink(destination: RegisterView().navigationBarBackButtonHidden(true)){
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
}


/*
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
*/
