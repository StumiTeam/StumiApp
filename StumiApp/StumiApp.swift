//
//  StumiAppApp.swift
//  StumiApp
//
//  Created by Jeremy Kwok on 8/3/22.
//

import SwiftUI
import Firebase

@main
struct StumiApp: App {
    //@StateObject var dataManager = DataManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
