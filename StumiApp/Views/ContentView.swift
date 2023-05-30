//
//  ContentView.swift
//  Stumi App
//
//  Created by Jeremy Kwok on 8/10/22.
//

import SwiftUI


struct ContentView: View {
    
    //let sqliteManager = SQLiteManager.shared
    var date = Date()
    
    //View Models
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject var contentViewModel = ContentViewModel()
    
    //Music Settings
    @AppStorage("Music") var Music = true
    @AppStorage("Sound Effects") var soundEffects = true
    
    //body - The environment is passed down here
    var body: some View {
        if userViewModel.userLoggedIn {
            if userViewModel.userLoggedInAndSynced {
                content
            } else {
                TitleView()
                    //.environmentObject(sqliteManager)
                    //.environmentObject(contentViewModel)
            }
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
                            .environmentObject(userViewModel)
                            .environmentObject(contentViewModel)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                        
                        
                    /*
                    case 8: //TitleView
                        TitleView()
                            .environmentObject(userViewModel)
                            .environmentObject(contentViewModel)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    */
                        
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
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    if contentViewModel.showButton {
                        Button(action: {
                            withAnimation {
                                contentViewModel.showMenu.toggle()
                            }
                        }, label: {
                            Image(systemName: "line.horizontal.3")
                                .imageScale(.large)
                        })
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing){
                    if contentViewModel.showButton {
                        Button(action: {
                            //redirect to store page
                        }, label: {
                            ZStack{
                                Text("\(userViewModel.mainPlayer.numCoins)")
                                    .frame(width: 80, height: 30, alignment: .trailing)
                                    .foregroundColor(.white)
                                    .padding(.trailing, 10)
                                    .background(.black)
                                    .clipShape(Capsule())
                                
                                Image("StumiCoin")
                                    .resizable()
                                    .frame(width: 40, height:40)
                                    .aspectRatio(CGSize(width:1, height:1), contentMode: .fit)
                                    .padding(.trailing, 70)
                            }//end ZStack
                        })
                        .frame(width: 80, height: 40)
                        .padding(.horizontal, 10)
                    }
                }
            }//end toolbar
        }//end NavigationView
        .onAppear{
            //userViewModel.syncUser()
            print("user: \(userViewModel.id!)")
            print("date: \(date)")
            
            if Music {
                MusicPlayer.shared.startBackgroundMusic()
            }
        }
        .banner(data: $userViewModel.bannerData, show: $userViewModel.showBanner)
    }
    
}

//pull function for Hamburger Menu
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
