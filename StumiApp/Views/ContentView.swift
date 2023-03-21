//
//  ContentView.swift
//  Stumi App
//
//  Created by Jeremy Kwok on 8/10/22.
//

import SwiftUI


struct ContentView: View {
    
    //View Models
    @EnvironmentObject var userViewModel: UserViewModel
    
    //Menu
    @State var showMenu : Bool = false
    @State var showPage : Int = 0
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
    
    //Banner Settings
    //@State public var showBanner: Bool = false
    //@State public var bannerData: BannerModifier.BannerData = BannerModifier.BannerData(title: "", detail: "", type: .Warning)
    
    //body
    var body: some View {
        if userViewModel.userLoggedIn {
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

                    //TimerView
                    if showPage == 0 {
                        TimerView()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                    
                    //AchievementsView
                    if showPage == 1 {
                        AchievementsView()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                    
                    //FriendsView
                    if showPage == 2 {
                        FriendsView()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                    
                    //LibraryView
                    if showPage == 3 {
                        LibraryView()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                    
                    //SearchView
                    if showPage == 4 {
                        SearchView()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                    
                    //StoreView
                    if showPage == 5 {
                        StoreView()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                    
                    //ProfileView
                    if showPage == 6 {
                        ProfileView()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                    
                    //SettingsView
                    if showPage == 7 {
                        SettingsView()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                    
                    //Hamburger Menu
                    HStack{
                        if showMenu {
                            
                            MenuView(
                                showHamburgerMenu: $showMenu,
                                currentPage: $showPage
                            )
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
        .onAppear{
            userViewModel.syncUser()
            print("user: \(userViewModel.userID!)")
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
