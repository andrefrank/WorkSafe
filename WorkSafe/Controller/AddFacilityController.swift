//
//  AddFacilityController.swift
//  WorkSafe
//
//  Created by Andre Frank on 22.04.19.
//  Copyright © 2019 Afapps+. All rights reserved.
//

import UIKit
import CoreData



class AddFacilityController: UITableViewController {

    var facilitiy:Facility?
    var managedContext:NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
    

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        
        managedContext.performChanges {[weak self] in
            guard let mySelf=self else {return}
            _ = Facility.insert(into: mySelf.managedContext, department: "Production", photoURL: "test.jpg", roomNumber: "1.028", floor: 0)
        }
    }
}
