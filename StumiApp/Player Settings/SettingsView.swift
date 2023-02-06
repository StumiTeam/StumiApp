//
//  SettingsView.swift
//  Stumi Test
//
//  Created by Jeremy Kwok on 8/16/22.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("Music") private var Music : Bool = true
    @AppStorage("Library Music") private var libraryMusic : Bool = true
    @AppStorage("Sound Effects") private var soundEffects : Bool = true
    
    
    var body: some View {
        NavigationView {
            
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
    
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}
