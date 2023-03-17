//
//  SettingsView.swift
//  Stumi Test
//
//  Created by Jeremy Kwok on 8/16/22.
//

import SwiftUI
import Firebase

struct SettingsView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    @AppStorage("Music") private var Music : Bool = true
    @AppStorage("Library Music") private var libraryMusic : Bool = true
    @AppStorage("Sound Effects") private var soundEffects : Bool = true
    @Binding var mainUserLoggedIn : Bool
    
    //body
    var body: some View {
        NavigationView {
            
            VStack{
                
                //User Credentials (username, level, email, password reset, etc.)
                //NavigationLink()
                
                //Gray Space
                Spacer()
                
                //Notification Settings
                //NavigationLink()
                
                //Gray Space
                Spacer()
                
                //Music & Sound Effect Toggle Switches
                Form{
                    Section(header: Text("Sound"),
                            footer: Text("This is system settings")) {
                        
                        Toggle("Music", isOn: $Music)
                            .onChange(of: Music) { value in
                                if Music {
                                    MusicPlayer.shared.startBackgroundMusic()
                                } else {
                                    MusicPlayer.shared.stopBackgroundMusic()
                                }
                            }
                        
                        
                        
                        //Toggle("Library Music", isOn: $libraryMusic)
                        
                        Toggle("Sound Effects", isOn: $soundEffects)
                    }
                }
                
                //Gray Space
                Spacer()
                
                //Stumi Info
                //NavigationLink(AboutStumi)
                //NavigationLink(Help&Support)
                //NavigationLink(PrivacyPolicy)
                
                //Logout Button
                Button(action: {
                    userViewModel.logout()
                }){
                    Text("Logout")
                }
                
            } //End VStack
//                }
                
//                Section {
//                    //NavigationLink("Account") {
//
//                    }
                //}
            //}
        }
        //.ignoresSafeArea()
    }
    
    /*
    func logout() {
        do {
            try Auth.auth().signOut()
            mainUserLoggedIn = false;
            print("User Logged Out!")
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
     */
    
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}
