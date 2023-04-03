//
//  LibraryMenuView.swift
//  StumiApp
//
//  Created by Jeremy Kwok on 8/28/22.
//

import SwiftUI

struct MenuView: View {
    
    //ViewModels
    @EnvironmentObject var contentViewModel: ContentViewModel
     
    //body
    var body: some View {
        VStack(alignment: .leading) {
            
            //Timer Button
            Button(action: {
                contentViewModel.showMenu = false;
                contentViewModel.showPage = 0
                print("Now changing to page: \(contentViewModel.showPage)")
            }){
                HStack {
                    Image(systemName: "gear")
                    Text("Timer")
                }
            }
            .modifier(pageChoiceModifier())
            .padding(.top, 120)
            
            //Achievements Button
            Button(action: {
                contentViewModel.showMenu = false;
                contentViewModel.showPage = 1
                print("Now changing to page: \(contentViewModel.showPage)")
            }){
                HStack {
                    Image(systemName: "gear")
                    Text("Achievements")
                }
            }
            .modifier(pageChoiceModifier())
            .padding(.top, 30)
            
            //Friends Button
            Button(action: {
                contentViewModel.showMenu = false;
                contentViewModel.showPage = 2
                print("Now changing to page: \(contentViewModel.showPage)")
            }){
                HStack {
                    Image(systemName: "gear")
                    Text("Friends")
                }
            }
            .modifier(pageChoiceModifier())
            .padding(.top, 30)
            
            //Library Button
            Button(action: {
                contentViewModel.showMenu = false;
                contentViewModel.showPage = 3
                print("Now changing to page: \(contentViewModel.showPage)")
            }){
                HStack {
                    Image(systemName: "person")
                    Text("Library")
                }
            }
            .modifier(pageChoiceModifier())
            .padding(.top, 30)
            
            //Search Button
            Button(action: {
                contentViewModel.showMenu = false;
                contentViewModel.showPage = 4
                print("Now changing to page: \(contentViewModel.showPage)")
            }){
                HStack {
                    Image(systemName: "envelope")
                    Text("Search")
                }
            }
            .modifier(pageChoiceModifier())
            .padding(.top, 30)
            
            //Store Button
            Button(action: {
                contentViewModel.showMenu = false;
                contentViewModel.showPage = 5
                print("Now changing to page: \(contentViewModel.showPage)")
            }){
                HStack {
                    Image(systemName: "gear")
                    Text("Store")
                }
            }
            .modifier(pageChoiceModifier())
            .padding(.top, 30)
            
            Spacer()
            
            //Profile Button
            Button(action: {
                contentViewModel.showMenu = false;
                contentViewModel.showPage = 6
                print("Now changing to page: \(contentViewModel.showPage)")
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
            .modifier(pageChoiceModifier())
            .padding(.bottom, 30)
            
            
            //Settings Button
            Button(action: {
                contentViewModel.showMenu = false;
                contentViewModel.showPage = 7
                print("Now changing to page: \(contentViewModel.showPage)")
            }){
                HStack {
                    Image(systemName: "gear")
                    Text("Settings")
                }
            }
            .modifier(pageChoiceModifier())
            .padding(.bottom, 30)
            
        }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(red: 20/255, green: 20/255, blue: 20/255))
            .edgesIgnoringSafeArea(.all)
    }
}

struct pageChoiceModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.gray)
            .imageScale(.large)
            .font(.headline)
    }
}


//struct MenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        MenuView()
//    }
//}
