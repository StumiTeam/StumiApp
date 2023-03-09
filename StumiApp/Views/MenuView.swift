//
//  LibraryMenuView.swift
//  StumiApp
//
//  Created by Jeremy Kwok on 8/28/22.
//

import SwiftUI

struct MenuView: View {
    
    //Variables
    
    @Binding var showHamburgerMenu : Bool
    @Binding var currentPage : Int
     
    //body
    var body: some View {
        VStack(alignment: .leading) {
            
            //Timer Button
            Button(action: {
                showHamburgerMenu = false;
                currentPage = 0
            }){
                HStack {
                    Image(systemName: "gear")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                    Text("Timer")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
            }
                .padding(.top, 120)
            
            //Achievements Button
            Button(action: {
                showHamburgerMenu = false;
                currentPage = 1
            }){
                HStack {
                    Image(systemName: "gear")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                    Text("Achievements")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
            }
                .padding(.top, 30)
            
            //Friends Button
            Button(action: {
                showHamburgerMenu = false;
                currentPage = 2
            }){
                HStack {
                    Image(systemName: "gear")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                    Text("Friends")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
            }
                .padding(.top, 30)
            
            //Library Button
            Button(action: {
                showHamburgerMenu = false;
                currentPage = 3
            }){
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                    Text("Library")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
            }
                .padding(.top, 30)
            
            //Search Button
            Button(action: {
                showHamburgerMenu = false;
                currentPage = 4
            }){
                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                    Text("Search")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
            }
                .padding(.top, 30)
            
            //Store Button
            Button(action: {
                showHamburgerMenu = false;
                currentPage = 5
            }){
                HStack {
                    Image(systemName: "gear")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                    Text("Store")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
            }
                .padding(.top, 30)
            
            Spacer()
            
            //Profile Button
            Button(action: {
                showHamburgerMenu = false;
                currentPage = 6
            }){
                HStack {
                    Image(systemName: "gear")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                    Text("Profile")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
            }
                .padding(.bottom, 30)
            
            
            //Settings Button
            Button(action: {
                showHamburgerMenu = false;
                currentPage = 7
            }){
                HStack {
                    Image(systemName: "gear")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                    Text("Settings")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
            }
                .padding(.bottom, 30)
            
        }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(red: 20/255, green: 20/255, blue: 20/255))
            .edgesIgnoringSafeArea(.all)
    }
}

//struct MenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        MenuView()
//    }
//}
