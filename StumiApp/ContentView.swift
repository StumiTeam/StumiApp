//
//  ContentView.swift
//  Stumi App
//
//  Created by Jeremy Kwok on 8/10/22.
//

import SwiftUI


struct ContentView: View {
    
    @State var showMenu : Bool = false
//    @State var timerMode : Bool = true
//    @State var libraryMode : Bool = false
    
    //Timer Menu
    @State var showTimerView : Bool = true
    @State var showAchievementsView : Bool = false
    @State var showFriendsView : Bool = false
    
    //Library Menu
    @State var showLibraryView : Bool = false
    @State var showSearchView : Bool = false
    @State var showStoreView : Bool = false
    
    //User Menu
    @State var showProfileView : Bool = false
    @State var showSettingsView : Bool = false
    
    //Music Settings
    @AppStorage("Music") var Music = true
    @AppStorage("Sound Effects") var soundEffects = true
    
    //body
    var body: some View {
        
        //drag function of Hamburger Menu
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < -100 {
                    withAnimation {
                        self.showMenu = false
                    }
                }
            }
        
        return NavigationView {
            GeometryReader { geometry in
                ZStack {
                    
                    //Music
                    if Music {
                        ZStack{}
                        .onAppear{
                            MusicPlayer.shared.startBackgroundMusic()
                        }
                    }
                    
                    //Views
                    if showTimerView {
                        TimerView()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                    
                    if showAchievementsView {
                        AchievementsView()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                    
                    if showFriendsView {
                        FriendsView()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                    
                    if showLibraryView {
                        LibraryView()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                    
                    if showSearchView {
                        SearchView()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                    
                    if showStoreView {
                        StoreView()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                    
                    if showProfileView {
                        ProfileView()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                    
                    if showSettingsView {
                        SettingsView()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                    
                    //Hamburger Menu
                    HStack{
                        if showMenu {
                            MenuView(showHamburgerMenu: $showMenu, showTimer: $showTimerView, showAchievements: $showAchievementsView, showFriends: $showFriendsView, showLibrary: $showLibraryView, showSearch: $showSearchView, showStore: $showStoreView, showProfile: $showProfileView, showSettings: $showSettingsView)
                                .frame(width: geometry.size.width/2, alignment: .leading)
                                .transition(.move(edge: .leading))
                                .gesture(drag)
                                .opacity(0.9)
                            Spacer()
                        }
                    }

                } //end ZStack
                
            } //end GeometryReader
                .navigationBarItems(
                    leading:
                        Button(action: {
                            withAnimation {
                                self.showMenu.toggle()
                            }
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .imageScale(.large)
                        }
                )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
