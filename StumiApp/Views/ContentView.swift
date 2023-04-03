//
//  ContentView.swift
//  Stumi App
//
//  Created by Jeremy Kwok on 8/10/22.
//

import SwiftUI


struct ContentView: View {
    
    var date = Date()
    
    //View Models
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject var contentViewModel = ContentViewModel()
    
    //var views = [TimerView(), AchievementsView(), FriendsView(), LibraryView(), SearchView(), StoreView(), ProfileView(), SettingsView()] as [Any]
    /*
     0 for TimerView
     1 for AchievementView
     2 for FriendsView
     3 for LibraryView
     4 for SearchView
     5 for StoreView
     6 for ProfileView
     7 for SettingsView
    */
    
    //Music Settings
    @AppStorage("Music") var Music = true
    @AppStorage("Sound Effects") var soundEffects = true
    
    //body
    var body: some View {
        if userViewModel.userLoggedIn {
            //AndSynced {
            /* Don't need the sync part bc then it requires us to login every time*/
            content
        } else {
            LoginView()
        }
    }
    
    //content
    var content: some View {
        
        //drag function of Hamburger Menu
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < -100 {
                    withAnimation {
                        contentViewModel.showMenu = false
                    }
                }
            }
        
        return NavigationView {
            GeometryReader { geometry in
                    
                    //Views
                    switch contentViewModel.showPage {
                        
                    case 0: //TimerView
                        TimerView()
                            .environmentObject(userViewModel)
                            .environmentObject(contentViewModel)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                        
                    case 1: //AchievementsView
                        AchievementsView()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                        
                    case 2: //FriendsView
                        FriendsView()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                        
                    case 3: //LibraryView
                        LibraryView()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                        
                    case 4: //SearchView
                        SearchView()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                        
                    case 5: //StoreView
                        StoreView()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                        
                    case 6: //ProfileView
                        ProfileView()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                        
                    case 7: //SettingsView
                        SettingsView()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                        
                    default:
                        TimerView()
                            .environmentObject(userViewModel)
                            .environmentObject(contentViewModel)
                            .frame(width: geometry.size.width, height: geometry.size.height)

                    }
                    //Hamburger Menu
                    HStack{
                        if contentViewModel.showMenu {
                            MenuView()
                            .environmentObject(contentViewModel)
                            .frame(
                                width: geometry.size.width/2,
                                alignment: .leading
                            )
                            .transition(.move(edge: .leading))
                            .gesture(drag)
                            .opacity(0.9)
                            
                            Spacer()
                        }
                    }
                
            } //end GeometryReader
            .navigationBarItems(
                    leading:
                        
                        Button(action: {
                            withAnimation {
                                contentViewModel.showMenu.toggle()
                            }
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .imageScale(.large)
                        }
                )
        }
        .onAppear{
            userViewModel.syncUser()
            print("user: \(userViewModel.userID!)")
            print("date: \(date)")
            
            if Music {
                MusicPlayer.shared.startBackgroundMusic()
            }
        }
        .banner(data: $userViewModel.bannerData, show: $userViewModel.showBanner)
    }
}

//pull function

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1:0)
                self
            }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserViewModel())
    }
}
