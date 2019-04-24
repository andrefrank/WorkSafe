//
//  UIImage+Extension.swift
//  WorkSafe
//
//  Created by Andre Frank on 24.04.19.
//  Copyright © 2019 Afapps+. All rights reserved.
//

import UIKit

extension UIImage {
    
    func saveToDocuments(pathComponent:String,filename:String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(pathComponent+"/"+filename)
        if let data = self.jpegData(compressionQuality: 1.0) {
            do {
                try data.write(to: fileURL)
            } catch {
                print("error saving file to documents:", error)
            }
        }
    }
    
}

func loadImageFromDocumentDirectory(pathComponent:String,nameOfImage : String) -> UIImage {
    let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
    let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
    let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
    if let dirPath = paths.first{
        let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(pathComponent+"/"+nameOfImage)
        guard let image = UIImage(contentsOfFile: imageURL.path) else { return  UIImage.init(named: "fulcrumPlaceholder")!}
        return image
    }
    return UIImage.init(named: "imageDefaultPlaceholder")!
}
