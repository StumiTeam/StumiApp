//
//  StumiAppApp.swift
//  StumiApp
//
//  Created by Jeremy Kwok on 8/3/22.
//

import SwiftUI
import Firebase

let sqliteManager = SQLiteManager()

//FOR DEVOs
struct AppSetupForDevelopers {
    static func initialize() {
        //open Database
        sqliteManager.openDatabase()
        
        //Create Tables if needed
        sqliteManager.createTable(tableName: "animals", columns: animalsTableColumns)
        sqliteManager.createTable(tableName: "achievements", columns: achievementsTableColumns)
        sqliteManager.createTable(tableName: "furnitures", columns: furnituresTableColumns)
        sqliteManager.createTable(tableName: "misc", columns: miscTableColumns)
        
        //See if there are new entities to add
        sqliteManager.parseCSVFile(fileName: "Stumi SQLite3 Database - misc")
    }
}



@main
struct StumiApp: App {

    @StateObject var userViewModel = UserViewModel()
    let sqliteManager = SQLiteManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userViewModel)
                .environmentObject(sqliteManager)
            
                .onAppear{
                    AppSetupForDevelopers.initialize()
                }
             
        }
    }
}
