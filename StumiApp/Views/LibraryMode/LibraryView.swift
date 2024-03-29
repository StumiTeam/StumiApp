//
//  LibraryView.swift
//  StumiApp
//
//  Created by Jeremy Kwok on 8/28/22.
//

import SwiftUI

struct LibraryView: View {
    
    //View Models
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var sqliteManager: SQLiteManager
    
    var body: some View {
        Text("Library Mode!")
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
