//
//  LibraryMenuView.swift
//  StumiApp
//
//  Created by Jeremy Kwok on 8/28/22.
//

import SwiftUI

struct LibraryMenuView: View {
    
    //Variables
      //Hamburger Button Variables
        @Binding var showLibraryHamburgerMenu : Bool
    
      //Study Menu Variables
        @Binding var showLibrary : Bool
        @Binding var showSearch : Bool
        @Binding var showStore : Bool
    
      //User Variables
        @Binding var showProfile : Bool
        @Binding var showSettings : Bool
    
    //body
    var body: some View {
        VStack(alignment: .leading) {
            
            //Library Button
            Button(action: {
                showLibraryHamburgerMenu = false;
                showSearch = false;
                showStore = false;
                showProfile = false;
                showSettings = false;
                showLibrary = true
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
                .padding(.top, 120)
            
            //Search Button
            Button(action: {
                showLibraryHamburgerMenu = false;
                showLibrary = false;
                showStore = false;
                showProfile = false;
                showSettings = false;
                showSearch = true
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
                showLibraryHamburgerMenu = false;
                showLibrary = false;
                showSearch = false;
                showProfile = false;
                showSettings = false;
                showStore = true
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
                showLibraryHamburgerMenu = false;
                showLibrary = false;
                showSearch = false;
                showStore = false;
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
                showLibraryHamburgerMenu = false;
                showLibrary = false;
                showSearch = false;
                showStore = false;
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

//struct LibraryMenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        LibraryMenuView()
//    }
//}
