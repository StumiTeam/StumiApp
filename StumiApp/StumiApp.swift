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
            
            //If need to update tables (UNCOMMENT FOR DEVS ONLY IF UPDATE, RECOMMENT BEFORE RELEASING APP)
            
              sqliteManager.beginTransaction() //Not needed to print table
            
              //Drop Tables
              sqliteManager.dropTable(tableName: "animals")
              sqliteManager.dropTable(tableName: "achievements")
              sqliteManager.dropTable(tableName: "furnitures")
              sqliteManager.dropTable(tableName: "misc")
            
              //Create Tables if Needed
              sqliteManager.createTable(tableName: "animals", columns: animalsTableColumns)
              sqliteManager.createTable(tableName: "achievements", columns: achievementsTableColumns)
              sqliteManager.createTable(tableName: "furnitures", columns: furnituresTableColumns)
              sqliteManager.createTable(tableName: "misc", columns: miscTableColumns)
            
              //Populate Tables
              sqliteManager.parseCSVFile(fileName: "Stumi SQLite3 Database - animals")
              sqliteManager.parseCSVFile(fileName: "Stumi SQLite3 Database - achievements")
              sqliteManager.parseCSVFile(fileName: "Stumi SQLite3 Database - furnitures")
              sqliteManager.parseCSVFile(fileName: "Stumi SQLite3 Database - misc")
              
              //Commit
              sqliteManager.commit()
            
              //Print out Table Contents
              sqliteManager.printTable(tableName: "animals")
              sqliteManager.printTable(tableName: "achievements")
              sqliteManager.printTable(tableName: "misc")
             
              //Close database
              sqliteManager.closeDatabase()
             
        }
    }
    static func readDB() {
        if sqliteManager.openDatabase() {
            print("Reading tables...")
            
            /*
                Print tables
                print("Printing tables... ")
                sqliteManager.printTable(tableName: "animals")
                sqliteManager.printTable(tableName: "achievements")
                sqliteManager.printTable(tableName: "misc")
            */
        }
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
            
                .environmentObject(sqliteManager)
                .onAppear{
                    //UNCOMMENT FOR WHEN YOU NEED TO UPDATE THE APP BUNDLE'S DATABASE ONLY. MAKE SURE THE CVS FILES ARE UPDATED AND ALIGN WITH THE CODE WITH SQLiteManager.swift. After taking the new db.db file out of your simulation folder, replace the db.db folder in here with that one.
                    //AppSetupForDevelopers.initialize()
                    AppSetupForDevelopers.readDB()
                }
             
        }
    }
    
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        //sqliteManager.openDatabase()
        print("Finished launching")
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Close the database connection when app is closed
        sqliteManager.closeDatabase()
    }
}
