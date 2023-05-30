//
//  ProfileView.swift
//  Stumi Test
//
//  Created by Jeremy Kwok on 8/16/22.
//

import SwiftUI

struct ProfileView: View {
    
    //View Models
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var sqliteManager: SQLiteManager
    
    //var user: User
    
    var body: some View {
        Text("\(userViewModel.mainPlayer.username)")
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
