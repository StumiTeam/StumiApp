//
//  ContentViewModel.swift
//  StumiApp
//
//  Created by Jeremy Kwok on 3/31/23.
//

import Foundation
import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var showButton = true
    @Published var showMenu: Bool = false
    @Published var showPage : Int = 0
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
    
    func showButtonToggle() {
        showButton.toggle()
    }
}
