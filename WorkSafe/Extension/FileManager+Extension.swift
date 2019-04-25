//
//  FileManager+Extension.swift
//  WorkSafe
//
//  Created by Andre Frank on 24.04.19.
//  Copyright © 2019 Afapps+. All rights reserved.
//

import UIKit

extension FileManager {
    static func documentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return NSString(string: paths[0])
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func createUserDirectory(withName name: String) -> Bool {
        let userDocumentDirectory = FileManager.documentsDirectory().appendingPathComponent(name)
        var isDirectory: ObjCBool = false
        
        // Create directory if it doesn't exist
        if !FileManager.default.fileExists(atPath: userDocumentDirectory, isDirectory: &isDirectory) {
            do {
                try FileManager.default.createDirectory(atPath: userDocumentDirectory, withIntermediateDirectories: false, attributes: nil)
                print("Directory is now created...")
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        }
        print("Directory already exists")
        return true // Directory already exists
    }
    
    func createFileInUserDirectory(pathComponent: String, fileName: String, data: Data) -> String? {
        if createUserDirectory(withName: pathComponent) {
            let filePath = FileManager.documentsDirectory().appendingPathComponent(pathComponent) + "/" + fileName
            
            if FileManager.default.createFile(atPath: filePath, contents: data, attributes: nil) {
                return pathComponent + "/" + fileName
            }
        }
        return nil
    }
    
    func deleteFileInUserDirectory(fileName:String)->Bool{
        let filePath = FileManager.documentsDirectory().appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: filePath){
            do{
                try FileManager.default.removeItem(atPath: filePath)
                return true
            }catch let error{
                print(error.localizedDescription)
                return false
            }
        }
        return false
    }
    
    
    func createFileInUserDirectory(pathComponent: String, fileName: String, data: Data, useEnumeratedFileName: Bool = false) -> String? {
       
        //Create the user directory first if it doesn't exist
        if createUserDirectory(withName: pathComponent) {
            //Building path for the file
            var filePath = FileManager.documentsDirectory().appendingPathComponent(pathComponent)
            let ext=NSString(string: fileName).pathExtension
            let fileName=NSString(string: fileName).deletingPathExtension
            var newNumber:String=""
            
            //If the directory should contain continous serial numbers change file name 1....xxx
            // File1.ext.....File99.ext
            if useEnumeratedFileName {
                let enumerator = FileManager.default.enumerator(atPath: filePath)
                //Get all existing files from directory
                let files = enumerator?.allObjects as! [String]
                //Check existance of a file just in case...
                if files.count > 0 {
                    let enumeratedNumber = files.reduce(1) {
                        (result, currentFile) -> Int in
                        var intermediateResult:Int=0
                        
                        let fileWithoutExt = NSString(string: currentFile).deletingPathExtension
                        guard fileWithoutExt.onlyNumbers().count > 0 else {return result}
                        print(fileWithoutExt.onlyNumbers()[0].intValue)
                        
                        
                        if fileWithoutExt.onlyNumbers()[0].intValue > result{
                            intermediateResult=fileWithoutExt.onlyNumbers()[0].intValue
                            return intermediateResult
                        }
                        
                        return result
                    }
                    
                    //Build new filename with extracted number adding by 1
                    newNumber = "\(enumeratedNumber+1)"
                    filePath = filePath + "/" + fileName + newNumber + "." + ext
                    
                } else {
                    //Currently no file exist so append number "1"
                    newNumber="1"
                    filePath = filePath + "/" + fileName + newNumber + "." + ext
                }
                
            } else {
                filePath = filePath + "/" + fileName
            }
            
            if FileManager.default.createFile(atPath: filePath, contents: data, attributes: nil) {
                print(pathComponent + "/" + fileName+newNumber + "." + ext)
                return pathComponent + "/" + fileName+newNumber + "." + ext
                
            }
        }
        return nil
    }
}
