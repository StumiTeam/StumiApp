//
//  AchievementsView.swift
//  Stumi App
//
//  Created by Jeremy Kwok on 8/15/22.
//

import SwiftUI

struct AchievementsView: View {
    
    //View Models
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var sqliteManager: SQLiteManager
    
    @AppStorage("Total Study Time") var totalStudyTime = 0
    @AppStorage("Total Sessions") var totalSessions = 0
    //var user: User
    
    var body: some View {
        Text("Achievements")
    }
}

struct AchievementsView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementsView()
    }
}
