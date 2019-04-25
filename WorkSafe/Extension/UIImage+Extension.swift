//
//  UIImage+Extension.swift
//  WorkSafe
//
//  Created by Andre Frank on 24.04.19.
//  Copyright © 2019 Afapps+. All rights reserved.
//

import UIKit

extension UIImage {
    func saveToUserDirectory(pathComponent:String, filename: String)->String?{
        if let data = self.jpegData(compressionQuality: 1.0) {
            return FileManager.default.createFileInUserDirectory(pathComponent: pathComponent, fileName: filename, data: data)
        }
        return nil
    }
    
    

    static func loadImageFromUserDirectory(imageName: String,pathComponent path:String ) -> UIImage? {
        
        let filePath=FileManager.documentsDirectory().appendingPathComponent(path)+"/"+imageName
    
        if FileManager.default.fileExists(atPath: filePath){
            guard let data=FileManager.default.contents(atPath: filePath) else {return nil}
            return UIImage(data: data)
        }
        
        return nil
    }
    
    static func loadImageFromUserDirectory(photoURL:String ) -> UIImage? {
        
        let filePath=FileManager.documentsDirectory().appendingPathComponent(photoURL)
        if FileManager.default.fileExists(atPath: filePath){
            guard let data=FileManager.default.contents(atPath: filePath) else {return nil}
            return UIImage(data: data)
        }
        
        return nil
    }
    
    
}
