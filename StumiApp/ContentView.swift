//ContentView.swift
//Created by BLCKBIRDS on 26.10.19.
//Visit www.BLCKBIRDS.com for more.
import SwiftUI

////Variables
//struct Variables {
//    static var showOne = false
//    static var showTimer = false
//    static var showAchievements = false
//}

struct ContentView: View {
    
    @State var showMenu : Bool = false
    
    //Timer Menu
    @State var showTimerView : Bool = true
    @State var showAchievementsView : Bool = false
    @State var showFriendsView : Bool = false
    
    //Game Menu
    
    //User Modes
    @State var showProfileView : Bool = false
    @State var showSettingsView : Bool = false
//    @Binding var showAchievementsView : Bool
//    @Binding var showFriendsView : Bool
//    @Binding var showProfileView : Bool
    
    var body: some View {
        
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
                    
                    HStack{
                        if self.showMenu {
                            MenuView(showTimerHamburgerMenu: $showMenu, showTimer: $showTimerView, showAchievements: $showAchievementsView, showFriends: $showFriendsView, showProfile: $showProfileView, showSettings: $showSettingsView)
                                .frame(width: geometry.size.width/2, alignment: .leading)
                                .transition(.move(edge: .leading))
                                .gesture(drag)
                            Spacer()
                        }
                    }
                    
                    if self.showTimerView {
                        TimerView()
                            .frame(width: geometry.size.width, height:geometry.size.height)
                    }
                    
                    if self.showAchievementsView {
                        AchievementsView()
                            .frame(width: geometry.size.width, height:geometry.size.height)
                    }
                    
                    if self.showFriendsView {
                        FriendsView()
                            .frame(width: geometry.size.width, height:geometry.size.height)
                    }
                    
                    if self.showProfileView {
                        ProfileView()
                            .frame(width: geometry.size.width, height:geometry.size.height)
                    }

                    if self.showSettingsView {
                        SettingsView()
                            .frame(width: geometry.size.width, height:geometry.size.height)
                    }

                    
                }
                

            }
                //.navigationBarTitle("Side Menu", displayMode: .inline)
                .navigationBarItems(leading: (
                    Button(action: {
                        withAnimation {
                            self.showMenu.toggle()
                        }
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .imageScale(.large)
                    }
                ))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
