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
    
    init() {}
    
    func openDatabase() -> Bool {
        
        // Get the URL for the database file in the app bundle
        guard let bundleDatabaseURL = Bundle.main.url(forResource: "GameEntities", withExtension: "db") else {
            print("Database file not found in the app bundle.")
            return false
        }

        // Get the URL for the writable location (e.g., documents directory)
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Documents directory not accessible.")
            return false
        }

        // Create the destination URL for the database file in the writable location
        let destinationURL = documentsURL.appendingPathComponent("db.db")

        // Copy the database file to the writable location if it doesn't exist
        if !FileManager.default.fileExists(atPath: destinationURL.path) {
            do {
                try FileManager.default.copyItem(at: bundleDatabaseURL, to: destinationURL)
            } catch {
                print("Failed to copy database file to the writable location: \(error)")
                return false
            }
        }

        // Open the database connection
        let flags = SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE
        if sqlite3_open_v2(destinationURL.path, &db, flags, nil) == SQLITE_OK {
            print("Database connection opened: \(destinationURL.path)")
            return true
        } else {
            print("Failed to open database connection.")
            return false
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
        
        if sqlite3_exec(db, createQuery, nil, nil, nil) == SQLITE_OK {
            print("\(tableName) Table created successfully.")
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db)!)
            print("Failed to create \(tableName) table: \(errorMessage)")
        }
        
        //Finalize statement
        sqlite3_finalize(createStatement)
    }
    
    func addEntity(tableName: String, list: [Any]){
        
        var colList: String
        
        switch tableName {
            case "animals":
                colList = "entityName, gender, biome, description, defBookRate, defMaxExp, maxExpInc, s1imgURL, s2imgURL, s3imgURL, s4imgURL"
            
            case "achievements":
                colList = "entityName, class, description, t1Req, t2Req, t3Req, t4Req, t1imgURL, t2imgURL, t3imgURL, t4imgURL"
            
            case "furnitures":
                colList = "entityName, description, price, libraryLevelReq, userLevelReq, imgURL"
            
            case "misc":
                colList = "entityName, description, imgURL"
            
            default:
                colList = ""
        }
        
        let placeholders = list.map { _ in "?"}.joined(separator: ", ")

        
        let addQuery =
            """
            INSERT INTO \(tableName) (\(colList)) VALUES (\(placeholders));
            """
        
        var addStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, addQuery, -1, &addStatement, nil) == SQLITE_OK {
            for (index, value) in list.enumerated() {
                let colIndex = Int32(index + 1)
                print("Value: \(value)")
                
                if let stringValue = value as? NSString {
                    print("String detected")//: \(stringValue)")
                    
                    if sqlite3_bind_text(addStatement, colIndex, stringValue.utf8String, -1, nil) == SQLITE_OK {
                        print("String bound")//: \(stringValue)")
                    }
                    
                } else if let intValue = value as? Int {
                    print("Integer detected: \(intValue)")
                    sqlite3_bind_int(addStatement, colIndex, Int32(intValue))
                    
                    
                } else if let boolValue = value as? Bool {
                    print("Boolean detected: \(boolValue)")
                    sqlite3_bind_int(addStatement, colIndex, boolValue ? 1 : 0 )
                    
                    //1 for true, 0 for false
                    
                } else if let dataValue = value as? Data {
                    print("Blob detected: \(dataValue)")
                    sqlite3_bind_blob(addStatement, colIndex, (dataValue as NSData).bytes, Int32(dataValue.count), nil)
                    
                }
            }
            
            //Execute the SQL statement
            if sqlite3_step(addStatement) != SQLITE_DONE {
                let error = String(cString: sqlite3_errmsg(db)!)
                print("Failed to add \(list[0]) to \(tableName): \(error)")
            } else {
//                print("0: \(list[0])")
//                print("1: \(list[1])")
//                print("2: \(list[2])")
                print("\(list[0]) added to \(tableName) table!")
            }
            
            //Finalize statement
            sqlite3_finalize(addStatement)
            //print("Statement finalized: \(String(describing: addStatement))")
            
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
    
    func parseCSVFile(fileName: String) { //-> [[Any]]? {
        
        print("File Name: \(fileName)")
        var tableName: String
        
        switch fileName {
            case "Stumi SQLite3 Database - animals":
                tableName = "animals"
            case "Stumi SQLite3 Database - achievements":
                tableName = "achievements"
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
                    print("rowData: \(rowData)")
                    parsedData.append(rowData)
                }
                
                print("parsedData \(parsedData)")
                for row in parsedData {
                    print("row: \(row)")
                    addEntity(tableName: tableName, list: row)
                }
                
                //return parsedData
                
            } catch {
                print("Error reading CSV file: \(error)")
                //return nil
            }
        } else {
            print("CSV file not found.")
            //return nil
        }
    }
    
    func printTable(tableName: String) {

        print("Table: \(tableName)")
        var printStatement: OpaquePointer?
        
        let printQuery =
        """
        SELECT * FROM \(tableName);
        """
        
        if sqlite3_prepare_v2(db, printQuery, -1, &printStatement, nil) == SQLITE_OK {
                while sqlite3_step(printStatement) == SQLITE_ROW {
                    let columnCount = sqlite3_column_count(printStatement)

                    for i in 0..<columnCount {
                        if let columnName = sqlite3_column_name(printStatement, i),
                           let columnValue = sqlite3_column_text(printStatement, i) {
                            let columnNameStr = String(cString: columnName)
                            let columnValueStr = String(cString: columnValue)
                            print("\(columnNameStr): \(columnValueStr)")
                        }
                    }
                }
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("Error preparing statement: \(errorMessage)")
            }

            sqlite3_finalize(printStatement)
    }
    
    func beginTransaction() {
        let beginTransactionQuery = "BEGIN TRANSACTION;"
        
        var beginStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, beginTransactionQuery, -1, &beginStatement, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Failed to prepare begin transaction statement. Error: \(errorMessage)")
            return
        }
            
        if sqlite3_step(beginStatement) != SQLITE_DONE {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Failed to execute begin transaction statement. Error: \(errorMessage)")
        }
        
        sqlite3_finalize(beginStatement)
        print("beginStatement done")
    }
    
    func commit() {
        let commitStatement = "COMMIT;"
        
        if sqlite3_exec(db, commitStatement, nil, nil, nil) == SQLITE_OK {
                print("Transaction committed successfully.")
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("Failed to commit transaction. Error: \(errorMessage)")
            }
    }
}

