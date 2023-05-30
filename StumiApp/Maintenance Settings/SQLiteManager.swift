//
//  SQLiteManager.swift
//  StumiApp
//
//  Created by Jeremy Kwok on 5/6/23.
//

// This file should handle ALL of the SQLite3 functions and anything related to the game default database calling

import SwiftUI
import SQLite3
import Foundation

class SQLiteManager: ObservableObject {
    static let shared = SQLiteManager()
    
    private var db: OpaquePointer?
    
    let dbURL = try! FileManager.default
        .url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        .appendingPathComponent("db.db")
    
    init() {
        openDatabase()
    }
    
    deinit {
        closeDatabase()
    }
    
    func openDatabase() {
        if sqlite3_open(dbURL.path, &db) == SQLITE_OK {
            print("Database opened successfully.")
        } else {
            print("Failed to open database")
        }
    }
    
    func closeDatabase() {
        if sqlite3_close(db) == SQLITE_OK {
            print("Database closed successfully")
        } else {
            print("Failed to close database")
        }
    }
    
    func createTable(tableName: String, columns: [(name: String, type: String, unique: Bool)]) {
        
        var createStatement: OpaquePointer?
        
        let createQuery =
        """
        CREATE TABLE IF NOT EXISTS
        \(tableName)
        (\(columns.map {
            "\($0.name) \($0.type) \($0.unique ? "UNIQUE" : "") )"
        }.joined(separator: ", ")));
        """
        
        guard sqlite3_prepare_v2(db, createQuery, -1, &createStatement, nil) == SQLITE_OK else {
            print("Failed to prepare table creation statement.")
            return
        }
        
        guard sqlite3_step(createStatement) == SQLITE_DONE else {
            print("Failed to create table \(tableName).")
            return
        }
        
        print("\(tableName) Table created successfully.")
        
        //Finalize statement
        sqlite3_finalize(createStatement)
    }
    
    func addEntity(tableName: String, list: [Any]){
        
        let placeholders = list.map { _ in "?"}.joined(separator: ", ")
        let addCommand =
            """
            INSERT INTO \(tableName) VALUES (\(placeholders));
            """
        
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, addCommand, -1, &statement, nil) == SQLITE_OK {
            for (index, value) in list.enumerated() {
                let colIndex = Int32(index + 1)
                
                if let stringValue = value as? String {
                    sqlite3_bind_text(statement, colIndex, stringValue, -1, nil)
                } else if let intValue = value as? Int {
                    sqlite3_bind_int(statement, colIndex, Int32(intValue))
                } else if let boolValue = value as? Bool {
                    sqlite3_bind_int(statement, colIndex, boolValue ? 1 : 0 ) //1 for true, 0 for false
                } else if let dataValue = value as? Data {
                    sqlite3_bind_blob(statement, colIndex, (dataValue as NSData).bytes, Int32(dataValue.count), nil)
                }
            }
            
            //Execute the SQL statement
            if sqlite3_step(statement) != SQLITE_DONE {
                let error = String(cString: sqlite3_errmsg(db)!)
                print("Failed to add \(list[0]) to \(tableName): \(error)")
            } else {
                print("\(list[0]) added \(tableName)!")
            }
            
            //Finalize statement
            sqlite3_finalize(statement)
            
        } else {
            
            let error = String(cString: sqlite3_errmsg(db)!)
            print("Failed to add statement: \(error)")
            
        }
    }
    
    func dropTable(tableName: String) {
        
        var dropStatement: OpaquePointer?
        
        let dropQuery =
        """
        DROP TABLE IF EXISTS \(tableName);
        """
        
        guard sqlite3_prepare_v2(db, dropQuery, -1, &dropStatement, nil) == SQLITE_OK else {
            print("Failed to prepare table drop statement.")
            return
        }
        
        guard sqlite3_step(dropStatement) == SQLITE_DONE else {
            print("Failed to drop table \(tableName).")
            return
        }
        
        print("\(tableName) Table dropped successfully.")
        
        //Finalize statement
        sqlite3_finalize(dropStatement)
        
    }
    
    func updateTable(tableName: String, data: [[Any]]){
        
        var placeholders = data[0].map { _ in "?"}.joined(separator: ", ")
        
        /*
        //Find table name and change insert command accordingly
        switch tableName{
            case "animals":
                placeholders = "entityName, description, sex, defaultMaxExp, maxExpInc, s1imgURL, s2imgURL, s3imgURL, s4imgURL"
            
            case "achievements":
                placeholders = "?, ?, ?, ?, ?, ?, ?, ?, ?"
            //"entityName, description, sex, defMaxExp, maxExpInc, s1imgURL, s2imgURL, s3imgURL, s4imgURL"
            
            case "furnitures":
                placeholders =
            
            case "misc":
                placeholders =
            
            default:
                placeholders =
        }
         */
        
        //Prepare the SQL statement for inserting the new data
        let addCommand =
            """
            INSERT INTO \(tableName) VALUES (\(placeholders));
            """
    }
    
    func parseCSVFile(fileName: String) -> [[Any]]? {
        
        print("File Name: \(fileName)")
        var tableName = ""
        
        switch fileName {
            case "Stumi SQLite3 Database - animals":
                tableName = "animals"
            case "Stumi SQLite3 Database - furnitures":
                tableName = "furnitures"
            case "Stumi SQLite3 Database - misc":
                tableName = "misc"
            default:
                tableName = ""
        }
        
        if let fileURL = Bundle.main.url(forResource: fileName, withExtension: "csv"){
            do {
                let data = try String(contentsOf: fileURL)
                var rows = data.components(separatedBy: "\r\n")
                
                //remove the first row (header)
                rows.removeFirst()
                
                if rows.last?.isEmpty == true {
                    rows.removeLast()
                }
                print("rows: \(rows)")
                
                var parsedData: [[Any]] = []
                
                for row in rows {
                    var columns: [Any] = []
                    
                    var insideQuotes = false
                    var currentCol = ""
                    
                    for character in row {
                        if character == "\"" {
                            insideQuotes.toggle()
                        } else if character == "," {
                            if insideQuotes {
                                currentCol.append(character)
                            } else {
                                if let intValue = Int(currentCol){
                                    columns.append(intValue)
                                } else {
                                    columns.append(currentCol.trimmingCharacters(in: .whitespaces))
                                }
                                currentCol = ""
                            }
                        } else {
                            currentCol.append(character)
                        }
                    }
                    
                    if let intValue = Int(currentCol) {
                        columns.append(intValue)
                    } else {
                        columns.append(currentCol.trimmingCharacters(in: .whitespaces))
                    }
                    
                    //Remove the first column
                    let rowData = Array(columns.dropFirst())
                    parsedData.append(rowData)
                }
                
                print("parsedData \(parsedData)")
                for row in parsedData {
                    addEntity(tableName: tableName, list: row)
                    print("row: \(row)")
                }
                
                return parsedData
                
            } catch {
                print("Error reading CSV file: \(error)")
                return nil
            }
        } else {
            print("CSV file not found.")
            return nil
        }
    }
    
}

