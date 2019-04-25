//
//  FileManager+Extension.swift
//  WorkSafe
//
//  Created by Andre Frank on 24.04.19.
//  Copyright © 2019 Afapps+. All rights reserved.
//

import UIKit

extension FileManager{
    static func documentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return NSString(string: paths[0])
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func createUserDirectory(withName name:String)->Bool{
        let userDocumentDirectory=FileManager.documentsDirectory().appendingPathComponent(name)
        var isDirectory:ObjCBool=false
        
        //Create directory if it doesn't exist
        if !FileManager.default.fileExists(atPath: userDocumentDirectory, isDirectory: &isDirectory){
            do {
                
                try FileManager.default.createDirectory(atPath:userDocumentDirectory , withIntermediateDirectories: false, attributes: nil)
                print("Directory is now created...")
                return true
            }catch let error{
                print(error.localizedDescription)
                return false
            }
        }
        print("Directory already exists")
        return true  //Directory already exists
    }
    
    func createFileInUserDirectory(pathComponent:String, fileName:String, data:Data)->String?{
        if createUserDirectory(withName: pathComponent){
            
            let filePath=FileManager.documentsDirectory().appendingPathComponent(pathComponent) + "/" + fileName
            
            if FileManager.default.createFile(atPath: filePath, contents: data, attributes: nil){
                return pathComponent+"/"+fileName
            }
        }
        return nil
    }
    
    
}
