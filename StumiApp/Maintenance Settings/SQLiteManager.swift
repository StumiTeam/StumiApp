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
    
    func createTable(tableName: String, columns: [(name: String, type: String)]) {
        
        var createStatement: OpaquePointer?
        
        let createQuery =
        """
        CREATE TABLE IF NOT EXISTS
        \(tableName)
        (\(columns.map {
            "\($0.name) \($0.type)"
        }.joined(separator: ", ")));
        """
        
        print("Create Query: \(createQuery)")
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
        
        //print("list:\(list)")
        
        var colList: String
        
        switch tableName {
            case "animals":
                colList = "entityName, description, sex, defMaxExp, maxExpInc, s1imgURL, s2imgURL, s3imgURL, s4imgURL"
            
            case "achievements":
                colList = "entityName, description, t1Req, t2Req, t3Req, t1imgURL, t2imgURL, t3imgURL"
            
            case "furnitures":
                colList = "entityName, description, price, libraryLevelReq, userLevelReq, imgURL"
            
            case "misc":
                colList = "entityName, description, imgURL"
            
            default:
                colList = ""
        }
        
        let placeholders = list.map { _ in "?"}.joined(separator: ", ")

        
        let addCommand =
            """
            INSERT INTO \(tableName) (\(colList)) VALUES (\(placeholders));
            """
        
        print("Add command: \(addCommand)")
        var addStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, addCommand, -1, &addStatement, nil) == SQLITE_OK {
            for (index, value) in list.enumerated() {
                let colIndex = Int32(index + 1)
                
                if let stringValue = value as? String {
                    sqlite3_bind_text(addStatement, colIndex, stringValue, -1, nil)
                } else if let intValue = value as? Int {
                    sqlite3_bind_int(addStatement, colIndex, Int32(intValue))
                } else if let boolValue = value as? Bool {
                    sqlite3_bind_int(addStatement, colIndex, boolValue ? 1 : 0 ) //1 for true, 0 for false
                } else if let dataValue = value as? Data {
                    sqlite3_bind_blob(addStatement, colIndex, (dataValue as NSData).bytes, Int32(dataValue.count), nil)
                }
            }
            
            //Execute the SQL statement
            if sqlite3_step(addStatement) != SQLITE_DONE {
                let error = String(cString: sqlite3_errmsg(db)!)
                print("Failed to add \(list[0]) to \(tableName): \(error)")
            } else {
                print("\(list[0]) added to \(tableName) Table!")
            }
            
            //Finalize statement
            sqlite3_finalize(addStatement)
            
        } else {
            
            let error = String(cString: sqlite3_errmsg(addStatement)!)
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
    (name: "id", type: "INTEGER PRIMARY KEY AUTOINCREMENT"),
    (name: "entityName", type: "TEXT"),
    (name: "description", type: "TEXT"),
    (name: "sex", type: "TEXT"),
    (name: "defMaxExp", type: "INT"),
    (name: "maxExpInc", type: "INT"),
    (name: "s1imgURL", type: "TEXT"),
    (name: "s2imgURL", type: "TEXT"),
    (name: "s3imgURL", type: "TEXT"),
    (name: "s4imgURL", type: "TEXT"),
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
]

let furnituresTableColumns = [
    (name: "id", type: "INTEGER PRIMARY KEY AUTOINCREMENT"),
    (name: "entityName", type: "TEXT"),
    (name: "description", type: "TEXT"),
    (name: "price", type: "INT"),
    (name: "libraryLevelReq", type: "INT"),
    (name: "userLevelReq", type: "INT"),
    (name: "imgURL", type: "TEXT")
]
    
let miscTableColumns = [
    (name: "id", type: "INTEGER PRIMARY KEY AUTOINCREMENT"),
    (name: "entityName", type: "TEXT"),
    (name: "description", type: "TEXT"),
    (name: "imgURL", type: "TEXT")
    //, (name: "howToObtain", type: "TEXT")
]