let animalsTableColumns = [
    (name: "id", type: "INTEGER PRIMARY KEY AUTOINCREMENT", unique: true),
    (name: "entityName", type: "TEXT", unique: true),
    (name: "description", type: "TEXT", unique: false),
    (name: "sex", type: "TEXT", unique: false),
    (name: "defMaxExp", type: "INT", unique: false),
    (name: "maxExpInc", type: "INT", unique: false),
    (name: "s1imgURL", type: "TEXT", unique: false),
    (name: "s2imgURL", type: "TEXT", unique: false),
    (name: "s3imgURL", type: "TEXT", unique: false),
    (name: "s4imgURL", type: "TEXT", unique: false),
]

let achievementsTableColumns = [
    (name: "id", type: "INTEGER PRIMARY KEY AUTOINCREMENT"),
    (name: "entityName", type: "TEXT"),
    (name: "description", type: "TEXT"),
    (name: "t1Req", type: "INT"),
    (name: "t2Req", type: "INT"),
    (name: "t3Req", type: "INT"),
    (name: "t1imgURL", type: "TEXT"),
    (name: "t2imgURL", type: "TEXT"),
    (name: "t3imgURL", type: "TEXT"),
] as [Any]

let furnituresTableColumns = [
    (name: "id", type: "INTEGER PRIMARY KEY AUTOINCREMENT"),
    (name: "entityName", type: "TEXT"),
    (name: "description", type: "TEXT"),
    (name: "price", type: "INT"),
    (name: "libraryLevelReq", type: "INT"),
    (name: "userLevelReq", type: "INT"),
    (name: "imgURL", type: "TEXT")
] as [Any]
    
let miscTableColumns = [
    (name: "id", type: "INTEGER PRIMARY KEY AUTOINCREMENT"),
    (name: "entityName", type: "TEXT"),
    (name: "description", type: "TEXT"),
    (name: "imgURL", type: "TEXT")
    //, (name: "howToObtain", type: "TEXT")
]
