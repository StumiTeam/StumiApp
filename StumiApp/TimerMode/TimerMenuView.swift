//
//  MenuView.swift
//  Stumi App
//
//  Created by Jeremy Kwok on 8/10/22.
//

import SwiftUI

struct TimerMenuView: View {
    
    //Variables
      //Hamburger Button Variables
        @Binding var showTimerHamburgerMenu : Bool
    
      //Study Menu Variables
        @Binding var showTimer : Bool
        @Binding var showAchievements : Bool
        @Binding var showFriends : Bool
    
      //User Variables
        @Binding var showProfile : Bool
        @Binding var showSettings : Bool
    
    //body
    var body: some View {
        VStack(alignment: .leading) {
            
            //Timer Button
            Button(action: {
                showTimerHamburgerMenu = false;
                showAchievements = false;
                showFriends = false;
                showProfile = false;
                showSettings = false;
                showTimer = true
            }){
                HStack {
                    Image(systemName: "person")
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
                showTimerHamburgerMenu = false;
                showTimer = false;
                showFriends = false;
                showProfile = false;
                showSettings = false;
                showAchievements = true
            }){
                HStack {
                    Image(systemName: "envelope")
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
                showTimerHamburgerMenu = false;
                showTimer = false;
                showAchievements = false;
                showProfile = false;
                showSettings = false;
                showFriends = true
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
            
            //Timer Button
            Button(action: {
                showTimerHamburgerMenu = false;
                showAchievements = false;
                showFriends = false;
                showProfile = false;
                showSettings = false;
                showTimer = true
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
            
            //Achievements Button
            Button(action: {
                showTimerHamburgerMenu = false;
                showTimer = false;
                showFriends = false;
                showProfile = false;
                showSettings = false;
                showAchievements = true
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
            
            //Friends Button
            Button(action: {
                showTimerHamburgerMenu = false;
                showTimer = false;
                showAchievements = false;
                showProfile = false;
                showSettings = false;
                showFriends = true
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
                showTimerHamburgerMenu = false;
                showTimer = false;
                showAchievements = false;
                showFriends = false;
                showSettings = false;
                showProfile = true
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
                showTimerHamburgerMenu = false;
                showTimer = false;
                showAchievements = false;
                showFriends = false;
                showProfile = false;
                showSettings = true
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
