//
//  SettingsView.swift
//  Stumi Test
//
//  Created by Jeremy Kwok on 8/16/22.
//

import SwiftUI
import Firebase

struct SettingsView: View {
    
    @AppStorage("Music") private var Music : Bool = true
    @AppStorage("Library Music") private var libraryMusic : Bool = true
    @AppStorage("Sound Effects") private var soundEffects : Bool = true
    @Binding var UserLoggedIn : Bool
    
    //body
    var body: some View {
        NavigationView {
            
            VStack{
                
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
                
                Button(action: {
                    logout()
                }){
                    Text("Logout")
                }
                
            }
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
    
    func logout() {
        do {
            try Auth.auth().signOut()
            UserLoggedIn = false;
            print("User Logged Out!")
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}
