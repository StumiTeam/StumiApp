//
//  TitleView.swift
//  StumiApp
//
//  Created by Jeremy Kwok on 4/7/23.
//

import SwiftUI

struct TitleView: View {
    
    //View Models
    @EnvironmentObject var userViewModel: UserViewModel
    //@EnvironmentObject var contentViewModel: ContentViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                Image("Cow")
                    .resizable()
                    .aspectRatio(CGSize(width:1, height:1), contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                
                Text("Title Page")
            }
            .onTapGesture {
                print("TAPPED")
                userViewModel.syncUser()
                print("User Synced")
                //contentViewModel.showButton = true
                //contentViewModel.showPage = 0
            }
        }
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}
