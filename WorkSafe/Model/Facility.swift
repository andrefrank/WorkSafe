//
//  Facility.swift
//  WorkSafe
//
//  Created by Andre Frank on 22.04.19.
//  Copyright © 2019 Afapps+. All rights reserved.
//

import CoreData
import UIKit


final class Facility:NSManagedObject{
    @NSManaged  var department:String
    @NSManaged  var roomNumber:String
    @NSManaged  fileprivate(set) var plant:Int16
    @NSManaged  var floor:Int16
    @NSManaged  var photoURL:String?
    
    //Relationship toMany
    @NSManaged fileprivate(set) var equipments: Set<Equipment>
    
    public static func insert(into context: NSManagedObjectContext,department:String, photoURL:String?, roomNumber:String, plant:Int16=5,floor:Int16) -> Facility {
       
        let fac: Facility = context.insertObject()
        fac.department=department
        fac.floor=floor
        fac.plant=plant
        fac.photoURL=photoURL
        fac.roomNumber=roomNumber
        return fac
    }
    
    
    
}

extension Facility:Managed{
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(department), ascending: false)]
    }
}