let animalsTableColumns = [
    (name: "id", type: "INTEGER PRIMARY KEY AUTOINCREMENT"),
    (name: "entityName", type: "TEXT"),
    (name: "gender", type: "TEXT"),
    (name: "biome", type: "TEXT"),
    (name: "description", type: "TEXT"),
    (name: "defBookRate", type: "INT"),
    (name: "defMaxExp", type: "INT"),
    (name: "maxExpInc", type: "INT"),
    (name: "s1imgURL", type: "TEXT"),
    (name: "s2imgURL", type: "TEXT"),
    (name: "s3imgURL", type: "TEXT"),
    (name: "s4imgURL", type: "TEXT")
    
//    (name: "ms1imgURL", type: "TEXT"),
//    (name: "ms2imgURL", type: "TEXT"),
//    (name: "ms3imgURL", type: "TEXT"),
//    (name: "ms4imgURL", type: "TEXT"),
//    (name: "fs1imgURL", type: "TEXT"),
//    (name: "fs2imgURL", type: "TEXT"),
//    (name: "fs3imgURL", type: "TEXT"),
//    (name: "fs4imgURL", type: "TEXT"),
]

let achievementsTableColumns = [
    (name: "id", type: "INTEGER PRIMARY KEY AUTOINCREMENT"),
    (name: "entityName", type: "TEXT"),
    (name: "class", type: "TEXT"),
    (name: "description", type: "TEXT"),
    (name: "t1Req", type: "INT"),
    (name: "t2Req", type: "INT"),
    (name: "t3Req", type: "INT"),
    (name: "t4Req", type: "INT"),
    (name: "t1imgURL", type: "TEXT"),
    (name: "t2imgURL", type: "TEXT"),
    (name: "t3imgURL", type: "TEXT"),
    (name: "t4imgURL", type: "TEXT")
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
]
