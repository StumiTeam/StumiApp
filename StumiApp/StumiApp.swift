//
//  StumiAppApp.swift
//  StumiApp
//
//  Created by Jeremy Kwok on 8/3/22.
//

import SwiftUI
import Firebase
import SQLite3

let sqliteManager = SQLiteManager.shared

//FOR DEVOs
struct AppSetupForDevelopers {
    static func initialize() {
        
        //open Database
        if sqliteManager.openDatabase() {
            sqliteManager.beginTransaction()
            
            sqliteManager.dropTable(tableName: "misc")
            sqliteManager.createTable(tableName: "misc", columns: miscTableColumns)
            
            sqliteManager.parseCSVFile(fileName: "Stumi SQLite3 Database - misc")
            sqliteManager.commit()
            
            sqliteManager.printTable(tableName: "misc")
            //sqliteManager.closeDatabase()
        }
        
        /*
        //Drop Tables
        sqliteManager.dropTable(tableName: "animals")
        sqliteManager.dropTable(tableName: "achievements")
        sqliteManager.dropTable(tableName: "furnitures")
        sqliteManager.dropTable(tableName: "misc")
        
        //Create Tables if needed
        sqliteManager.createTable(tableName: "animals", columns: animalsTableColumns)
        sqliteManager.createTable(tableName: "achievements", columns: achievementsTableColumns)
        sqliteManager.createTable(tableName: "furnitures", columns: furnituresTableColumns)
        sqliteManager.createTable(tableName: "misc", columns: miscTableColumns)
        
        //Populate Tables
        sqliteManager.parseCSVFile(fileName: "Stumi SQLite3 Database - misc")
        */
    }
}

@main
struct StumiApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var userViewModel = UserViewModel()
    
        //init() {FirebaseApp.configure()}
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userViewModel)
            
            /*
                .environmentObject(sqliteManager)
                .onAppear{
                    AppSetupForDevelopers.initialize()
                }
             */
        }
    }
    
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        sqliteManager.openDatabase()
        //sqliteManager.printTable(tableName: "misc")
        print("Finished launching")
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Close the database connection
        sqliteManager.closeDatabase()
    }
}
