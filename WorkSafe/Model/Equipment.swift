//
//  Equipment.swift
//  WorkSafe
//
//  Created by Andre Frank on 22.04.19.
//  Copyright © 2019 Afapps+. All rights reserved.
//

import CoreData

final class Equipment:NSManagedObject{
    
    @NSManaged fileprivate(set) var name:String
    @NSManaged fileprivate(set) var inventoryNumber:Int64
    @NSManaged fileprivate(set) var uniqueID:Int64
    @NSManaged fileprivate(set) var nextCheckDate:Date
    @NSManaged fileprivate(set) var photoURL:String
    @NSManaged fileprivate(set) var techInfo:String
    @NSManaged fileprivate(set) var type:Int16
    
    //Relationship toOne
    @NSManaged public fileprivate(set) var facility:Facility
}

extension Equipment:Managed{
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(nextCheckDate), ascending: false)]
    }
}

