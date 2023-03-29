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
    //var user: User
    //@State var username = userViewModel.mainPlayer.username
    
    var body: some View {
        Text("\(userViewModel.mainPlayer.username)")
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
